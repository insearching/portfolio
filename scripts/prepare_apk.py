#!/usr/bin/env python3
"""
APK Preparation Script with Version Management

This script prepares Android APK files for release by:
1. Extracting version from pubspec.yaml
2. Creating versioned copies of the APK
3. Creating stable-name copies for constant URLs
4. Outputting paths and version info for CI/CD

Features:
- Version extraction from pubspec.yaml
- Automatic file renaming with version
- Dual naming strategy (versioned + stable)
- GitHub Actions output support
- Comprehensive validation

Requirements:
- Python 3.7+
- PyYAML library

Usage:
    python prepare_apk.py <source_apk> [options]
"""

import argparse
import os
import shutil
import sys
from pathlib import Path
from typing import Dict, Optional

try:
    import yaml
except ImportError:
    print("ERROR: PyYAML library not found. Install with: pip install PyYAML", file=sys.stderr)
    sys.exit(1)


class APKPreparationError(Exception):
    """Custom exception for APK preparation errors."""
    pass


class APKPreparer:
    """
    Handles APK preparation with versioning.
    
    This class implements:
    1. Version extraction from pubspec.yaml
    2. APK file copying and renaming
    3. Validation and error handling
    """
    
    def __init__(self, project_root: Optional[Path] = None):
        """
        Initialize the APK preparer.
        
        Args:
            project_root: Path to project root (defaults to script parent directory)
        """
        if project_root is None:
            # Default to parent directory of scripts folder
            project_root = Path(__file__).parent.parent
        
        self.project_root = Path(project_root)
        self.pubspec_path = self.project_root / "pubspec.yaml"
        
        if not self.pubspec_path.exists():
            raise APKPreparationError(f"pubspec.yaml not found at: {self.pubspec_path}")
    
    def extract_version(self) -> str:
        """
        Extract version string from pubspec.yaml.
        
        Returns:
            Version string (e.g., "1.0.0+1")
        
        Raises:
            APKPreparationError: If version cannot be extracted
        """
        try:
            with open(self.pubspec_path, 'r', encoding='utf-8') as f:
                pubspec = yaml.safe_load(f)
            
            version = pubspec.get('version')
            
            if not version:
                raise APKPreparationError("Version field not found in pubspec.yaml")
            
            if not isinstance(version, str):
                raise APKPreparationError(f"Version must be a string, got: {type(version)}")
            
            # Validate version format (should be like "1.0.0+1" or "1.0.0")
            if not version.strip():
                raise APKPreparationError("Version cannot be empty")
            
            return version.strip()
            
        except yaml.YAMLError as e:
            raise APKPreparationError(f"Failed to parse pubspec.yaml: {e}")
        except IOError as e:
            raise APKPreparationError(f"Failed to read pubspec.yaml: {e}")
    
    def validate_source_apk(self, source_path: Path) -> None:
        """
        Validate that the source APK exists and is a file.
        
        Args:
            source_path: Path to source APK
        
        Raises:
            FileNotFoundError: If APK doesn't exist
            APKPreparationError: If path is not a file
        """
        if not source_path.exists():
            raise FileNotFoundError(f"Source APK not found: {source_path}")
        
        if not source_path.is_file():
            raise APKPreparationError(f"Source path is not a file: {source_path}")
        
        # Validate it's an APK file
        if not source_path.suffix.lower() == '.apk':
            raise APKPreparationError(f"Source file is not an APK: {source_path}")
    
    def prepare_apk_files(
        self,
        source_apk: str,
        output_dir: Optional[str] = None,
        base_name: str = "app-portfolio-release"
    ) -> Dict[str, str]:
        """
        Prepare APK files with versioned and stable names.
        
        Args:
            source_apk: Path to source APK file
            output_dir: Output directory (defaults to same as source)
            base_name: Base name for output files
        
        Returns:
            Dictionary containing:
                - version: Extracted version string
                - versioned_path: Path to versioned APK
                - versioned_name: Filename of versioned APK
                - stable_path: Path to stable APK
                - stable_name: Filename of stable APK
        
        Raises:
            APKPreparationError: If preparation fails
            FileNotFoundError: If source APK doesn't exist
        """
        source_path = Path(source_apk).resolve()
        
        # Validate source APK
        self.validate_source_apk(source_path)
        
        # Determine output directory
        if output_dir:
            output_path = Path(output_dir).resolve()
            output_path.mkdir(parents=True, exist_ok=True)
        else:
            output_path = source_path.parent
        
        # Extract version
        print("[1/3] Extracting version from pubspec.yaml...")
        version = self.extract_version()
        print(f"✓ Version extracted: {version}")
        
        # Generate filenames
        versioned_name = f"{base_name}-{version}.apk"
        stable_name = f"{base_name}-latest.apk"
        
        versioned_path = output_path / versioned_name
        stable_path = output_path / stable_name
        
        # Get source file size
        source_size = source_path.stat().st_size
        print(f"  Source APK size: {source_size / (1024*1024):.2f} MB")
        
        # Copy to versioned name
        print(f"[2/3] Creating versioned APK: {versioned_name}...")
        try:
            shutil.copy2(source_path, versioned_path)
            print(f"✓ Created: {versioned_path}")
        except IOError as e:
            raise APKPreparationError(f"Failed to create versioned APK: {e}")
        
        # Copy to stable name
        print(f"[3/3] Creating stable APK: {stable_name}...")
        try:
            shutil.copy2(source_path, stable_path)
            print(f"✓ Created: {stable_path}")
        except IOError as e:
            raise APKPreparationError(f"Failed to create stable APK: {e}")
        
        # Verify copies
        if not versioned_path.exists() or versioned_path.stat().st_size != source_size:
            raise APKPreparationError("Versioned APK verification failed")
        
        if not stable_path.exists() or stable_path.stat().st_size != source_size:
            raise APKPreparationError("Stable APK verification failed")
        
        return {
            'version': version,
            'versioned_path': str(versioned_path),
            'versioned_name': versioned_name,
            'stable_path': str(stable_path),
            'stable_name': stable_name,
        }


def main():
    """Main entry point for the script"""
    parser = argparse.ArgumentParser(
        description="Prepare APK files with versioned and stable names",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Prepare APK in same directory
  python prepare_apk.py build/app/outputs/flutter-apk/app-release.apk
  
  # Prepare with custom output directory
  python prepare_apk.py app-release.apk --output-dir dist/
  
  # With custom base name
  python prepare_apk.py app-release.apk --base-name myapp-release
  
  # With GitHub Actions output
  python prepare_apk.py app-release.apk --github-output
        """
    )
    
    parser.add_argument(
        "source_apk",
        help="Path to source APK file"
    )
    parser.add_argument(
        "--output-dir",
        help="Output directory (defaults to same as source)"
    )
    parser.add_argument(
        "--base-name",
        default="app-portfolio-release",
        help="Base name for output files (default: app-portfolio-release)"
    )
    parser.add_argument(
        "--project-root",
        help="Project root directory (defaults to script parent directory)"
    )
    parser.add_argument(
        "--github-output",
        action="store_true",
        help="Output in GitHub Actions format"
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output results as JSON"
    )
    
    args = parser.parse_args()
    
    try:
        print("=" * 60)
        print("APK Preparation - Version Management")
        print("=" * 60)
        print(f"Source: {args.source_apk}")
        print()
        
        # Initialize preparer
        project_root = Path(args.project_root) if args.project_root else None
        preparer = APKPreparer(project_root=project_root)
        
        # Prepare APK files
        result = preparer.prepare_apk_files(
            source_apk=args.source_apk,
            output_dir=args.output_dir,
            base_name=args.base_name
        )
        
        # Output results
        print()
        print("=" * 60)
        print("Preparation Complete!")
        print("=" * 60)
        print(f"Version: {result['version']}")
        print()
        print("Versioned APK:")
        print(f"  Name: {result['versioned_name']}")
        print(f"  Path: {result['versioned_path']}")
        print()
        print("Stable APK:")
        print(f"  Name: {result['stable_name']}")
        print(f"  Path: {result['stable_path']}")
        print("=" * 60)
        print()
        
        # JSON output
        if args.json:
            import json
            print(json.dumps(result, indent=2))
        
        # GitHub Actions output
        if args.github_output:
            github_output = os.environ.get("GITHUB_OUTPUT")
            if github_output:
                with open(github_output, "a") as f:
                    f.write(f"version={result['version']}\n")
                    f.write(f"versioned_path={result['versioned_path']}\n")
                    f.write(f"versioned_name={result['versioned_name']}\n")
                    f.write(f"stable_path={result['stable_path']}\n")
                    f.write(f"stable_name={result['stable_name']}\n")
                print("✓ GitHub Actions outputs written")
            else:
                print("# Environment variable format:")
                print(f"export VERSION='{result['version']}'")
                print(f"export VERSIONED_PATH='{result['versioned_path']}'")
                print(f"export VERSIONED_NAME='{result['versioned_name']}'")
                print(f"export STABLE_PATH='{result['stable_path']}'")
                print(f"export STABLE_NAME='{result['stable_name']}'")
        
        return 0
        
    except FileNotFoundError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return 1
    except APKPreparationError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return 1
    except Exception as e:
        print(f"UNEXPECTED ERROR: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())
