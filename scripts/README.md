# Scripts

This directory contains utility scripts for the Portfolio project.

## upload_to_gofile.py

Python script for uploading APK files to Gofile.io cloud storage.

### Features

- Automatic server selection for optimal upload speed
- Support for authentication tokens and account IDs
- Folder organization support
- GitHub Actions integration
- Comprehensive error handling
- JSON output option

### Usage

#### Command Line

```bash
# Basic upload
python scripts/upload_to_gofile.py path/to/file.apk --token YOUR_TOKEN

# With account ID and folder
python scripts/upload_to_gofile.py path/to/file.apk \
  --token YOUR_TOKEN \
  --account-id YOUR_ACCOUNT_ID \
  --folder-id FOLDER_ID

# With GitHub Actions output
python scripts/upload_to_gofile.py path/to/file.apk \
  --token YOUR_TOKEN \
  --github-output

# Save result to JSON
python scripts/upload_to_gofile.py path/to/file.apk \
  --token YOUR_TOKEN \
  --output-json result.json
```

#### As a Module

```python
from upload_to_gofile import GofileUploader

uploader = GofileUploader(
    token="YOUR_TOKEN",
    account_id="YOUR_ACCOUNT_ID"
)

result = uploader.upload_file("path/to/file.apk")
print(f"Download URL: {result['download_page']}")
```

### Dependencies

Install dependencies with:

```bash
pip install -r scripts/requirements.txt
```

## test_upload_to_gofile.py

Comprehensive unit tests for the upload script.

### Running Tests

```bash
# Run all tests
python scripts/test_upload_to_gofile.py

# Or use unittest directly
python -m unittest scripts/test_upload_to_gofile.py
```

### Test Coverage

The test suite includes:

- Server retrieval tests (success, errors, edge cases)
- File upload tests (success, errors, timeouts)
- Network error handling
- Invalid response handling
- Main function integration tests
- Custom exception tests

**Total: 17 unit tests** covering all major code paths.

## CI/CD Integration

The upload script is integrated into the GitHub Actions workflow (`firebase-hosting-merge.yml`) and automatically:

1. Builds the Android APK after the web build
2. Sets up Python 3.11
3. Installs dependencies
4. Uploads the APK to Gofile.io
5. Outputs the download URL to GitHub Actions logs

### Required Secrets

Configure these in GitHub Settings → Secrets and variables → Actions:

- `GOFILE_TOKEN`: Your Gofile.io API token
- `GOFILE_ACCOUNT_ID`: Your Gofile.io account ID
