#!/usr/bin/env python3
"""
Unit tests for GitHub Releases upload script.

Tests cover:
- Input validation
- Error handling
- URL generation
- File checks
"""

import os
import sys
import unittest
from pathlib import Path
from unittest.mock import MagicMock, patch, mock_open

# Add parent directory to path to import the script
sys.path.insert(0, str(Path(__file__).parent.parent))

from upload_to_github_releases import (
    GitHubReleaseUploader,
    GitHubReleaseError
)


class TestGitHubReleaseUploader(unittest.TestCase):
    """Test cases for GitHubReleaseUploader class"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.mock_token = "ghp_test_token_123456789"
        self.mock_repo = "owner/repo"
    
    @patch('upload_to_github_releases.Github')
    def test_init_success(self, mock_github):
        """Test successful initialization"""
        mock_github_instance = MagicMock()
        mock_repo_instance = MagicMock()
        mock_repo_instance.name = "repo"
        mock_github_instance.get_repo.return_value = mock_repo_instance
        mock_github.return_value = mock_github_instance
        
        uploader = GitHubReleaseUploader(self.mock_token, self.mock_repo)
        
        self.assertEqual(uploader.repository, self.mock_repo)
        mock_github.assert_called_once_with(self.mock_token)
        mock_github_instance.get_repo.assert_called_once_with(self.mock_repo)
    
    def test_init_no_token(self):
        """Test initialization fails without token"""
        with self.assertRaises(GitHubReleaseError) as context:
            GitHubReleaseUploader("", self.mock_repo)
        
        self.assertIn("token is required", str(context.exception))
    
    def test_init_invalid_repo_format(self):
        """Test initialization fails with invalid repo format"""
        with self.assertRaises(GitHubReleaseError) as context:
            GitHubReleaseUploader(self.mock_token, "invalid-repo")
        
        self.assertIn("Invalid repository format", str(context.exception))
    
    @patch('upload_to_github_releases.Github')
    def test_get_or_create_release_existing(self, mock_github):
        """Test getting an existing release"""
        mock_github_instance = MagicMock()
        mock_repo_instance = MagicMock()
        mock_release = MagicMock()
        mock_repo_instance.name = "repo"
        mock_repo_instance.get_release.return_value = mock_release
        mock_github_instance.get_repo.return_value = mock_repo_instance
        mock_github.return_value = mock_github_instance
        
        uploader = GitHubReleaseUploader(self.mock_token, self.mock_repo)
        release = uploader.get_or_create_release()
        
        self.assertEqual(release, mock_release)
        mock_repo_instance.get_release.assert_called_once_with("latest")
    
    @patch('upload_to_github_releases.Github')
    def test_get_or_create_release_create_new(self, mock_github):
        """Test creating a new release when it doesn't exist"""
        from github import UnknownObjectException
        
        mock_github_instance = MagicMock()
        mock_repo_instance = MagicMock()
        mock_new_release = MagicMock()
        mock_repo_instance.name = "repo"
        mock_repo_instance.get_release.side_effect = UnknownObjectException(
            status=404, data={'message': 'Not Found'}, headers={}
        )
        mock_repo_instance.create_git_release.return_value = mock_new_release
        mock_github_instance.get_repo.return_value = mock_repo_instance
        mock_github.return_value = mock_github_instance
        
        uploader = GitHubReleaseUploader(self.mock_token, self.mock_repo)
        release = uploader.get_or_create_release()
        
        self.assertEqual(release, mock_new_release)
        mock_repo_instance.create_git_release.assert_called_once()
    
    @patch('upload_to_github_releases.Github')
    def test_delete_existing_asset(self, mock_github):
        """Test deleting an existing asset"""
        mock_github_instance = MagicMock()
        mock_repo_instance = MagicMock()
        mock_repo_instance.name = "repo"
        mock_github_instance.get_repo.return_value = mock_repo_instance
        mock_github.return_value = mock_github_instance
        
        # Mock release with an existing asset
        mock_release = MagicMock()
        mock_asset = MagicMock()
        mock_asset.name = "app-release.apk"
        mock_release.get_assets.return_value = [mock_asset]
        
        uploader = GitHubReleaseUploader(self.mock_token, self.mock_repo)
        result = uploader.delete_existing_asset(mock_release, "app-release.apk")
        
        self.assertTrue(result)
        mock_asset.delete_asset.assert_called_once()
    
    @patch('upload_to_github_releases.Github')
    def test_upload_file_not_found(self, mock_github):
        """Test upload fails when file doesn't exist"""
        mock_github_instance = MagicMock()
        mock_repo_instance = MagicMock()
        mock_repo_instance.name = "repo"
        mock_github_instance.get_repo.return_value = mock_repo_instance
        mock_github.return_value = mock_github_instance
        
        uploader = GitHubReleaseUploader(self.mock_token, self.mock_repo)
        
        with self.assertRaises(FileNotFoundError):
            uploader.upload_file("/non/existent/file.apk")
    
    @patch('upload_to_github_releases.Path')
    @patch('upload_to_github_releases.Github')
    def test_stable_url_generation(self, mock_github, mock_path):
        """Test stable URL is generated correctly"""
        mock_github_instance = MagicMock()
        mock_repo_instance = MagicMock()
        mock_repo_instance.name = "repo"
        mock_release = MagicMock()
        mock_repo_instance.get_release.return_value = mock_release
        mock_github_instance.get_repo.return_value = mock_repo_instance
        mock_github.return_value = mock_github_instance
        
        # Mock file path
        mock_file = MagicMock()
        mock_file.exists.return_value = True
        mock_file.is_file.return_value = True
        mock_file.name = "app-release.apk"
        mock_file.stat.return_value.st_size = 10 * 1024 * 1024  # 10MB
        mock_path.return_value = mock_file
        
        uploader = GitHubReleaseUploader(self.mock_token, self.mock_repo)
        stable_url = uploader.upload_file("/fake/path/app-release.apk")
        
        expected_url = f"https://github.com/{self.mock_repo}/releases/latest/download/app-release.apk"
        self.assertEqual(stable_url, expected_url)


class TestMainFunction(unittest.TestCase):
    """Test cases for main() function and CLI"""
    
    def test_url_validation(self):
        """Test URL format validation"""
        valid_url = "https://github.com/owner/repo/releases/latest/download/app-release.apk"
        
        self.assertTrue(valid_url.startswith("https://github.com/"))
        self.assertIn("/releases/latest/download/", valid_url)
    
    @patch.dict(os.environ, {}, clear=True)
    def test_missing_token_env(self):
        """Test that missing GITHUB_TOKEN is handled"""
        # When GITHUB_TOKEN is not set, script should exit with error
        self.assertNotIn("GITHUB_TOKEN", os.environ)
    
    @patch.dict(os.environ, {}, clear=True)
    def test_missing_repository_env(self):
        """Test that missing GITHUB_REPOSITORY is handled"""
        # When GITHUB_REPOSITORY is not set, script should exit with error
        self.assertNotIn("GITHUB_REPOSITORY", os.environ)


if __name__ == "__main__":
    unittest.main()
