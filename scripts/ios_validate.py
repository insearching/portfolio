#!/usr/bin/env python3
"""
iOS Build Environment Validation Script
Validates the iOS build environment before starting the build process.
"""

import argparse
import os
import subprocess
import sys
from pathlib import Path


class IOSValidator:
    """Validates iOS build environment."""
    
    def __init__(self):
        self.errors = []
        self.warnings = []
        
    def validate_xcode(self) -> bool:
        """Validate Xcode installation and version."""
        print("🔍 Validating Xcode...")
        
        try:
            result = subprocess.run(
                ["xcodebuild", "-version"],
                capture_output=True,
                text=True,
                check=True
            )
            
            version_info = result.stdout.strip().split('\n')
            print(f"   ✅ {version_info[0]}")
            if len(version_info) > 1:
                print(f"   ✅ {version_info[1]}")
            
            return True
            
        except (subprocess.CalledProcessError, FileNotFoundError) as e:
            self.errors.append("Xcode not found or not properly installed")
            print(f"   ❌ Xcode validation failed", file=sys.stderr)
            return False
    
    def validate_workspace(self, workspace_path: str) -> bool:
        """Validate Xcode workspace exists."""
        print(f"🔍 Validating workspace...")
        
        workspace = Path(workspace_path)
        
        if not workspace.exists():
            self.errors.append(f"Workspace not found: {workspace_path}")
            print(f"   ❌ Workspace not found: {workspace_path}", file=sys.stderr)
            return False
        
        if not workspace.is_dir():
            self.errors.append(f"Workspace path is not a directory: {workspace_path}")
            print(f"   ❌ Not a directory: {workspace_path}", file=sys.stderr)
            return False
        
        print(f"   ✅ Workspace found: {workspace.name}")
        return True
    
    def validate_scheme(self, workspace_path: str, scheme: str) -> bool:
        """Validate Xcode scheme exists."""
        print(f"🔍 Validating scheme '{scheme}'...")
        
        try:
            result = subprocess.run(
                [
                    "xcodebuild",
                    "-workspace", workspace_path,
                    "-list"
                ],
                capture_output=True,
                text=True,
                check=True
            )
            
            # Check if scheme exists in output
            if f"    {scheme}" in result.stdout or f"\"{scheme}\"" in result.stdout:
                print(f"   ✅ Scheme '{scheme}' found")
                return True
            else:
                self.errors.append(f"Scheme '{scheme}' not found in workspace")
                print(f"   ❌ Scheme '{scheme}' not found", file=sys.stderr)
                print(f"\n📋 Available schemes:", file=sys.stderr)
                
                # Extract and print available schemes
                in_schemes = False
                for line in result.stdout.split('\n'):
                    if 'Schemes:' in line:
                        in_schemes = True
                        continue
                    if in_schemes and line.strip():
                        if line.strip().startswith('-'):
                            break
                        print(f"      {line.strip()}", file=sys.stderr)
                
                return False
                
        except subprocess.CalledProcessError as e:
            self.errors.append(f"Failed to list schemes: {e.stderr}")
            print(f"   ❌ Failed to list schemes", file=sys.stderr)
            return False
    
    def validate_cocoapods(self, workspace_path: str) -> bool:
        """Validate CocoaPods installation."""
        print(f"🔍 Validating CocoaPods...")
        
        workspace = Path(workspace_path)
        ios_dir = workspace.parent
        podfile = ios_dir / "Podfile"
        podfile_lock = ios_dir / "Podfile.lock"
        pods_dir = ios_dir / "Pods"
        
        # Check if Podfile exists
        if not podfile.exists():
            self.warnings.append("Podfile not found - CocoaPods may not be used")
            print(f"   ⚠️ Podfile not found (may not be required)")
            return True  # Not an error if project doesn't use CocoaPods
        
        print(f"   ✅ Podfile found")
        
        # Check if pods are installed
        if not pods_dir.exists() or not podfile_lock.exists():
            self.errors.append("CocoaPods dependencies not installed. Run 'pod install'")
            print(f"   ❌ Pods not installed", file=sys.stderr)
            return False
        
        print(f"   ✅ Pods installed")
        
        # Verify pod command exists
        try:
            result = subprocess.run(
                ["pod", "--version"],
                capture_output=True,
                text=True,
                check=True
            )
            print(f"   ✅ CocoaPods version: {result.stdout.strip()}")
            return True
            
        except (subprocess.CalledProcessError, FileNotFoundError):
            self.warnings.append("'pod' command not found in PATH")
            print(f"   ⚠️ CocoaPods command not available")
            return True  # Not critical if pods already installed
    
    def validate_keychain(self) -> bool:
        """Validate keychain setup."""
        print(f"🔍 Validating keychain...")
        
        keychain_name = os.getenv("KEYCHAIN_NAME", "build.keychain")
        
        try:
            result = subprocess.run(
                ["security", "list-keychains", "-d", "user"],
                capture_output=True,
                text=True,
                check=True
            )
            
            if keychain_name in result.stdout:
                print(f"   ✅ Keychain '{keychain_name}' found")
                return True
            else:
                self.warnings.append(f"Keychain '{keychain_name}' not in search list")
                print(f"   ⚠️ Keychain '{keychain_name}' not found")
                return True  # Warning, not error
                
        except subprocess.CalledProcessError:
            self.warnings.append("Could not list keychains")
            print(f"   ⚠️ Could not validate keychain")
            return True
    
    def validate_signing_identity(self) -> bool:
        """Validate code signing identity exists."""
        print(f"🔍 Validating code signing identity...")
        
        keychain_name = os.getenv("KEYCHAIN_NAME", "build.keychain")
        
        try:
            result = subprocess.run(
                ["security", "find-identity", "-v", "-p", "codesigning", keychain_name],
                capture_output=True,
                text=True,
                check=True
            )
            
            # Check for valid identities
            if "0 valid identities found" in result.stdout:
                self.errors.append("No valid code signing identities found")
                print(f"   ❌ No valid identities", file=sys.stderr)
                return False
            
            # Count identities
            identities = [line for line in result.stdout.split('\n') if ') ' in line and 'valid' not in line.lower()]
            print(f"   ✅ Found {len(identities)} code signing identit{'y' if len(identities) == 1 else 'ies'}")
            
            return True
            
        except subprocess.CalledProcessError:
            self.warnings.append("Could not verify signing identity")
            print(f"   ⚠️ Could not verify signing identity")
            return True  # Don't fail - fastlane will handle this
    
    def validate_provisioning_profile(self) -> bool:
        """Validate provisioning profile exists."""
        print(f"🔍 Validating provisioning profile...")
        
        pp_dir = Path.home() / "Library" / "MobileDevice" / "Provisioning Profiles"
        
        if not pp_dir.exists():
            self.errors.append("Provisioning Profiles directory not found")
            print(f"   ❌ Profiles directory not found", file=sys.stderr)
            return False
        
        profiles = list(pp_dir.glob("*.mobileprovision"))
        
        if not profiles:
            self.errors.append("No provisioning profiles installed")
            print(f"   ❌ No profiles found", file=sys.stderr)
            return False
        
        print(f"   ✅ Found {len(profiles)} provisioning profile{'s' if len(profiles) > 1 else ''}")
        
        # Show UUID if available
        profile_uuid = os.getenv("PROVISIONING_PROFILE_UUID")
        if profile_uuid:
            print(f"   ✅ Profile UUID: {profile_uuid}")
        
        return True
    
    def validate_environment_variables(self) -> bool:
        """Validate required environment variables."""
        print(f"🔍 Validating environment variables...")
        
        required_vars = [
            "APP_STORE_CONNECT_KEY_ID",
            "APP_STORE_CONNECT_ISSUER_ID",
            "APP_STORE_CONNECT_KEY_P8"
        ]
        
        missing = []
        for var in required_vars:
            if not os.getenv(var):
                missing.append(var)
        
        if missing:
            self.errors.append(f"Missing required environment variables: {', '.join(missing)}")
            print(f"   ❌ Missing variables: {', '.join(missing)}", file=sys.stderr)
            return False
        
        print(f"   ✅ All required environment variables present")
        return True
    
    def validate_all(self, workspace_path: str, scheme: str) -> bool:
        """
        Run all validations.
        
        Args:
            workspace_path: Path to .xcworkspace
            scheme: Xcode scheme name
            
        Returns:
            bool: True if all validations pass
        """
        print("=" * 60)
        print("🚀 iOS Build Environment Validation")
        print("=" * 60)
        print()
        
        results = []
        
        # Run all validations
        results.append(("Xcode", self.validate_xcode()))
        results.append(("Workspace", self.validate_workspace(workspace_path)))
        results.append(("Scheme", self.validate_scheme(workspace_path, scheme)))
        results.append(("CocoaPods", self.validate_cocoapods(workspace_path)))
        results.append(("Keychain", self.validate_keychain()))
        results.append(("Signing Identity", self.validate_signing_identity()))
        results.append(("Provisioning Profile", self.validate_provisioning_profile()))
        results.append(("Environment Variables", self.validate_environment_variables()))
        
        print()
        print("=" * 60)
        print("📊 Validation Summary")
        print("=" * 60)
        
        # Print summary
        passed = sum(1 for _, result in results if result)
        total = len(results)
        
        for name, result in results:
            status = "✅" if result else "❌"
            print(f"{status} {name}")
        
        print()
        print(f"Passed: {passed}/{total}")
        
        if self.warnings:
            print(f"\n⚠️ Warnings ({len(self.warnings)}):")
            for warning in self.warnings:
                print(f"   • {warning}")
        
        if self.errors:
            print(f"\n❌ Errors ({len(self.errors)}):")
            for error in self.errors:
                print(f"   • {error}")
            print()
            return False
        
        print()
        print("✅ All validations passed! Ready to build.")
        print("=" * 60)
        return True


def main():
    parser = argparse.ArgumentParser(
        description="Validate iOS build environment",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Validate with default scheme
  python ios_validate.py \\
    --workspace ios/Runner.xcworkspace \\
    --scheme Runner
  
  # Validate with custom scheme
  python ios_validate.py \\
    --workspace ios/Runner.xcworkspace \\
    --scheme "My App Scheme"
        """
    )
    
    parser.add_argument(
        "--workspace",
        required=True,
        help="Path to .xcworkspace file"
    )
    
    parser.add_argument(
        "--scheme",
        required=True,
        help="Xcode scheme name"
    )
    
    args = parser.parse_args()
    
    validator = IOSValidator()
    
    try:
        if validator.validate_all(args.workspace, args.scheme):
            sys.exit(0)
        else:
            sys.exit(1)
            
    except Exception as e:
        print(f"❌ Validation failed with error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
