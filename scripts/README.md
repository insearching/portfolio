# Scripts

This directory contains utility scripts for the Portfolio project.

## upload_to_gofile.py

Python script for uploading files to Gofile.io and **extracting true direct download links** for CI/CD automation.

### Features

- **Direct link extraction** - Returns binary download URLs (not HTML landing pages)
- **Format validation** - Enforces `/download/` requirement for automation
- **HTTP accessibility testing** - Verifies links are downloadable
- Automatic server selection for optimal upload speed
- Support for authentication tokens and account IDs
- Folder organization support
- GitHub Actions integration with `$GITHUB_OUTPUT`
- Comprehensive error handling
- JSON output option
- CI/CD friendly `--direct-link-only` mode

### Usage

#### Command Line

```bash
# Basic upload (full output with direct link)
python scripts/upload_to_gofile.py path/to/file.apk --token YOUR_TOKEN

# CI/CD mode - output only the direct link
python scripts/upload_to_gofile.py path/to/file.apk \
  --token YOUR_TOKEN \
  --direct-link-only

# With GitHub Actions output
python scripts/upload_to_gofile.py path/to/file.apk \
  --token YOUR_TOKEN \
  --github-output

# With all options
python scripts/upload_to_gofile.py path/to/file.apk \
  --token YOUR_TOKEN \
  --account-id YOUR_ACCOUNT_ID \
  --folder-id FOLDER_ID \
  --output-json result.json \
  --github-output
```

**Output includes:**
- Landing Page: `https://gofile.io/d/{code}` (HTML - NOT for automation)
- **Direct Link: `https://store*.gofile.io/download/web/{fileId}/{filename}`** (for CI/CD)

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

## test/

Test suite directory containing all unit tests for Python scripts.

### Running Tests

```bash
# Run all tests from scripts directory
cd scripts
python -m unittest discover -s test -p "test_*.py" -v

# Run specific test file
python -m unittest test.test_upload_to_gofile -v

# Run from project root
python -m unittest discover -s scripts/test -p "test_*.py" -v
```

### Test Files

- **`test/test_upload_to_gofile.py`** - Unit tests for `upload_to_gofile.py`

### Test Coverage

The test suite includes **31 comprehensive unit tests** organized into 8 test classes:

#### **TestGofileUploader** (15 tests)
- Server retrieval (success, errors, edge cases)
- File upload (success, errors, timeouts)
- Network error handling
- Invalid response handling
- File path validation

#### **TestSetFolderPublic** (3 tests)
- Successful folder publication
- Failure handling
- Exception handling

#### **TestDirectLink** (4 tests)
- HTTP accessibility testing (200, 302, 404)
- Network error handling
- Redirect detection

#### **TestGetDirectLink** (3 tests)
- API-based extraction
- Manual URL construction fallback
- Multiple field name support (link, directLink)

#### **TestDirectLinkValidation** (2 tests)
- Valid format enforcement
- Invalid format detection

#### **TestUploadFileIntegration** (2 tests)
- Complete workflow testing
- Folder extraction from download page

#### **TestMainFunction** (1 test)
- CLI integration testing

#### **TestGofileUploadError** (1 test)
- Custom exception handling

**Total: 31 unit tests** with 100% pass rate ✅

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
