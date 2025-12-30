#!/usr/bin/env python3
"""
iOS Certificate Management Script
Manages iOS distribution certificates for code signing in CI/CD environments.
"""

import argparse
import base64
import os
import subprocess
import sys
import tempfile
from pathlib import Path


class CertificateManager:
    """Manages iOS distribution certificates."""
    
    def __init__(self):
        self.cert_path = None
        self.temp_dir = None
        
    def install(self, cert_base64: str, cert_password: str) -> dict:
        """
        Install iOS distribution certificate into keychain.
        
        Args:
            cert_base64: Base64-encoded .p12 certificate
            cert_password: Password for the certificate
            
        Returns:
            dict: Certificate information
        """
        if not cert_base64:
            raise ValueError("Certificate base64 content is required")
        
        if not cert_password:
            raise ValueError("Certificate password is required")
        
        print(f"🔐 Installing iOS distribution certificate...")
        
        try:
            # Create temporary directory
            self.temp_dir = tempfile.mkdtemp(prefix="ios_cert_")
            self.cert_path = Path(self.temp_dir) / "certificate.p12"
            
            # Decode base64 certificate
            print(f"   Decoding certificate...")
            cert_data = base64.b64decode(cert_base64)
            
            # Write certificate to file
            with open(self.cert_path, "wb") as f:
                f.write(cert_data)
            
            print(f"   Certificate saved to: {self.cert_path}")
            
            # Get keychain name from environment or use default
            keychain_name = os.getenv("KEYCHAIN_NAME", "build.keychain")
            keychain_password = os.getenv("KEYCHAIN_PWD", "")
            
            # Import certificate into keychain
            print(f"   Importing into keychain: {keychain_name}")
            
            # Build import command
            import_cmd = [
                "security", "import", str(self.cert_path),
                "-k", keychain_name,
                "-P", cert_password,
                "-A",  # Allow any application to access this item
                "-T", "/usr/bin/codesign"
            ]
            
            result = subprocess.run(
                import_cmd,
                capture_output=True,
                text=True,
                check=False  # Don't raise immediately, check return code
            )
            
            if result.returncode != 0:
                # Try without -A flag as fallback
                print(f"   ⚠️ Import with -A failed, trying without...")
                import_cmd_fallback = [
                    "security", "import", str(self.cert_path),
                    "-k", keychain_name,
                    "-P", cert_password,
                    "-T", "/usr/bin/codesign",
                    "-T", "/usr/bin/security"
                ]
                
                result_fallback = subprocess.run(
                    import_cmd_fallback,
                    capture_output=True,
                    text=True,
                    check=True
                )
            
            # Set key partition list (required for codesigning)
            # Only run if keychain password is available
            if keychain_password:
                print(f"   Setting key partition list...")
                subprocess.run(
                    [
                        "security", "set-key-partition-list",
                        "-S", "apple-tool:,apple:",
                        "-s",
                        "-k", keychain_password,
                        keychain_name
                    ],
                    capture_output=True,
                    text=True,
                    check=True
                )
            else:
                print(f"   ⚠️ Skipping key partition list (no keychain password available)")
            
            # Verify certificate
            print(f"   Verifying certificate...")
            result = subprocess.run(
                ["security", "find-identity", "-v", "-p", "codesigning", keychain_name],
                capture_output=True,
                text=True,
                check=True
            )
            
            print(f"✅ Certificate installed successfully")
            print(f"\n📋 Available Code Signing Identities:")
            for line in result.stdout.strip().split('\n'):
                if line.strip():
                    print(f"   {line}")
            
            return {
                "cert_path": str(self.cert_path),
                "keychain": keychain_name
            }
            
        except subprocess.CalledProcessError as e:
            print(f"❌ Failed to install certificate: {e.stderr}", file=sys.stderr)
            raise
        except Exception as e:
            print(f"❌ Failed to install certificate: {e}", file=sys.stderr)
            raise
    
    def cleanup(self) -> bool:
        """
        Remove temporary certificate files.
        
        Returns:
            bool: True if cleanup successful
        """
        print(f"🧹 Cleaning up certificate files...")
        
        try:
            if self.cert_path and self.cert_path.exists():
                self.cert_path.unlink()
                print(f"   Removed: {self.cert_path}")
            
            if self.temp_dir:
                import shutil
                shutil.rmtree(self.temp_dir, ignore_errors=True)
                print(f"   Removed temp directory: {self.temp_dir}")
            
            print(f"✅ Certificate cleanup successful")
            return True
            
        except Exception as e:
            print(f"⚠️ Warning: Failed to cleanup certificate: {e}", file=sys.stderr)
            return False
    
    def verify(self, keychain_name: str = None) -> bool:
        """
        Verify that a valid code signing certificate exists.
        
        Args:
            keychain_name: Optional keychain to check
            
        Returns:
            bool: True if valid certificate found
        """
        keychain = keychain_name or os.getenv("KEYCHAIN_NAME", "build.keychain")
        
        print(f"🔍 Verifying code signing certificate in keychain: {keychain}")
        
        try:
            result = subprocess.run(
                ["security", "find-identity", "-v", "-p", "codesigning", keychain],
                capture_output=True,
                text=True,
                check=True
            )
            
            # Check if any valid identities found
            identities = [line for line in result.stdout.split('\n') if 'valid identities found' in line.lower()]
            
            if identities and not '0 valid identities found' in identities[0]:
                print(f"✅ Valid code signing certificate found")
                print(result.stdout)
                return True
            else:
                print(f"❌ No valid code signing certificates found", file=sys.stderr)
                return False
                
        except subprocess.CalledProcessError as e:
            print(f"❌ Failed to verify certificate: {e.stderr}", file=sys.stderr)
            return False


def main():
    parser = argparse.ArgumentParser(
        description="Manage iOS distribution certificates",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Install certificate from base64
  python ios_certificate.py install \\
    --cert-base64 "$(cat cert.p12 | base64)" \\
    --cert-password "mypassword"
  
  # Install from environment variables
  python ios_certificate.py install \\
    --cert-base64 "$IOS_DISTRIBUTION_CERT_BASE64" \\
    --cert-password "$IOS_DISTRIBUTION_CERT_PASSWORD"
  
  # Verify certificate exists
  python ios_certificate.py verify
  
  # Cleanup temporary files
  python ios_certificate.py cleanup
        """
    )
    
    parser.add_argument(
        "action",
        choices=["install", "cleanup", "verify"],
        help="Action to perform"
    )
    
    parser.add_argument(
        "--cert-base64",
        help="Base64-encoded .p12 certificate",
        default=None
    )
    
    parser.add_argument(
        "--cert-password",
        help="Certificate password",
        default=None
    )
    
    parser.add_argument(
        "--keychain",
        help="Keychain name (default: build.keychain)",
        default=None
    )
    
    args = parser.parse_args()
    
    manager = CertificateManager()
    
    try:
        if args.action == "install":
            if not args.cert_base64 or not args.cert_password:
                parser.error("--cert-base64 and --cert-password are required for install")
            
            result = manager.install(args.cert_base64, args.cert_password)
            print(f"\n📋 Certificate Info:")
            print(f"   Path: {result['cert_path']}")
            print(f"   Keychain: {result['keychain']}")
            sys.exit(0)
            
        elif args.action == "verify":
            if manager.verify(args.keychain):
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
