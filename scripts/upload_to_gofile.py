#!/usr/bin/env python3
"""
Upload Android APK to Gofile.io

This script handles uploading APK files to Gofile.io cloud storage service.
It retrieves the best server, uploads the file, and returns the download URL.
"""

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Dict, Optional, Tuple

import requests


class GofileUploadError(Exception):
    """Custom exception for Gofile upload errors."""
    pass


class GofileUploader:
    """Handles uploading files to Gofile.io"""
    
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
            
            return server_name
            
        except requests.RequestException as e:
            raise GofileUploadError(f"Network error while getting server: {e}")
        except (KeyError, IndexError) as e:
            raise GofileUploadError(f"Invalid server response format: {e}")
    
    def upload_file(
        self,
        file_path: str,
        folder_id: Optional[str] = None
    ) -> Dict[str, str]:
        """
        Upload a file to Gofile.io
        
        Args:
            file_path: Path to the file to upload
            folder_id: Optional folder ID to upload to
            
        Returns:
            Dictionary containing upload information:
                - download_page: URL to download page
                - file_id: Unique file identifier
                - file_name: Name of uploaded file
                
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
            print(f"Uploading {file_path_obj.name} to server: {server}")
            
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
            
            return {
                'download_page': upload_data.get('downloadPage', ''),
                'file_id': upload_data.get('fileId', ''),
                'file_name': upload_data.get('fileName', file_path_obj.name),
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
    
    args = parser.parse_args()
    
    try:
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
        
        # Print results
        print("\n" + "="*60)
        print("Upload Successful!")
        print("="*60)
        print(f"File Name:     {result['file_name']}")
        print(f"File ID:       {result['file_id']}")
        print(f"Server:        {result['server']}")
        print(f"Download URL:  {result['download_page']}")
        print("="*60)
        
        # Save to JSON if requested
        if args.output_json:
            with open(args.output_json, 'w') as f:
                json.dump(result, f, indent=2)
            print(f"\nResult saved to: {args.output_json}")
        
        # Output for GitHub Actions
        if args.github_output:
            github_output = os.environ.get('GITHUB_OUTPUT')
            if github_output:
                with open(github_output, 'a') as f:
                    f.write(f"download_url={result['download_page']}\n")
                    f.write(f"file_id={result['file_id']}\n")
            else:
                # Fallback to environment variable format
                print(f"\nAPK_DOWNLOAD_URL={result['download_page']}")
                print(f"APK_FILE_ID={result['file_id']}")
        
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
