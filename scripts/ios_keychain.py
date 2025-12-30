#!/usr/bin/env python3
"""
iOS Keychain Management Script
Manages temporary keychains for iOS code signing in CI/CD environments.
"""

import argparse
import os
import subprocess
import sys
import uuid
from pathlib import Path


class KeychainManager:
    """Manages macOS keychains for iOS code signing."""
    
    def __init__(self):
        self.keychain_name = "build.keychain"
        self.keychain_password = None
        self.keychain_path = None
        
    def create(self, password: str = None) -> dict:
        """
        Create a temporary keychain for code signing.
        
        Args:
            password: Optional password for keychain. If not provided, generates UUID.
            
        Returns:
            dict: Keychain information including name, path, and password
        """
        # Generate password if not provided
        self.keychain_password = password or str(uuid.uuid4())
        
        # Get home directory
        home = Path.home()
        self.keychain_path = home / "Library" / "Keychains" / f"{self.keychain_name}-db"
        
        print(f"🔧 Creating temporary keychain: {self.keychain_name}")
        
        try:
            # Create keychain
            result = subprocess.run(
                ["security", "create-keychain", "-p", self.keychain_password, self.keychain_name],
                capture_output=True,
                text=True,
                check=True
            )
            
            # Set keychain settings (unlock timeout: 21600 seconds = 6 hours)
            subprocess.run(
                ["security", "set-keychain-settings", "-lut", "21600", self.keychain_name],
                capture_output=True,
                text=True,
                check=True
            )
            
            # Unlock keychain
            subprocess.run(
                ["security", "unlock-keychain", "-p", self.keychain_password, self.keychain_name],
                capture_output=True,
                text=True,
                check=True
            )
            
            # Add to search list
            subprocess.run(
                ["security", "list-keychains", "-d", "user", "-s", self.keychain_name, "login.keychain"],
                capture_output=True,
                text=True,
                check=True
            )
            
            # Set as default keychain
            subprocess.run(
                ["security", "default-keychain", "-s", self.keychain_name],
                capture_output=True,
                text=True,
                check=True
            )
            
            print(f"✅ Keychain created successfully")
            print(f"   Path: {self.keychain_path}")
            
            # Export environment variables for GitHub Actions
            if os.getenv("GITHUB_ENV"):
                with open(os.getenv("GITHUB_ENV"), "a") as f:
                    f.write(f"KEYCHAIN_NAME={self.keychain_name}\n")
                    f.write(f"KEYCHAIN_PATH={self.keychain_path}\n")
                    f.write(f"KEYCHAIN_PWD={self.keychain_password}\n")
            
            return {
                "name": self.keychain_name,
                "path": str(self.keychain_path),
                "password": self.keychain_password
            }
            
        except subprocess.CalledProcessError as e:
            print(f"❌ Failed to create keychain: {e.stderr}", file=sys.stderr)
            raise
    
    def cleanup(self) -> bool:
        """
        Delete the temporary keychain.
        
        Returns:
            bool: True if cleanup successful
        """
        print(f"🧹 Cleaning up keychain: {self.keychain_name}")
        
        try:
            # Delete keychain
            subprocess.run(
                ["security", "delete-keychain", self.keychain_name],
                capture_output=True,
                text=True,
                check=False  # Don't fail if keychain doesn't exist
            )
            
            print(f"✅ Keychain cleaned up successfully")
            return True
            
        except Exception as e:
            print(f"⚠️ Warning: Failed to cleanup keychain: {e}", file=sys.stderr)
            return False
    
    def verify(self) -> bool:
        """
        Verify keychain exists and is accessible.
        
        Returns:
            bool: True if keychain is valid
        """
        try:
            result = subprocess.run(
                ["security", "show-keychain-info", self.keychain_name],
                capture_output=True,
                text=True,
                check=False
            )
            
            if result.returncode == 0:
                print(f"✅ Keychain verified: {self.keychain_name}")
                return True
            else:
                print(f"❌ Keychain not found: {self.keychain_name}", file=sys.stderr)
                return False
                
        except Exception as e:
            print(f"❌ Failed to verify keychain: {e}", file=sys.stderr)
            return False


def main():
    parser = argparse.ArgumentParser(
        description="Manage macOS keychains for iOS code signing",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Create keychain with auto-generated password
  python ios_keychain.py create
  
  # Create keychain with custom password
  python ios_keychain.py create --password "my-secure-password"
  
  # Verify keychain exists
  python ios_keychain.py verify
  
  # Cleanup keychain
  python ios_keychain.py cleanup
        """
    )
    
    parser.add_argument(
        "action",
        choices=["create", "cleanup", "verify"],
        help="Action to perform"
    )
    
    parser.add_argument(
        "--password",
        help="Keychain password (auto-generated if not provided)",
        default=None
    )
    
    args = parser.parse_args()
    
    manager = KeychainManager()
    
    try:
        if args.action == "create":
            result = manager.create(args.password)
            print(f"\n📋 Keychain Info:")
            print(f"   Name: {result['name']}")
            print(f"   Path: {result['path']}")
            # Don't print password in logs
            print(f"   Password: {'*' * 8} (set in KEYCHAIN_PWD)")
            sys.exit(0)
            
        elif args.action == "verify":
            if manager.verify():
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
