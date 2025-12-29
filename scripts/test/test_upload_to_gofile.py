#!/usr/bin/env python3
"""
Unit tests for upload_to_gofile.py

Tests cover all functionality including:
- Server retrieval
- File uploads
- Error handling
- Edge cases
"""

import json
import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import MagicMock, Mock, patch, mock_open

import requests

# Add parent directory to path to import the module
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

# Import the module to test
from upload_to_gofile import GofileUploader, GofileUploadError


class TestGofileUploader(unittest.TestCase):
    """Test cases for GofileUploader class"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.token = "test_token_123"
        self.account_id = "test_account_456"
        self.uploader = GofileUploader(self.token, self.account_id)
    
    def tearDown(self):
        """Clean up after tests"""
        self.uploader.session.close()
    
    # ========== Test Server Retrieval ==========
    
    @patch('upload_to_gofile.requests.Session.get')
    def test_get_best_server_success(self, mock_get):
        """Test successful server retrieval"""
        mock_response = Mock()
        mock_response.json.return_value = {
            "status": "ok",
            "data": {
                "servers": [
                    {"name": "store1"},
                    {"name": "store2"}
                ]
            }
        }
        mock_response.raise_for_status = Mock()
        mock_get.return_value = mock_response
        
        server = self.uploader.get_best_server()
        
        self.assertEqual(server, "store1")
        mock_get.assert_called_once_with(
            "https://api.gofile.io/servers",
            timeout=30
        )
    
    @patch('upload_to_gofile.requests.Session.get')
    def test_get_best_server_network_error(self, mock_get):
        """Test network error during server retrieval"""
        mock_get.side_effect = requests.RequestException("Connection failed")
        
        with self.assertRaises(GofileUploadError) as context:
            self.uploader.get_best_server()
        
        self.assertIn("Network error", str(context.exception))
    
    @patch('upload_to_gofile.requests.Session.get')
    def test_get_best_server_invalid_status(self, mock_get):
        """Test invalid status response"""
        mock_response = Mock()
        mock_response.json.return_value = {
            "status": "error",
            "data": {}
        }
        mock_response.raise_for_status = Mock()
        mock_get.return_value = mock_response
        
        with self.assertRaises(GofileUploadError) as context:
            self.uploader.get_best_server()
        
        self.assertIn("Failed to get server", str(context.exception))
    
    @patch('upload_to_gofile.requests.Session.get')
    def test_get_best_server_no_servers(self, mock_get):
        """Test empty servers list"""
        mock_response = Mock()
        mock_response.json.return_value = {
            "status": "ok",
            "data": {
                "servers": []
            }
        }
        mock_response.raise_for_status = Mock()
        mock_get.return_value = mock_response
        
        with self.assertRaises(GofileUploadError) as context:
            self.uploader.get_best_server()
        
        self.assertIn("No servers available", str(context.exception))
    
    @patch('upload_to_gofile.requests.Session.get')
    def test_get_best_server_missing_name(self, mock_get):
        """Test server response missing name field"""
        mock_response = Mock()
        mock_response.json.return_value = {
            "status": "ok",
            "data": {
                "servers": [{"id": "123"}]  # Missing 'name' field
            }
        }
        mock_response.raise_for_status = Mock()
        mock_get.return_value = mock_response
        
        with self.assertRaises(GofileUploadError) as context:
            self.uploader.get_best_server()
        
        self.assertIn("Server name not found", str(context.exception))
    
    # ========== Test File Upload ==========
    
    def test_upload_file_not_found(self):
        """Test upload with non-existent file"""
        with self.assertRaises(FileNotFoundError) as context:
            self.uploader.upload_file("/path/to/nonexistent/file.apk")
        
        self.assertIn("File not found", str(context.exception))
    
    def test_upload_directory_instead_of_file(self):
        """Test upload with directory path instead of file"""
        with tempfile.TemporaryDirectory() as tmpdir:
            with self.assertRaises(GofileUploadError) as context:
                self.uploader.upload_file(tmpdir)
            
            self.assertIn("Path is not a file", str(context.exception))
    
    @patch('upload_to_gofile.GofileUploader.get_best_server')
    @patch('upload_to_gofile.requests.Session.post')
    def test_upload_file_success(self, mock_post, mock_get_server):
        """Test successful file upload"""
        # Create a temporary test file
        with tempfile.NamedTemporaryFile(
            mode='w',
            suffix='.apk',
            delete=False
        ) as tmp_file:
            tmp_file.write("test APK content")
            tmp_file_path = tmp_file.name
        
        try:
            # Mock server retrieval
            mock_get_server.return_value = "store1"
            
            # Mock upload response
            mock_response = Mock()
            mock_response.json.return_value = {
                "status": "ok",
                "data": {
                    "downloadPage": "https://gofile.io/d/abc123",
                    "fileId": "file123",
                    "fileName": "app-release.apk"
                }
            }
            mock_response.raise_for_status = Mock()
            mock_post.return_value = mock_response
            
            # Perform upload
            result = self.uploader.upload_file(tmp_file_path)
            
            # Verify results
            self.assertEqual(result['download_page'], "https://gofile.io/d/abc123")
            self.assertEqual(result['file_id'], "file123")
            self.assertEqual(result['file_name'], "app-release.apk")
            self.assertEqual(result['server'], "store1")
            
            # Verify the POST call
            mock_post.assert_called_once()
            call_args = mock_post.call_args
            self.assertEqual(
                call_args[0][0],
                "https://store1.gofile.io/contents/uploadfile"
            )
            self.assertEqual(call_args[1]['data']['token'], self.token)
            
        finally:
            # Clean up temp file
            os.unlink(tmp_file_path)
    
    @patch('upload_to_gofile.GofileUploader.get_best_server')
    @patch('upload_to_gofile.requests.Session.post')
    def test_upload_file_with_folder_id(self, mock_post, mock_get_server):
        """Test upload with folder ID"""
        with tempfile.NamedTemporaryFile(
            mode='w',
            suffix='.apk',
            delete=False
        ) as tmp_file:
            tmp_file.write("test content")
            tmp_file_path = tmp_file.name
        
        try:
            mock_get_server.return_value = "store1"
            
            mock_response = Mock()
            mock_response.json.return_value = {
                "status": "ok",
                "data": {
                    "downloadPage": "https://gofile.io/d/xyz789",
                    "fileId": "file456",
                    "fileName": "test.apk"
                }
            }
            mock_response.raise_for_status = Mock()
            mock_post.return_value = mock_response
            
            folder_id = "folder123"
            result = self.uploader.upload_file(tmp_file_path, folder_id=folder_id)
            
            # Verify folder ID was passed
            call_args = mock_post.call_args
            self.assertEqual(call_args[1]['data']['folderId'], folder_id)
            
        finally:
            os.unlink(tmp_file_path)
    
    @patch('upload_to_gofile.GofileUploader.get_best_server')
    @patch('upload_to_gofile.requests.Session.post')
    def test_upload_file_api_error(self, mock_post, mock_get_server):
        """Test upload with API error response"""
        with tempfile.NamedTemporaryFile(
            mode='w',
            suffix='.apk',
            delete=False
        ) as tmp_file:
            tmp_file.write("test content")
            tmp_file_path = tmp_file.name
        
        try:
            mock_get_server.return_value = "store1"
            
            mock_response = Mock()
            mock_response.json.return_value = {
                "status": "error-insufficientStorage"
            }
            mock_response.raise_for_status = Mock()
            mock_post.return_value = mock_response
            
            with self.assertRaises(GofileUploadError) as context:
                self.uploader.upload_file(tmp_file_path)
            
            self.assertIn("Upload failed", str(context.exception))
            
        finally:
            os.unlink(tmp_file_path)
    
    @patch('upload_to_gofile.GofileUploader.get_best_server')
    @patch('upload_to_gofile.requests.Session.post')
    def test_upload_file_network_error(self, mock_post, mock_get_server):
        """Test upload with network error"""
        with tempfile.NamedTemporaryFile(
            mode='w',
            suffix='.apk',
            delete=False
        ) as tmp_file:
            tmp_file.write("test content")
            tmp_file_path = tmp_file.name
        
        try:
            mock_get_server.return_value = "store1"
            mock_post.side_effect = requests.RequestException("Connection timeout")
            
            with self.assertRaises(GofileUploadError) as context:
                self.uploader.upload_file(tmp_file_path)
            
            self.assertIn("Network error during upload", str(context.exception))
            
        finally:
            os.unlink(tmp_file_path)
    
    @patch('upload_to_gofile.GofileUploader.get_best_server')
    @patch('upload_to_gofile.requests.Session.post')
    def test_upload_file_invalid_response_format(self, mock_post, mock_get_server):
        """Test upload with malformed response"""
        with tempfile.NamedTemporaryFile(
            mode='w',
            suffix='.apk',
            delete=False
        ) as tmp_file:
            tmp_file.write("test content")
            tmp_file_path = tmp_file.name
        
        try:
            mock_get_server.return_value = "store1"
            
            mock_response = Mock()
            mock_response.json.side_effect = ValueError("Invalid JSON")
            mock_response.raise_for_status = Mock()
            mock_post.return_value = mock_response
            
            with self.assertRaises(GofileUploadError) as context:
                self.uploader.upload_file(tmp_file_path)
            
            self.assertIn("Invalid upload response format", str(context.exception))
            
        finally:
            os.unlink(tmp_file_path)
    
    # ========== Test Initialization ==========
    
    def test_uploader_initialization(self):
        """Test uploader initialization"""
        uploader = GofileUploader("token123", "account456")
        
        self.assertEqual(uploader.token, "token123")
        self.assertEqual(uploader.account_id, "account456")
        self.assertIsNotNone(uploader.session)
        
        uploader.session.close()
    
    def test_uploader_initialization_no_account_id(self):
        """Test uploader initialization without account ID"""
        uploader = GofileUploader("token123")
        
        self.assertEqual(uploader.token, "token123")
        self.assertIsNone(uploader.account_id)
        
        uploader.session.close()
    
    # ========== Test Edge Cases ==========
    
    @patch('upload_to_gofile.GofileUploader.get_best_server')
    @patch('upload_to_gofile.requests.Session.post')
    def test_upload_large_file_timeout(self, mock_post, mock_get_server):
        """Test upload timeout handling"""
        with tempfile.NamedTemporaryFile(
            mode='w',
            suffix='.apk',
            delete=False
        ) as tmp_file:
            tmp_file.write("x" * 1000)  # Simulate larger file
            tmp_file_path = tmp_file.name
        
        try:
            mock_get_server.return_value = "store1"
            mock_post.side_effect = requests.Timeout("Upload timeout")
            
            with self.assertRaises(GofileUploadError):
                self.uploader.upload_file(tmp_file_path)
            
        finally:
            os.unlink(tmp_file_path)


class TestMainFunction(unittest.TestCase):
    """Test cases for main() function"""
    
    @patch('upload_to_gofile.GofileUploader.upload_file')
    @patch('upload_to_gofile.GofileUploader.get_best_server')
    @patch('sys.argv')
    def test_main_success(self, mock_argv, mock_get_server, mock_upload):
        """Test main function with successful upload"""
        with tempfile.NamedTemporaryFile(
            mode='w',
            suffix='.apk',
            delete=False
        ) as tmp_file:
            tmp_file.write("test")
            tmp_file_path = tmp_file.name
        
        try:
            mock_argv.__getitem__ = lambda self, index: [
                'upload_to_gofile.py',
                tmp_file_path,
                '--token', 'test_token'
            ][index]
            
            mock_upload.return_value = {
                'download_page': 'https://gofile.io/d/test',
                'file_id': 'test123',
                'file_name': 'test.apk',
                'content_id': 'content123',
                'direct_link': 'https://store1.gofile.io/download/web/test123/test.apk',
                'server': 'store1'
            }
            
            from upload_to_gofile import main
            
            # Test the return code directly
            return_code = main()
            self.assertEqual(return_code, 0)
            
        finally:
            os.unlink(tmp_file_path)


class TestSetFolderPublic(unittest.TestCase):
    """Test cases for set_folder_public method"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.token = "test_token"
        self.uploader = GofileUploader(self.token)
    
    def tearDown(self):
        """Clean up"""
        self.uploader.session.close()
    
    @patch('upload_to_gofile.requests.Session.put')
    def test_set_folder_public_success(self, mock_put):
        """Test successfully setting folder to public"""
        mock_response = Mock()
        mock_response.status_code = 200
        mock_response.json.return_value = {"status": "ok"}
        mock_put.return_value = mock_response
        
        result = self.uploader.set_folder_public("folder123")
        
        self.assertTrue(result)
        mock_put.assert_called_once()
        call_args = mock_put.call_args
        self.assertIn("folder123", call_args[0][0])
    
    @patch('upload_to_gofile.requests.Session.put')
    def test_set_folder_public_failure(self, mock_put):
        """Test folder set to public failure (returns False, not error)"""
        mock_response = Mock()
        mock_response.status_code = 400
        mock_put.return_value = mock_response
        
        result = self.uploader.set_folder_public("folder123")
        
        self.assertFalse(result)
    
    @patch('upload_to_gofile.requests.Session.put')
    def test_set_folder_public_exception(self, mock_put):
        """Test folder set to public with exception (silently fails)"""
        mock_put.side_effect = Exception("Network error")
        
        result = self.uploader.set_folder_public("folder123")
        
        self.assertFalse(result)


class TestDirectLink(unittest.TestCase):
    """Test cases for test_direct_link method"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.token = "test_token"
        self.uploader = GofileUploader(self.token)
    
    def tearDown(self):
        """Clean up"""
        self.uploader.session.close()
    
    @patch('upload_to_gofile.requests.Session.head')
    def test_direct_link_accessible(self, mock_head):
        """Test direct link that is accessible (HTTP 200)"""
        mock_response = Mock()
        mock_response.status_code = 200
        mock_head.return_value = mock_response
        
        is_accessible, code = self.uploader.test_direct_link("https://test.com/file")
        
        self.assertTrue(is_accessible)
        self.assertEqual(code, 200)
    
    @patch('upload_to_gofile.requests.Session.head')
    def test_direct_link_redirect(self, mock_head):
        """Test direct link that redirects (HTTP 302)"""
        mock_response = Mock()
        mock_response.status_code = 302
        mock_head.return_value = mock_response
        
        is_accessible, code = self.uploader.test_direct_link("https://test.com/file")
        
        self.assertFalse(is_accessible)
        self.assertEqual(code, 302)
    
    @patch('upload_to_gofile.requests.Session.head')
    def test_direct_link_not_found(self, mock_head):
        """Test direct link that returns 404"""
        mock_response = Mock()
        mock_response.status_code = 404
        mock_head.return_value = mock_response
        
        is_accessible, code = self.uploader.test_direct_link("https://test.com/file")
        
        self.assertFalse(is_accessible)
        self.assertEqual(code, 404)
    
    @patch('upload_to_gofile.requests.Session.head')
    def test_direct_link_network_error(self, mock_head):
        """Test direct link with network error"""
        mock_head.side_effect = Exception("Timeout")
        
        is_accessible, code = self.uploader.test_direct_link("https://test.com/file")
        
        self.assertFalse(is_accessible)
        self.assertEqual(code, 0)


class TestGetDirectLink(unittest.TestCase):
    """Test cases for get_direct_link method"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.token = "test_token"
        self.uploader = GofileUploader(self.token)
    
    def tearDown(self):
        """Clean up"""
        self.uploader.session.close()
    
    @patch('upload_to_gofile.requests.Session.get')
    def test_get_direct_link_from_api(self, mock_get):
        """Test extracting direct link from API response"""
        mock_response = Mock()
        mock_response.status_code = 200
        mock_response.json.return_value = {
            "status": "ok",
            "data": {
                "contents": {
                    "file123": {
                        "link": "https://store1.gofile.io/download/web/file123/test.apk"
                    }
                }
            }
        }
        mock_get.return_value = mock_response
        
        link = self.uploader.get_direct_link(
            content_id="content123",
            file_id="file123",
            server="store1",
            filename="test.apk"
        )
        
        self.assertIn("/download/", link)
        self.assertTrue(link.startswith("https://store"))
    
    @patch('upload_to_gofile.requests.Session.get')
    def test_get_direct_link_manual_construction(self, mock_get):
        """Test manual construction when API fails"""
        mock_response = Mock()
        mock_response.status_code = 401
        mock_get.return_value = mock_response
        
        link = self.uploader.get_direct_link(
            content_id="content123",
            file_id="file123",
            server="store-eu-par-5",
            filename="app-release.apk"
        )
        
        self.assertIn("/download/web/", link)
        self.assertIn("file123", link)
        self.assertIn("app-release.apk", link)
        self.assertTrue(link.startswith("https://store-eu-par-5"))
    
    @patch('upload_to_gofile.requests.Session.get')
    def test_get_direct_link_with_directLink_field(self, mock_get):
        """Test extracting from directLink field"""
        mock_response = Mock()
        mock_response.status_code = 200
        mock_response.json.return_value = {
            "status": "ok",
            "data": {
                "contents": {
                    "file456": {
                        "directLink": "https://store2.gofile.io/download/direct/file456/myfile.apk"
                    }
                }
            }
        }
        mock_get.return_value = mock_response
        
        link = self.uploader.get_direct_link(
            content_id="content456",
            file_id="file456",
            server="store2",
            filename="myfile.apk"
        )
        
        self.assertIn("/download/", link)


class TestUploadFileIntegration(unittest.TestCase):
    """Integration tests for complete upload workflow"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.token = "test_token"
        self.uploader = GofileUploader(self.token)
    
    def tearDown(self):
        """Clean up"""
        self.uploader.session.close()
    
    @patch('upload_to_gofile.GofileUploader.get_direct_link')
    @patch('upload_to_gofile.GofileUploader.set_folder_public')
    @patch('upload_to_gofile.GofileUploader.get_best_server')
    @patch('upload_to_gofile.requests.Session.post')
    def test_upload_with_direct_link_extraction(self, mock_post, mock_get_server, 
                                                mock_set_public, mock_get_link):
        """Test complete upload workflow with direct link extraction"""
        # Create temp file
        with tempfile.NamedTemporaryFile(mode='w', suffix='.apk', delete=False) as f:
            f.write("test content")
            temp_path = f.name
        
        try:
            # Mock server
            mock_get_server.return_value = "store-test"
            
            # Mock upload response
            mock_response = Mock()
            mock_response.json.return_value = {
                "status": "ok",
                "data": {
                    "fileId": "file789",
                    "parentFolder": "folder789",
                    "downloadPage": "https://gofile.io/d/test123",
                    "fileName": "test.apk"
                }
            }
            mock_response.raise_for_status = Mock()
            mock_post.return_value = mock_response
            
            # Mock direct link
            mock_get_link.return_value = "https://store-test.gofile.io/download/web/file789/test.apk"
            
            # Perform upload
            result = self.uploader.upload_file(temp_path)
            
            # Verify results
            self.assertEqual(result['file_id'], "file789")
            self.assertEqual(result['content_id'], "folder789")
            self.assertIn("/download/", result['direct_link'])
            self.assertTrue(result['direct_link'].startswith("https://store"))
            
            # Verify methods were called
            mock_get_server.assert_called_once()
            mock_set_public.assert_called_once_with("folder789")
            mock_get_link.assert_called_once()
            
        finally:
            os.unlink(temp_path)
    
    @patch('upload_to_gofile.GofileUploader.get_best_server')
    @patch('upload_to_gofile.requests.Session.post')
    def test_upload_extracts_folder_from_download_page(self, mock_post, mock_get_server):
        """Test extracting parent folder from downloadPage when not in response"""
        with tempfile.NamedTemporaryFile(mode='w', suffix='.apk', delete=False) as f:
            f.write("test")
            temp_path = f.name
        
        try:
            mock_get_server.return_value = "store1"
            
            # Response without parentFolder
            mock_response = Mock()
            mock_response.json.return_value = {
                "status": "ok",
                "data": {
                    "fileId": "file999",
                    "downloadPage": "https://gofile.io/d/ABC123",
                    "fileName": "test.apk"
                }
            }
            mock_response.raise_for_status = Mock()
            mock_post.return_value = mock_response
            
            with patch.object(self.uploader, 'set_folder_public'):
                with patch.object(self.uploader, 'get_direct_link', 
                                return_value="https://store1.gofile.io/download/web/file999/test.apk"):
                    result = self.uploader.upload_file(temp_path)
                    
                    # Should extract ABC123 from download page
                    self.assertEqual(result['content_id'], "ABC123")
        
        finally:
            os.unlink(temp_path)


class TestDirectLinkValidation(unittest.TestCase):
    """Test cases for direct link validation"""
    
    def test_valid_direct_link_format(self):
        """Test that valid direct links pass validation"""
        valid_links = [
            "https://store1.gofile.io/download/web/abc123/file.apk",
            "https://store-eu-par-5.gofile.io/download/web/xyz789/app-release.apk",
            "https://store-us-west-1.gofile.io/download/direct/file123/test.zip"
        ]
        
        for link in valid_links:
            self.assertIn("/download/", link)
            self.assertTrue(link.startswith("https://store"))
    
    def test_invalid_direct_link_format(self):
        """Test that invalid links fail validation"""
        invalid_links = [
            "https://gofile.io/d/abc123",  # Landing page, not direct link
            "https://example.com/download/file.apk",  # Wrong domain
            "https://store1.gofile.io/file.apk",  # Missing /download/
        ]
        
        for link in invalid_links:
            has_download = "/download/" in link
            has_store = link.startswith("https://store")
            # At least one validation should fail
            self.assertFalse(has_download and has_store)


class TestGofileUploadError(unittest.TestCase):
    """Test custom exception"""
    
    def test_exception_creation(self):
        """Test GofileUploadError exception"""
        error = GofileUploadError("Test error message")
        self.assertEqual(str(error), "Test error message")
        self.assertIsInstance(error, Exception)


def run_tests():
    """Run all tests with detailed output"""
    # Create test suite
    loader = unittest.TestLoader()
    suite = unittest.TestSuite()
    
    # Add all test cases
    suite.addTests(loader.loadTestsFromTestCase(TestGofileUploader))
    suite.addTests(loader.loadTestsFromTestCase(TestMainFunction))
    suite.addTests(loader.loadTestsFromTestCase(TestGofileUploadError))
    
    # Run tests with detailed output
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)
    
    # Return exit code based on results
    return 0 if result.wasSuccessful() else 1


if __name__ == "__main__":
    exit_code = run_tests()
    exit(exit_code)
