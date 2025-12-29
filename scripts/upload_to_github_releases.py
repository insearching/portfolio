#!/usr/bin/env python3
"""
GitHub Releases Upload Script with Stable URL Generation

This script uploads build artifacts to GitHub Releases and generates a stable
download URL that remains constant across builds.

Features:
- Publishes to 'latest' release tag (creates if missing)
- Overwrites existing assets for stable URLs
- Validates file existence and GitHub authentication
- GitHub Actions compatible with output support
- Comprehensive error handling

Requirements:
- Python 3.7+
- PyGithub library
- GITHUB_TOKEN environment variable

Usage:
    python upload_to_github_releases.py <file_path> --asset-name <name> [options]
"""

import argparse
import os
import sys
from pathlib import Path
from typing import Optional

try:
    from github import Github, GithubException, UnknownObjectException
except ImportError:
    print("ERROR: PyGithub library not found. Install with: pip install PyGithub", file=sys.stderr)
    sys.exit(1)


class GitHubReleaseError(Exception):
    """Custom exception for GitHub release errors."""
    pass


class GitHubReleaseUploader:
    """
    Handles uploading artifacts to GitHub Releases with stable URLs.
    
    This class implements the complete workflow:
    1. Authenticate with GitHub
    2. Get or create 'latest' release
    3. Delete existing asset (if present)
    4. Upload new asset
    5. Generate stable download URL
    """
    
    RELEASE_TAG = "latest"
    RELEASE_TITLE = "Latest Build"
    RELEASE_NOTES = "CI-managed rolling release. This is automatically updated on every push to develop branch."
    
    def __init__(self, token: str, repository: str):
        """
        Initialize the GitHub Release uploader.
        
        Args:
            token: GitHub authentication token
            repository: Repository in format "owner/repo"
        
        Raises:
            GitHubReleaseError: If authentication fails
        """
        if not token:
            raise GitHubReleaseError("GitHub token is required")
        
        if not repository or "/" not in repository:
            raise GitHubReleaseError(f"Invalid repository format: {repository}. Expected 'owner/repo'")
        
        try:
            self.github = Github(token)
            self.repo = self.github.get_repo(repository)
            self.repository = repository
            
            # Test authentication
            _ = self.repo.name
            print(f"✓ Authenticated to repository: {repository}")
            
        except GithubException as e:
            raise GitHubReleaseError(f"GitHub authentication failed: {e.data.get('message', str(e))}")
    
    def get_or_create_release(self):
        """
        Get the 'latest' release or create it if it doesn't exist.
        
        Returns:
            GitHub Release object
        
        Raises:
            GitHubReleaseError: If unable to get or create release
        """
        print(f"[1/3] Checking for release '{self.RELEASE_TAG}'...")
        
        try:
            # Try to get existing release
            release = self.repo.get_release(self.RELEASE_TAG)
            print(f"✓ Release '{self.RELEASE_TAG}' found")
            return release
            
        except UnknownObjectException:
            # Release doesn't exist, create it
            print(f"Creating new release: {self.RELEASE_TAG}")
            
            try:
                release = self.repo.create_git_release(
                    tag=self.RELEASE_TAG,
                    name=self.RELEASE_TITLE,
                    message=self.RELEASE_NOTES,
                    draft=False,
                    prerelease=False
                )
                print(f"✓ Release '{self.RELEASE_TAG}' created")
                return release
                
            except GithubException as e:
                raise GitHubReleaseError(f"Failed to create release: {e.data.get('message', str(e))}")
    
    def delete_existing_asset(self, release, asset_name: str) -> bool:
        """
        Delete an existing asset if it exists (for overwrite behavior).
        
        Args:
            release: GitHub Release object
            asset_name: Name of the asset to delete
        
        Returns:
            True if asset was deleted, False if it didn't exist
        """
        try:
            for asset in release.get_assets():
                if asset.name == asset_name:
                    print(f"  Deleting existing asset: {asset_name}")
                    asset.delete_asset()
                    return True
            return False
        except GithubException as e:
            print(f"  Warning: Could not delete existing asset: {e.data.get('message', str(e))}", file=sys.stderr)
            return False
    
    def upload_file(
        self,
        file_path: str,
        asset_name: Optional[str] = None
    ) -> str:
        """
        Upload a file to GitHub Releases 'latest' tag with overwrite support.
        
        Args:
            file_path: Path to the file to upload
            asset_name: Name for the asset (defaults to filename)
        
        Returns:
            Stable download URL
        
        Raises:
            GitHubReleaseError: If upload fails
            FileNotFoundError: If file doesn't exist
        """
        file_path_obj = Path(file_path)
        
        if not file_path_obj.exists():
            raise FileNotFoundError(f"File not found: {file_path}")
        
        if not file_path_obj.is_file():
            raise GitHubReleaseError(f"Path is not a file: {file_path}")
        
        # Use provided asset name or default to filename
        if not asset_name:
            asset_name = file_path_obj.name
        
        print()
        print("=" * 60)
        print("GitHub Releases Upload - Stable URL Generator")
        print("=" * 60)
        print(f"File: {file_path}")
        print(f"Asset name: {asset_name}")
        print(f"File size: {file_path_obj.stat().st_size / (1024*1024):.2f} MB")
        print()
        
        # Get or create the release
        release = self.get_or_create_release()
        
        # Delete existing asset (overwrite behavior)
        print("[2/3] Preparing to upload asset...")
        self.delete_existing_asset(release, asset_name)
        
        # Upload the new asset
        try:
            print(f"  Uploading: {asset_name}")
            release.upload_asset(
                path=str(file_path_obj),
                label=asset_name,
                name=asset_name
            )
            print("✓ Asset uploaded successfully")
            
        except GithubException as e:
            raise GitHubReleaseError(f"Failed to upload asset: {e.data.get('message', str(e))}")
        
        # Generate stable URL
        print("[3/3] Generating stable download URL...")
        stable_url = f"https://github.com/{self.repository}/releases/latest/download/{asset_name}"
        print(f"✓ Stable URL: {stable_url}")
        
        return stable_url


def main():
    """Main entry point for the script"""
    parser = argparse.ArgumentParser(
        description="Upload artifacts to GitHub Releases with stable URLs",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Upload APK with default name
  python upload_to_github_releases.py build/app.apk
  
  # Upload with custom asset name
  python upload_to_github_releases.py build/app.apk --asset-name app-release.apk
  
  # With GitHub Actions output
  python upload_to_github_releases.py build/app.apk --asset-name app-release.apk --github-output
        """
    )
    
    parser.add_argument(
        "file_path",
        help="Path to the file to upload"
    )
    parser.add_argument(
        "--asset-name",
        help="Name for the asset in GitHub Releases (defaults to filename)"
    )
    parser.add_argument(
        "--token",
        help="GitHub authentication token (defaults to GITHUB_TOKEN env var)"
    )
    parser.add_argument(
        "--repository",
        help="Repository in format 'owner/repo' (defaults to GITHUB_REPOSITORY env var)"
    )
    parser.add_argument(
        "--github-output",
        action="store_true",
        help="Output in GitHub Actions format"
    )
    parser.add_argument(
        "--url-only",
        action="store_true",
        help="Output only the stable URL (for CI/CD pipelines)"
    )
    
    args = parser.parse_args()
    
    # Get token from args or environment
    token = args.token or os.environ.get("GITHUB_TOKEN")
    if not token:
        print("ERROR: GitHub token required. Set GITHUB_TOKEN env var or use --token", file=sys.stderr)
        return 1
    
    # Get repository from args or environment
    repository = args.repository or os.environ.get("GITHUB_REPOSITORY")
    if not repository:
        print("ERROR: Repository required. Set GITHUB_REPOSITORY env var or use --repository", file=sys.stderr)
        return 1
    
    try:
        # Initialize uploader
        uploader = GitHubReleaseUploader(
            token=token,
            repository=repository
        )
        
        # Upload the file
        stable_url = uploader.upload_file(
            file_path=args.file_path,
            asset_name=args.asset_name
        )
        
        # Validate URL format
        print()
        print("Validating stable URL format...")
        
        expected_pattern = f"https://github.com/{repository}/releases/latest/download/"
        if not stable_url.startswith(expected_pattern):
            print(f"\n⚠ ERROR: URL validation failed!", file=sys.stderr)
            print(f"Expected URL starting with: {expected_pattern}", file=sys.stderr)
            print(f"Got: {stable_url}", file=sys.stderr)
            return 1
        
        print("✓ URL format is valid")
        
        # Output based on flags
        if args.url_only:
            print()
            print(stable_url)
            return 0
        
        # Print results
        print()
        print("=" * 60)
        print("Upload Complete!")
        print("=" * 60)
        print(f"Stable Download URL:")
        print(f"  {stable_url}")
        print()
        print("This URL will always point to the latest uploaded file.")
        print("=" * 60)
        print()
        
        # Output for GitHub Actions
        if args.github_output:
            github_output = os.environ.get("GITHUB_OUTPUT")
            if github_output:
                with open(github_output, "a") as f:
                    f.write(f"stable_url={stable_url}\n")
                print("✓ GitHub Actions output written")
            else:
                print("# Environment variable format:")
                print(f"export STABLE_URL='{stable_url}'")
        
        return 0
        
    except FileNotFoundError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return 1
    except GitHubReleaseError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return 1
    except Exception as e:
        print(f"UNEXPECTED ERROR: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())
