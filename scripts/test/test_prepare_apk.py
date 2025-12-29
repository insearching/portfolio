#!/usr/bin/env python3
"""
Unit tests for APK preparation script.

Tests cover:
- Version extraction from pubspec.yaml
- APK file validation
- File copying and renaming
- Error handling
- Output generation
"""

import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import MagicMock, patch, mock_open

# Add parent directory to path to import the script
sys.path.insert(0, str(Path(__file__).parent.parent))

from prepare_apk import (
    APKPreparer,
    APKPreparationError
)


class TestAPKPreparer(unittest.TestCase):
    """Test cases for APKPreparer class"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.temp_dir = tempfile.mkdtemp()
        self.test_project_root = Path(self.temp_dir)
        
        # Create a mock pubspec.yaml
        self.pubspec_path = self.test_project_root / "pubspec.yaml"
        self.pubspec_content = """
name: portfolio
description: Test project
version: 1.0.0+1
environment:
  sdk: '>=3.0.0 <4.0.0'
"""
        self.pubspec_path.write_text(self.pubspec_content)
    
    def tearDown(self):
        """Clean up test fixtures"""
        import shutil
        if Path(self.temp_dir).exists():
            shutil.rmtree(self.temp_dir)
    
    def test_init_success(self):
        """Test successful initialization"""
        preparer = APKPreparer(project_root=self.test_project_root)
        
        self.assertEqual(preparer.project_root, self.test_project_root)
        self.assertEqual(preparer.pubspec_path, self.pubspec_path)
    
    def test_init_no_pubspec(self):
        """Test initialization fails when pubspec.yaml is missing"""
        self.pubspec_path.unlink()
        
        with self.assertRaises(APKPreparationError) as context:
            APKPreparer(project_root=self.test_project_root)
        
        self.assertIn("pubspec.yaml not found", str(context.exception))
    
    def test_extract_version_success(self):
        """Test successful version extraction"""
        preparer = APKPreparer(project_root=self.test_project_root)
        version = preparer.extract_version()
        
        self.assertEqual(version, "1.0.0+1")
    
    def test_extract_version_no_version_field(self):
        """Test version extraction fails when version field is missing"""
        # Create pubspec without version
        self.pubspec_path.write_text("""
name: portfolio
description: Test project
""")
        
        preparer = APKPreparer(project_root=self.test_project_root)
        
        with self.assertRaises(APKPreparationError) as context:
            preparer.extract_version()
        
        self.assertIn("Version field not found", str(context.exception))
    
    def test_extract_version_empty_version(self):
        """Test version extraction fails when version is empty"""
        # Create pubspec with empty version (YAML treats empty string as null)
        self.pubspec_path.write_text("""
name: portfolio
version:
""")
        
        preparer = APKPreparer(project_root=self.test_project_root)
        
        with self.assertRaises(APKPreparationError) as context:
            preparer.extract_version()
        
        # Empty version in YAML becomes None, so it triggers "not found" error
        self.assertIn("Version field not found", str(context.exception))
    
    def test_extract_version_different_formats(self):
        """Test version extraction with different version formats"""
        test_versions = [
            "1.0.0",
            "2.3.4+5",
            "0.1.0-beta",
            "10.20.30+100",
        ]
        
        for version in test_versions:
            with self.subTest(version=version):
                self.pubspec_path.write_text(f"""
name: portfolio
version: {version}
""")
                preparer = APKPreparer(project_root=self.test_project_root)
                extracted = preparer.extract_version()
                self.assertEqual(extracted, version)
    
    def test_validate_source_apk_success(self):
        """Test successful APK validation"""
        # Create a test APK file
        test_apk = self.test_project_root / "test.apk"
        test_apk.write_bytes(b"fake apk content")
        
        preparer = APKPreparer(project_root=self.test_project_root)
        
        # Should not raise any exception
        preparer.validate_source_apk(test_apk)
    
    def test_validate_source_apk_not_found(self):
        """Test APK validation fails when file doesn't exist"""
        preparer = APKPreparer(project_root=self.test_project_root)
        non_existent = self.test_project_root / "non-existent.apk"
        
        with self.assertRaises(FileNotFoundError):
            preparer.validate_source_apk(non_existent)
    
    def test_validate_source_apk_not_file(self):
        """Test APK validation fails when path is a directory"""
        test_dir = self.test_project_root / "test_dir"
        test_dir.mkdir()
        
        preparer = APKPreparer(project_root=self.test_project_root)
        
        with self.assertRaises(APKPreparationError) as context:
            preparer.validate_source_apk(test_dir)
        
        self.assertIn("not a file", str(context.exception))
    
    def test_validate_source_apk_wrong_extension(self):
        """Test APK validation fails with wrong file extension"""
        test_file = self.test_project_root / "test.txt"
        test_file.write_text("not an apk")
        
        preparer = APKPreparer(project_root=self.test_project_root)
        
        with self.assertRaises(APKPreparationError) as context:
            preparer.validate_source_apk(test_file)
        
        self.assertIn("not an APK", str(context.exception))
    
    def test_prepare_apk_files_success(self):
        """Test successful APK preparation"""
        # Create a source APK
        source_apk = self.test_project_root / "app-release.apk"
        test_content = b"fake apk content with some data"
        source_apk.write_bytes(test_content)
        
        preparer = APKPreparer(project_root=self.test_project_root)
        result = preparer.prepare_apk_files(str(source_apk))
        
        # Verify result structure
        self.assertIn('version', result)
        self.assertIn('versioned_path', result)
        self.assertIn('versioned_name', result)
        self.assertIn('stable_path', result)
        self.assertIn('stable_name', result)
        
        # Verify version
        self.assertEqual(result['version'], "1.0.0+1")
        
        # Verify filenames
        self.assertEqual(result['versioned_name'], "app-portfolio-release-1.0.0+1.apk")
        self.assertEqual(result['stable_name'], "app-portfolio-release-latest.apk")
        
        # Verify files exist
        versioned_path = Path(result['versioned_path'])
        stable_path = Path(result['stable_path'])
        
        self.assertTrue(versioned_path.exists())
        self.assertTrue(stable_path.exists())
        
        # Verify file contents
        self.assertEqual(versioned_path.read_bytes(), test_content)
        self.assertEqual(stable_path.read_bytes(), test_content)
    
    def test_prepare_apk_files_custom_base_name(self):
        """Test APK preparation with custom base name"""
        source_apk = self.test_project_root / "app-release.apk"
        source_apk.write_bytes(b"fake apk content")
        
        preparer = APKPreparer(project_root=self.test_project_root)
        result = preparer.prepare_apk_files(
            str(source_apk),
            base_name="myapp-custom"
        )
        
        # Verify custom base name is used
        self.assertEqual(result['versioned_name'], "myapp-custom-1.0.0+1.apk")
        self.assertEqual(result['stable_name'], "myapp-custom-latest.apk")
    
    def test_prepare_apk_files_custom_output_dir(self):
        """Test APK preparation with custom output directory"""
        source_apk = self.test_project_root / "app-release.apk"
        source_apk.write_bytes(b"fake apk content")
        
        output_dir = self.test_project_root / "dist"
        
        preparer = APKPreparer(project_root=self.test_project_root)
        result = preparer.prepare_apk_files(
            str(source_apk),
            output_dir=str(output_dir)
        )
        
        # Verify files are in custom directory
        versioned_path = Path(result['versioned_path']).resolve()
        stable_path = Path(result['stable_path']).resolve()
        output_dir_resolved = output_dir.resolve()
        
        self.assertEqual(versioned_path.parent, output_dir_resolved)
        self.assertEqual(stable_path.parent, output_dir_resolved)
        self.assertTrue(versioned_path.exists())
        self.assertTrue(stable_path.exists())
    
    def test_prepare_apk_files_source_not_found(self):
        """Test APK preparation fails when source doesn't exist"""
        preparer = APKPreparer(project_root=self.test_project_root)
        
        with self.assertRaises(FileNotFoundError):
            preparer.prepare_apk_files("non-existent.apk")
    
    def test_prepare_apk_files_creates_output_dir(self):
        """Test that output directory is created if it doesn't exist"""
        source_apk = self.test_project_root / "app-release.apk"
        source_apk.write_bytes(b"fake apk content")
        
        output_dir = self.test_project_root / "new" / "nested" / "dir"
        
        preparer = APKPreparer(project_root=self.test_project_root)
        result = preparer.prepare_apk_files(
            str(source_apk),
            output_dir=str(output_dir)
        )
        
        # Verify output directory was created
        self.assertTrue(output_dir.exists())
        self.assertTrue(output_dir.is_dir())
        
        # Verify files exist in the new directory
        versioned_path = Path(result['versioned_path'])
        self.assertTrue(versioned_path.exists())


class TestFilenameGeneration(unittest.TestCase):
    """Test cases for filename generation logic"""
    
    def test_version_formats_in_filenames(self):
        """Test that various version formats are correctly used in filenames"""
        test_cases = [
            ("1.0.0+1", "app-portfolio-release-1.0.0+1.apk"),
            ("2.3.4", "app-portfolio-release-2.3.4.apk"),
            ("0.1.0-beta", "app-portfolio-release-0.1.0-beta.apk"),
            ("10.20.30+100", "app-portfolio-release-10.20.30+100.apk"),
        ]
        
        for version, expected_filename in test_cases:
            with self.subTest(version=version):
                base_name = "app-portfolio-release"
                generated_name = f"{base_name}-{version}.apk"
                self.assertEqual(generated_name, expected_filename)


class TestIntegration(unittest.TestCase):
    """Integration tests for end-to-end functionality"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.temp_dir = tempfile.mkdtemp()
        self.test_project_root = Path(self.temp_dir)
        
        # Create pubspec.yaml
        self.pubspec_path = self.test_project_root / "pubspec.yaml"
        self.pubspec_path.write_text("""
name: portfolio
version: 2.5.3+42
""")
    
    def tearDown(self):
        """Clean up test fixtures"""
        import shutil
        if Path(self.temp_dir).exists():
            shutil.rmtree(self.temp_dir)
    
    def test_full_workflow(self):
        """Test complete APK preparation workflow"""
        # Create source APK with realistic size
        source_apk = self.test_project_root / "build" / "app" / "outputs" / "flutter-apk" / "app-release.apk"
        source_apk.parent.mkdir(parents=True)
        
        # Create fake APK content (simulate real APK size)
        fake_content = b"APK" * 10000  # ~30KB
        source_apk.write_bytes(fake_content)
        
        # Prepare APK files
        preparer = APKPreparer(project_root=self.test_project_root)
        result = preparer.prepare_apk_files(str(source_apk))
        
        # Verify all expected outputs
        self.assertEqual(result['version'], "2.5.3+42")
        self.assertEqual(result['versioned_name'], "app-portfolio-release-2.5.3+42.apk")
        self.assertEqual(result['stable_name'], "app-portfolio-release-latest.apk")
        
        # Verify both files exist and have correct content
        versioned_path = Path(result['versioned_path'])
        stable_path = Path(result['stable_path'])
        
        self.assertTrue(versioned_path.exists())
        self.assertTrue(stable_path.exists())
        
        self.assertEqual(versioned_path.read_bytes(), fake_content)
        self.assertEqual(stable_path.read_bytes(), fake_content)
        
        # Verify file sizes
        self.assertEqual(versioned_path.stat().st_size, len(fake_content))
        self.assertEqual(stable_path.stat().st_size, len(fake_content))


if __name__ == "__main__":
    unittest.main()
