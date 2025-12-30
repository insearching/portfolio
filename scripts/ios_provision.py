#!/usr/bin/env python3
"""
iOS Provisioning Profile Management Script
Manages iOS provisioning profiles for code signing in CI/CD environments.
"""

import argparse
import base64
import os
import plistlib
import subprocess
import sys
import tempfile
from pathlib import Path


class ProvisioningProfileManager:
    """Manages iOS provisioning profiles."""
    
    def __init__(self):
        self.profile_path = None
        self.profile_uuid = None
        self.temp_file = None
        
    def install(self, profile_base64: str) -> dict:
        """
        Install iOS provisioning profile.
        
        Args:
            profile_base64: Base64-encoded .mobileprovision file
            
        Returns:
            dict: Profile information including UUID
        """
        if not profile_base64:
            raise ValueError("Provisioning profile base64 content is required")
        
        print(f"📱 Installing iOS provisioning profile...")
        
        try:
            # Create provisioning profiles directory
            pp_dir = Path.home() / "Library" / "MobileDevice" / "Provisioning Profiles"
            pp_dir.mkdir(parents=True, exist_ok=True)
            print(f"   Profiles directory: {pp_dir}")
            
            # Create temporary file for decoding
            with tempfile.NamedTemporaryFile(mode='wb', suffix='.mobileprovision', delete=False) as f:
                self.temp_file = Path(f.name)
                profile_data = base64.b64decode(profile_base64)
                f.write(profile_data)
            
            print(f"   Decoded profile to: {self.temp_file}")
            
            # Extract profile information using security cms
            print(f"   Extracting profile information...")
            result = subprocess.run(
                ["security", "cms", "-D", "-i", str(self.temp_file)],
                capture_output=True,
                check=True
            )
            
            # Parse the plist data
            profile_plist = plistlib.loads(result.stdout)
            
            # Get UUID
            self.profile_uuid = profile_plist.get('UUID')
            if not self.profile_uuid:
                raise ValueError("Could not extract UUID from provisioning profile")
            
            print(f"   Profile UUID: {self.profile_uuid}")
            
            # Get additional information
            profile_name = profile_plist.get('Name', 'Unknown')
            app_id = profile_plist.get('Entitlements', {}).get('application-identifier', 'Unknown')
            creation_date = profile_plist.get('CreationDate', 'Unknown')
            expiration_date = profile_plist.get('ExpirationDate', 'Unknown')
            team_name = profile_plist.get('TeamName', 'Unknown')
            
            print(f"   Profile Name: {profile_name}")
            print(f"   App ID: {app_id}")
            print(f"   Team: {team_name}")
            
            # Install profile with UUID-based filename
            self.profile_path = pp_dir / f"{self.profile_uuid}.mobileprovision"
            
            # Copy to final location
            import shutil
            shutil.copy2(self.temp_file, self.profile_path)
            
            print(f"   Installed to: {self.profile_path}")
            
            # Verify installation
            if not self.profile_path.exists():
                raise RuntimeError(f"Failed to install profile to {self.profile_path}")
            
            # Verify it's readable
            subprocess.run(
                ["security", "cms", "-D", "-i", str(self.profile_path)],
                capture_output=True,
                check=True
            )
            
            print(f"✅ Provisioning profile installed successfully")
            
            # Export UUID to GitHub Actions environment
            if os.getenv("GITHUB_ENV"):
                with open(os.getenv("GITHUB_ENV"), "a") as f:
                    f.write(f"PROVISIONING_PROFILE_UUID={self.profile_uuid}\n")
            
            # Also export to GITHUB_OUTPUT if available
            if os.getenv("GITHUB_OUTPUT"):
                with open(os.getenv("GITHUB_OUTPUT"), "a") as f:
                    f.write(f"profile_uuid={self.profile_uuid}\n")
                    f.write(f"profile_name={profile_name}\n")
            
            return {
                "uuid": self.profile_uuid,
                "path": str(self.profile_path),
                "name": profile_name,
                "app_id": app_id,
                "team": team_name,
                "creation_date": str(creation_date),
                "expiration_date": str(expiration_date)
            }
            
        except subprocess.CalledProcessError as e:
            print(f"❌ Failed to install provisioning profile: {e.stderr.decode()}", file=sys.stderr)
            raise
        except Exception as e:
            print(f"❌ Failed to install provisioning profile: {e}", file=sys.stderr)
            raise
    
    def cleanup(self) -> bool:
        """
        Remove temporary provisioning profile files.
        
        Returns:
            bool: True if cleanup successful
        """
        print(f"🧹 Cleaning up provisioning profile files...")
        
        try:
            if self.temp_file and self.temp_file.exists():
                self.temp_file.unlink()
                print(f"   Removed temp file: {self.temp_file}")
            
            print(f"✅ Provisioning profile cleanup successful")
            return True
            
        except Exception as e:
            print(f"⚠️ Warning: Failed to cleanup profile: {e}", file=sys.stderr)
            return False
    
    def list_profiles(self) -> list:
        """
        List all installed provisioning profiles.
        
        Returns:
            list: List of profile information dicts
        """
        pp_dir = Path.home() / "Library" / "MobileDevice" / "Provisioning Profiles"
        
        if not pp_dir.exists():
            print(f"📱 No provisioning profiles directory found")
            return []
        
        profiles = []
        print(f"📱 Installed provisioning profiles:")
        
        for profile_file in pp_dir.glob("*.mobileprovision"):
            try:
                result = subprocess.run(
                    ["security", "cms", "-D", "-i", str(profile_file)],
                    capture_output=True,
                    check=True
                )
                
                profile_plist = plistlib.loads(result.stdout)
                uuid = profile_plist.get('UUID', 'Unknown')
                name = profile_plist.get('Name', 'Unknown')
                app_id = profile_plist.get('Entitlements', {}).get('application-identifier', 'Unknown')
                
                profiles.append({
                    "uuid": uuid,
                    "name": name,
                    "app_id": app_id,
                    "path": str(profile_file)
                })
                
                print(f"   • {name} ({uuid})")
                print(f"     App ID: {app_id}")
                
            except Exception as e:
                print(f"   ⚠️ Could not read {profile_file}: {e}", file=sys.stderr)
        
        return profiles
    
    def verify(self, uuid: str = None) -> bool:
        """
        Verify provisioning profile exists and is valid.
        
        Args:
            uuid: Optional UUID to verify specific profile
            
        Returns:
            bool: True if profile(s) valid
        """
        print(f"🔍 Verifying provisioning profile...")
        
        pp_dir = Path.home() / "Library" / "MobileDevice" / "Provisioning Profiles"
        
        if not pp_dir.exists():
            print(f"❌ Provisioning profiles directory does not exist", file=sys.stderr)
            return False
        
        if uuid:
            profile_path = pp_dir / f"{uuid}.mobileprovision"
            if not profile_path.exists():
                print(f"❌ Profile with UUID {uuid} not found", file=sys.stderr)
                return False
            
            try:
                subprocess.run(
                    ["security", "cms", "-D", "-i", str(profile_path)],
                    capture_output=True,
                    check=True
                )
                print(f"✅ Profile {uuid} is valid")
                return True
            except subprocess.CalledProcessError:
                print(f"❌ Profile {uuid} is invalid", file=sys.stderr)
                return False
        else:
            # Check if any profiles exist
            profiles = list(pp_dir.glob("*.mobileprovision"))
            if not profiles:
                print(f"❌ No provisioning profiles found", file=sys.stderr)
                return False
            
            print(f"✅ Found {len(profiles)} provisioning profile(s)")
            return True


def main():
    parser = argparse.ArgumentParser(
        description="Manage iOS provisioning profiles",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Install profile from base64
  python ios_provision.py install \\
    --profile-base64 "$(cat profile.mobileprovision | base64)"
  
  # Install from environment variable
  python ios_provision.py install \\
    --profile-base64 "$IOS_PROVISION_PROFILE_BASE64"
  
  # List all installed profiles
  python ios_provision.py list
  
  # Verify profile exists
  python ios_provision.py verify
  
  # Verify specific profile by UUID
  python ios_provision.py verify --uuid "12345678-1234-1234-1234-123456789012"
  
  # Cleanup temporary files
  python ios_provision.py cleanup
        """
    )
    
    parser.add_argument(
        "action",
        choices=["install", "list", "verify", "cleanup"],
        help="Action to perform"
    )
    
    parser.add_argument(
        "--profile-base64",
        help="Base64-encoded .mobileprovision file",
        default=None
    )
    
    parser.add_argument(
        "--uuid",
        help="Profile UUID (for verify action)",
        default=None
    )
    
    args = parser.parse_args()
    
    manager = ProvisioningProfileManager()
    
    try:
        if args.action == "install":
            if not args.profile_base64:
                parser.error("--profile-base64 is required for install")
            
            result = manager.install(args.profile_base64)
            print(f"\n📋 Profile Info:")
            print(f"   UUID: {result['uuid']}")
            print(f"   Name: {result['name']}")
            print(f"   App ID: {result['app_id']}")
            print(f"   Team: {result['team']}")
            print(f"   Path: {result['path']}")
            print(f"   Expires: {result['expiration_date']}")
            sys.exit(0)
            
        elif args.action == "list":
            profiles = manager.list_profiles()
            if not profiles:
                print("No profiles found")
            sys.exit(0)
            
        elif args.action == "verify":
            if manager.verify(args.uuid):
                sys.exit(0)
            else:
                sys.exit(1)
                
        elif args.action == "cleanup":
            if manager.cleanup():
                sys.exit(0)
            else:
                sys.exit(1)
                
    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
