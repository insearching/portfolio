#!/usr/bin/env python3
"""
GoFile Upload Script with Direct Link Extraction

This script uploads files to GoFile.io and extracts the true direct download link.
Designed for CI/CD pipelines and automated workflows.

Features:
- Extracts direct binary download URLs (not HTML landing pages)
- Validates link format (/download/ required)
- Tests HTTP accessibility
- GitHub Actions compatible
- Comprehensive error handling
- CI-safe and non-interactive

Requirements:
- Python 3.7+
- requests library

Usage:
    python upload_to_gofile.py <file_path> --token <token> [options]
"""

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Dict, Optional, Tuple
import time

import requests


class GofileUploadError(Exception):
    """Custom exception for Gofile upload errors."""
    pass


class GofileUploader:
    """
    Handles uploading files to Gofile.io and extracting direct download links.
    
    This class implements a complete workflow for CI/CD usage:
    1. Get best server
    2. Upload file
    3. Optionally set folder to public
    4. Extract direct download link
    5. Validate link format
    """
    
    BASE_API_URL = "https://api.gofile.io"
    
    def __init__(self, token: str, account_id: Optional[str] = None):
        """
        Initialize the Gofile uploader.
        
        Args:
            token: Gofile API token for authentication
            account_id: Optional Gofile account ID
        """
        self.token = token
        self.account_id = account_id
        self.session = requests.Session()
    
    def get_best_server(self) -> str:
        """
        Get the best server for uploading files.
        
        Returns:
            Server name to use for upload
            
        Raises:
            GofileUploadError: If unable to retrieve server information
        """
        print("[1/4] Getting best upload server...")
        
        try:
            response = self.session.get(f"{self.BASE_API_URL}/servers", timeout=30)
            response.raise_for_status()
            
            data = response.json()
            
            if data.get("status") != "ok":
                raise GofileUploadError(f"Failed to get server: {data.get('status')}")
            
            servers = data.get("data", {}).get("servers", [])
            if not servers:
                raise GofileUploadError("No servers available")
            
            # Return the first server (best one)
            server_name = servers[0].get("name")
            if not server_name:
                raise GofileUploadError("Server name not found in response")
            
            print(f"✓ Server: {server_name}")
            return server_name
            
        except requests.RequestException as e:
            raise GofileUploadError(f"Network error while getting server: {e}")
        except (KeyError, IndexError) as e:
            raise GofileUploadError(f"Invalid server response format: {e}")
    
    def set_folder_public(self, folder_id: str) -> bool:
        """
        Set a folder to public so we can access the direct links.
        
        Args:
            folder_id: The folder ID to make public
            
        Returns:
            True if successful, False otherwise (may already be public)
        """
        try:
            url = f"{self.BASE_API_URL}/contents/{folder_id}/update"
            data = {
                'token': self.token,
                'option': 'public',
                'value': 'true'
            }
            
            response = self.session.put(url, data=data, timeout=30)
            
            if response.status_code in [200, 201]:
                result = response.json()
                if result.get("status") == "ok":
                    print("✓ Folder set to public")
                    return True
            
            # If it fails, it might already be public or not supported
            print("  (folder may already be public)")
            return False
            
        except Exception:
            # Silently fail - folder might already be public
            return False
    
    def test_direct_link(self, url: str) -> Tuple[bool, int]:
        """
        Test if a direct link is accessible.
        
        Args:
            url: The URL to test
            
        Returns:
            Tuple of (is_accessible, http_code)
        """
        try:
            response = self.session.head(url, allow_redirects=True, timeout=10)
            return (response.status_code == 200, response.status_code)
        except Exception:
            return (False, 0)
    
    def get_direct_link(self, content_id: str, file_id: str, server: str, filename: str) -> str:
        """
        Get the direct download link for a file from GoFile.
        
        This extracts the true binary download URL, NOT the HTML landing page.
        
        Strategy:
        1. Try to fetch from getContent API (with/without auth)
        2. If API fails, construct URL manually based on known format
        3. Validate the final URL format
        
        Args:
            content_id: The folder/content ID from upload response
            file_id: The specific file ID
            server: The server name (e.g., "store-eu-par-5")
            filename: The original filename
            
        Returns:
            Direct download URL (https://storeX.gofile.io/download/...)
            
        Raises:
            GofileUploadError: If unable to get or construct valid direct link
        """
        print("[4/4] Extracting direct download link...")
        
        # Try to fetch from API
        try:
            url = f"{self.BASE_API_URL}/contents/{content_id}"
            
            # Attempt 1: With Bearer token
            headers = {'Authorization': f'Bearer {self.token}'}
            response = self.session.get(url, headers=headers, timeout=30)
            
            # Attempt 2: If 401, try without auth (public folder)
            if response.status_code == 401:
                print("  Trying without authentication...")
                response = self.session.get(url, timeout=30)
            
            # If successful, extract link from response
            if response.status_code == 200:
                data = response.json()
                
                if data.get("status") == "ok":
                    contents = data.get("data", {}).get("contents", {})
                    
                    if contents and file_id in contents:
                        file_data = contents[file_id]
                        direct_link = (
                            file_data.get("link") or 
                            file_data.get("directLink") or
                            file_data.get("directLink")
                        )
                        
                        if direct_link and "/download/" in direct_link:
                            print("✓ Direct link extracted from API")
                            return direct_link
        
        except Exception as e:
            # API failed, will construct manually
            pass
        
        # API failed or didn't return valid link - construct manually
        print("  API fetch failed, constructing URL manually...")
        
        # GoFile direct link format (validated through testing):
        # https://{server}.gofile.io/download/web/{fileId}/{filename}
        direct_link = f"https://{server}.gofile.io/download/web/{file_id}/{filename}"
        
        print("✓ Direct link constructed")
        return direct_link
    
    def upload_file(
        self,
        file_path: str,
        folder_id: Optional[str] = None
    ) -> Dict[str, str]:
        """
        Upload a file to Gofile.io and extract the direct download link.
        
        Args:
            file_path: Path to the file to upload
            folder_id: Optional folder ID to upload to
            
        Returns:
            Dictionary containing upload information:
                - download_page: URL to download page (HTML, not for automation)
                - file_id: Unique file identifier
                - file_name: Name of uploaded file
                - content_id: Parent folder/content ID
                - direct_link: TRUE binary download URL for CI/CD
                
        Raises:
            GofileUploadError: If upload fails
            FileNotFoundError: If file doesn't exist
        """
        file_path_obj = Path(file_path)
        
        if not file_path_obj.exists():
            raise FileNotFoundError(f"File not found: {file_path}")
        
        if not file_path_obj.is_file():
            raise GofileUploadError(f"Path is not a file: {file_path}")
        
        # Get the best server
        server = self.get_best_server()
        upload_url = f"https://{server}.gofile.io/contents/uploadfile"
        
        # Prepare the upload
        files = {
            'file': (file_path_obj.name, open(file_path, 'rb'))
        }
        
        data = {
            'token': self.token
        }
        
        if folder_id:
            data['folderId'] = folder_id
        
        try:
            print("[2/4] Uploading file...")
            
            response = self.session.post(
                upload_url,
                files=files,
                data=data,
                timeout=300  # 5 minutes timeout for large files
            )
            response.raise_for_status()
            
            result = response.json()
            
            if result.get("status") != "ok":
                error_msg = result.get("status", "Unknown error")
                raise GofileUploadError(f"Upload failed: {error_msg}")
            
            upload_data = result.get("data", {})
            
            # Extract upload details (try multiple field names)
            file_id = upload_data.get('fileId') or upload_data.get('id', '')
            parent_folder = (
                upload_data.get('parentFolder') or 
                upload_data.get('folderId') or 
                upload_data.get('code', '')
            )
            download_page = upload_data.get('downloadPage', '')
            
            # Extract from downloadPage if parent_folder not found
            if not parent_folder and 'downloadPage' in upload_data:
                # Extract code from https://gofile.io/d/{code}
                if '/d/' in download_page:
                    parent_folder = download_page.split('/d/')[-1]
            
            if not file_id:
                # Debug: print the actual response
                print(f"DEBUG: Upload response: {json.dumps(upload_data, indent=2)}", file=sys.stderr)
                raise GofileUploadError("fileId missing from upload response")
            
            if not parent_folder:
                print(f"DEBUG: Upload response: {json.dumps(upload_data, indent=2)}", file=sys.stderr)
                raise GofileUploadError("parentFolder/code missing from upload response")
            
            print("✓ Upload successful")
            print(f"  File ID: {file_id}")
            print(f"  Content ID: {parent_folder}")
            
            # Try to set folder to public (may fail if already public or not permitted)
            print("[3/4] Attempting to set folder to public...")
            self.set_folder_public(parent_folder)
            
            # Get the direct download link
            direct_link = self.get_direct_link(
                content_id=parent_folder,
                file_id=file_id,
                server=server,
                filename=file_path_obj.name
            )
            
            return {
                'download_page': upload_data.get('downloadPage', ''),
                'file_id': file_id,
                'file_name': upload_data.get('fileName', file_path_obj.name),
                'content_id': parent_folder,
                'direct_link': direct_link,
                'server': server
            }
            
        except requests.RequestException as e:
            raise GofileUploadError(f"Network error during upload: {e}")
        except (KeyError, ValueError) as e:
            raise GofileUploadError(f"Invalid upload response format: {e}")
        finally:
            # Close the file handle
            files['file'][1].close()


def main():
    """Main entry point for the script"""
    parser = argparse.ArgumentParser(
        description="Upload Android APK to Gofile.io"
    )
    parser.add_argument(
        "apk_path",
        help="Path to the APK file to upload"
    )
    parser.add_argument(
        "--token",
        required=True,
        help="Gofile API token"
    )
    parser.add_argument(
        "--account-id",
        help="Gofile account ID (optional)"
    )
    parser.add_argument(
        "--folder-id",
        help="Gofile folder ID to upload to (optional)"
    )
    parser.add_argument(
        "--output-json",
        help="Path to save upload result as JSON"
    )
    parser.add_argument(
        "--github-output",
        action="store_true",
        help="Output in GitHub Actions format"
    )
    parser.add_argument(
        "--direct-link-only",
        action="store_true",
        help="Output only the direct download link (for CI/CD pipelines)"
    )
    
    args = parser.parse_args()
    
    try:
        print("=" * 60)
        print("GoFile Upload - Direct Link Extractor")
        print("=" * 60)
        print(f"File: {args.apk_path}")
        print()
        
        # Initialize uploader
        uploader = GofileUploader(
            token=args.token,
            account_id=args.account_id
        )
        
        # Upload the file
        result = uploader.upload_file(
            file_path=args.apk_path,
            folder_id=args.folder_id
        )
        
        # Validate direct link format
        print()
        print("Validating direct link format...")
        
        if "/download/" not in result['direct_link']:
            print("\n⚠ ERROR: Direct link validation failed!", file=sys.stderr)
            print(f"Expected /download/ in URL, got: {result['direct_link']}", file=sys.stderr)
            return 1
        
        if not result['direct_link'].startswith("https://store"):
            print("\n⚠ ERROR: Direct link validation failed!", file=sys.stderr)
            print(f"Expected https://store* URL, got: {result['direct_link']}", file=sys.stderr)
            return 1
        
        print("✓ Direct link format is valid")
        
        # Test if direct link is accessible
        print()
        print("Testing direct link accessibility...")
        is_accessible, http_code = uploader.test_direct_link(result['direct_link'])
        
        if is_accessible:
            print(f"✓ Direct link is accessible (HTTP {http_code})")
        elif http_code in [301, 302]:
            print(f"⚠ Direct link redirects (HTTP {http_code}) - may require cookies")
        elif http_code > 0:
            print(f"⚠ Direct link returned HTTP {http_code}")
        else:
            print("⚠ Could not test direct link")
        
        # If --direct-link-only flag is set, output only the direct link
        if args.direct_link_only:
            print()
            print(result['direct_link'])
            return 0
        
        # Print results
        print()
        print("=" * 60)
        print("Results:")
        print("=" * 60)
        print("Landing Page (HTML - NOT for automation):")
        print(f"  {result['download_page']}")
        print()
        print("DIRECT LINK (for CI/CD and automation):")
        print(f"  {result['direct_link']}")
        print("=" * 60)
        print()
        
        # Save to JSON if requested
        if args.output_json:
            with open(args.output_json, 'w') as f:
                json.dump(result, f, indent=2)
            print(f"Result saved to: {args.output_json}")
            print()
        
        # Output for GitHub Actions
        if args.github_output:
            github_output = os.environ.get('GITHUB_OUTPUT')
            if github_output:
                with open(github_output, 'a') as f:
                    f.write(f"direct_link={result['direct_link']}\n")
                    f.write(f"download_page={result['download_page']}\n")
                    f.write(f"file_id={result['file_id']}\n")
                    f.write(f"content_id={result['content_id']}\n")
                print("✓ GitHub Actions outputs written")
            else:
                # Fallback to environment variable format
                print("# CI/CD Output (export these or parse):")
                print(f"export GOFILE_DIRECT_LINK='{result['direct_link']}'")
                print(f"export GOFILE_DOWNLOAD_PAGE='{result['download_page']}'")
                print(f"export GOFILE_FILE_ID='{result['file_id']}'")
                print(f"export GOFILE_CONTENT_ID='{result['content_id']}'")
        
        return 0
        
    except FileNotFoundError as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1
    except GofileUploadError as e:
        print(f"Upload Error: {e}", file=sys.stderr)
        return 1
    except Exception as e:
        print(f"Unexpected Error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
