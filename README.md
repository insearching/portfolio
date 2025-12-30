# Portfolio

A professional portfolio web application built with Flutter, showcasing projects, skills, experience, and blog posts. Built with **Clean Architecture** and **BLoC pattern** for maintainability and scalability.

## 📑 Table of Contents

- [Getting Started](#-getting-started)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Key Technologies](#-key-technologies)
- [Features](#-features)
- [Theming](#-theming)
- [Firebase Setup](#-firebase-setup)
- [Testing](#-testing)
- [Building](#-building)
- [Additional Documentation](#-additional-documentation)
- [Contributing](#-contributing)
- [Contact](#-contact)

## 🚀 Getting Started

This is a Flutter web application that can also be built for desktop and mobile platforms.

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (comes with Flutter)
- Firebase account (for backend data)

### Installation

```bash
# Clone the repository
git clone <repository-url>

# Navigate to project directory
cd Portfolio

# Get dependencies
flutter pub get

# (Optional) Create .env file with Firebase credentials for local development
echo "FIREBASE_EMAIL=your-email@example.com" > .env
echo "FIREBASE_PASSWORD=your-password" >> .env

# Run the application with credentials
flutter run -d chrome --dart-define-from-file=.env  # For web
flutter run --dart-define-from-file=.env             # For desktop/mobile

# Or run without credentials (uses stub config)
flutter run -d chrome  # For web
flutter run            # For desktop/mobile
```

## 📐 Architecture

This project follows **Clean Architecture** with clear separation of concerns across three layers:

```
┌──────────────────────────────────────────────┐
│         Presentation Layer                   │
│  - UI (lib/main/ui/)                        │
│  - BLoC State Management                     │
│  - Responsive Layouts (Desktop/Tablet/Mobile)│
└──────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────┐
│         Domain Layer                         │
│  - Models (lib/main/domain/model/)          │
│  - Use Cases (lib/main/domain/usecases/)    │
│  - Repository Interfaces (domain/repositories/)│
└──────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────┐
│         Data Layer                           │
│  - Repository Implementations                │
│  - Data Sources (Remote/Local)               │
│  - Mappers (DTO ↔ Domain)                   │
│  - Local: SQLite (lib/main/data/local/)     │
│  - Remote: Firebase (lib/main/data/remote/) │
└──────────────────────────────────────────────┘
```

### Layer Responsibilities

#### 1. **Presentation Layer** (`lib/main/ui/`)

- **UI Components**: Flutter widgets organized by feature (blog, portfolio, resume, contact, etc.)
- **State Management**: BLoC pattern for predictable state handling
- **Responsive Design**: Separate layouts for desktop, tablet, and mobile
- **Navigation**: Go Router for declarative routing

**Key UI Modules:**
- `blog/` - Blog posts display
- `portfolio/` - Project showcase
- `resume/` - Work experience and skills
- `contact/` - Contact form and information
- `admin/` - Admin panel for content management
- `components/` - Reusable UI components

#### 2. **Domain Layer** (`lib/main/domain/`)

- **Models** (`model/`): Pure Dart entities representing business objects (Post, Project, Position, Skill, etc.)
- **Use Cases** (`usecases/`): Business logic operations (GetPosts, GetProjects, CreateProject, etc.)
- **Repository Interfaces** (`repositories/`): Abstract contracts for data access

**Key Models:**
- `Post` - Blog post entity
- `Project` - Portfolio project entity
- `Position` - Work experience entity
- `Skill` - Professional skill entity
- `Education` - Education/certification entity
- `PersonalInfo` - Personal information and contacts

#### 3. **Data Layer** (`lib/main/data/`)

- **Repository Implementations** (`repository/`): Concrete implementations of domain repositories
- **Data Sources**:
  - `remote/` - Firebase Realtime Database integration
  - `local/` - SQLite for offline caching
- **Mappers** (`mapper/`): Convert between DTOs and domain models
- **Utils**: Helper functions for data operations

**Key Repositories:**
- `PostRepositoryImpl` - Blog post data management
- `ProjectRepositoryImpl` - Portfolio project data management
- `PositionRepositoryImpl` - Work experience data management

## 🏗️ Project Structure

```
lib/
├── main.dart                          # Application entry point
├── firebase_options.dart              # Firebase configuration
├── core/                              # Core infrastructure
│   ├── config/                        # Configuration management
│   ├── logger/                        # Logging (Debug, Crashlytics, Release)
│   └── platform/                      # Platform-specific utilities
├── main/
│   ├── di/                            # Dependency Injection
│   │   └── service_locator.dart      # GetIt setup
│   ├── domain/                        # Domain Layer (Business Logic)
│   │   ├── model/                     # Domain entities
│   │   ├── usecases/                  # Business use cases
│   │   └── repositories/              # Repository interfaces
│   ├── data/                          # Data Layer
│   │   ├── repository/                # Repository implementations
│   │   ├── remote/                    # Firebase data sources
│   │   ├── local/                     # SQLite data sources
│   │   ├── mapper/                    # DTO ↔ Domain mappers
│   │   └── utils/                     # Data utilities
│   ├── ui/                            # Presentation Layer
│   │   ├── components/                # Reusable UI components
│   │   ├── responsive/                # Responsive layouts
│   │   ├── blog/                      # Blog feature
│   │   ├── portfolio/                 # Portfolio feature
│   │   ├── resume/                    # Resume/CV feature
│   │   ├── contact/                   # Contact feature
│   │   ├── admin/                     # Admin panel
│   │   └── menu/                      # Navigation menu
│   └── mixins/                        # Reusable mixins
└── utils/                             # Global utilities
    ├── colors.dart                    # Color palette
    ├── theme.dart                     # Theme definitions
    ├── theme_provider.dart            # Theme state management
    ├── env_config.dart                # Environment configuration
    └── ...
```

## 🔧 Key Technologies

### Core Framework
- **Flutter**: Cross-platform UI framework (web, mobile, desktop)
- **Dart**: Programming language

### Architecture & Patterns
- **Clean Architecture**: Separation of concerns across layers
- **BLoC Pattern**: Predictable state management with `flutter_bloc`
- **Repository Pattern**: Abstract data access
- **Use Case Pattern**: Encapsulated business logic
- **Dependency Injection**: `GetIt` for service location

### Backend & Data
- **Firebase**:
  - Realtime Database (remote data storage)
  - Authentication (user management)
  - Crashlytics (error tracking)
- **SQLite** (`sqflite`): Local data caching
- **SharedPreferences**: Local settings storage

### UI & Navigation
- **Go Router**: Declarative routing
- **Provider**: Theme management
- **Responsive Design**: Adaptive layouts for all screen sizes
- **Animated Text Kit**: Text animations
- **Cached Network Image**: Image caching and optimization

### Development & Testing
- **BLoC Test**: Testing BLoC state management
- **Flutter Test**: Unit and widget testing
- **Flutter Lints**: Code quality and style enforcement
- **Firebase Crashlytics**: Production error monitoring

## 🏛️ Clean Architecture Implementation

### Dependency Flow

The application strictly follows the **Dependency Rule**: dependencies only point inward (toward the domain layer).

```
Presentation → Domain ← Data
     ↓           ↑         ↑
   BLoCs    Use Cases   Repositories
     ↓           ↑         ↑
    UI       Entities  Data Sources
```

### Adding a New Feature

Follow these steps to add a new feature following Clean Architecture:

#### 1. Define Domain Entity

Create a model in `lib/main/domain/model/`:

```dart
class User {
  final String id;
  final String name;
  final String email;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
  });
}
```

#### 2. Create Repository Interface

Define the contract in `lib/main/domain/repositories/`:

```dart
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<void> saveUser(User user);
}
```

#### 3. Create Use Cases

Implement business logic in `lib/main/domain/usecases/`:

```dart
class GetUserUseCase {
  final UserRepository repository;
  
  GetUserUseCase(this.repository);
  
  Future<User> call(String id) async {
    return await repository.getUser(id);
  }
}
```

#### 4. Implement Repository

Create implementation in `lib/main/data/repository/`:

```dart
class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  
  UserRepositoryImpl(this.remoteDataSource, this.localDataSource);
  
  @override
  Future<User> getUser(String id) async {
    try {
      // Try remote first
      final dto = await remoteDataSource.getUser(id);
      final user = UserMapper.fromDto(dto);
      // Cache locally
      await localDataSource.saveUser(user);
      return user;
    } catch (e) {
      // Fallback to local
      return await localDataSource.getUser(id);
    }
  }
}
```

#### 5. Register Dependencies

Add to `lib/main/di/service_locator.dart`:

```dart
// Data sources
locator.registerLazySingleton<UserRemoteDataSource>(
  () => UserRemoteDataSourceImpl(database: locator()),
);

// Repositories
locator.registerLazySingleton<UserRepository>(
  () => UserRepositoryImpl(locator(), locator()),
);

// Use cases
locator.registerLazySingleton(() => GetUserUseCase(locator()));
```

#### 6. Create BLoC

Implement state management in `lib/main/ui/<feature>/bloc/`:

```dart
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUseCase getUserUseCase;
  
  UserBloc(this.getUserUseCase) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
  }
  
  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await getUserUseCase(event.id);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
```

#### 7. Build UI

Create widgets in `lib/main/ui/<feature>/`:

```dart
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<UserBloc>()..add(LoadUser('123')),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) return CircularProgressIndicator();
          if (state is UserLoaded) return UserWidget(state.user);
          if (state is UserError) return ErrorWidget(state.message);
          return Container();
        },
      ),
    );
  }
}
```

## 🎨 Features

### User Features
- **Responsive Design**: Adaptive layouts for mobile, tablet, and desktop screens
- **Light & Dark Themes**: System-aware theme with manual toggle option
- **Project Portfolio**: Showcase of projects with images, descriptions, and links
- **Work Experience**: Timeline of professional positions and roles
- **Skills Showcase**: Visual representation of technical skills and competencies
- **Blog Integration**: Dynamic blog posts from Firebase
- **Certifications**: Education and professional certifications
- **Contact Information**: Social media links and contact details
- **Smooth Animations**: Modern UI with fluid transitions

### Admin Features
- **Content Management**: Admin panel for managing portfolio content
- **Project CRUD**: Create, read, update, delete projects
- **Real-time Updates**: Changes sync immediately via Firebase
- **Authentication**: Secure Firebase authentication for admin access

### Technical Features
- **Offline Support**: SQLite caching for offline functionality
- **Error Tracking**: Firebase Crashlytics for production monitoring
- **Optimized Performance**: Image caching and lazy loading
- **SEO-Friendly**: Proper meta tags and routing for web
- **Progressive Web App**: Installable PWA with splash screens

## 🎨 Theming

The application supports **light and dark themes** with automatic system detection.

### Key Features
- **System Theme Detection**: Automatically follows device theme preference
- **Manual Toggle**: Theme switcher in the navigation panel
- **Responsive**: Optimized font sizes for desktop and mobile
- **Persistent**: Theme preference saved using SharedPreferences

### Theme Colors

**Dark Theme** (Default):
- Background: `#212428`
- Text: `#C4CFDE`
- Accent: `#F9004D`

**Light Theme**:
- Background: `#DEDBD7`
- Text: `#3C3021`
- Accent: `#F9004D`

### Usage in Widgets

```dart
// Get current theme
final isDark = Theme.of(context).brightness == Brightness.dark;

// Use theme-aware colors
Container(
  color: isDark ? UIColors.backgroundColor : UIColors.lightBackgroundColor,
)

// Or use theme properties directly
Text(
  'Hello',
  style: Theme.of(context).textTheme.bodyLarge,
)
```

### Customization

Edit theme definitions in `lib/utils/theme.dart`:
- `desktopTheme` / `phoneTheme` - Dark themes
- `desktopLightTheme` / `phoneLightTheme` - Light themes

Add custom colors in `lib/utils/colors.dart`.

## 🔥 Firebase Setup

### Initial Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project or use an existing one

2. **Enable Services**
   - **Realtime Database**: For storing portfolio data
   - **Authentication**: For admin panel access
   - **Crashlytics**: For error tracking (optional but recommended)

3. **Configure Flutter App**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your project
   flutterfire configure
   ```
   This generates `firebase_options.dart` with your Firebase configuration.

4. **Set Up Authentication**
   - Go to Firebase Console → Authentication
   - Enable Email/Password sign-in method
   - Create an admin user for accessing the admin panel

### Database Structure

Set up your Realtime Database with this structure:

```json
{
  "posts": {
    "post_id_1": {
      "id": "post_id_1",
      "title": "Blog Post Title",
      "description": "Post description",
      "imageUrl": "https://...",
      "link": "https://...",
      "createdAt": 1234567890
    }
  },
  "projects": {
    "project_id_1": {
      "id": "project_id_1",
      "title": "Project Name",
      "description": "Project description",
      "imageUrl": "assets/projects/project.jpg",
      "githubUrl": "https://github.com/...",
      "technologies": ["Flutter", "Firebase"],
      "order": 0
    }
  },
  "positions": {
    "position_id_1": {
      "id": "position_id_1",
      "company": "Company Name",
      "position": "Job Title",
      "description": "Job description",
      "startDate": "2020-01",
      "endDate": "2023-12",
      "icon": "assets/icons/company.png"
    }
  }
}
```

### Environment Configuration

For local development with Firebase Authentication:

1. Create a `.env` file in the project root:
   ```env
   FIREBASE_EMAIL=your-admin@example.com
   FIREBASE_PASSWORD=your-secure-password
   ```

2. Run with environment variables:
   ```bash
   flutter run --dart-define-from-file=.env
   ```

**Security Note**: Never commit `.env` files to version control. The file is already in `.gitignore`.

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## 📦 Building

### Web
```bash
# Development build
flutter run -d chrome

# Production build
flutter build web --release

# With Firebase credentials
flutter build web --release --dart-define-from-file=.env
```

### Desktop
```bash
# macOS
flutter build macos --release

# Windows
flutter build windows --release

# Linux
flutter build linux --release
```

### Mobile
```bash
# Android
flutter build apk --release         # APK for testing
flutter build appbundle --release   # App Bundle for Play Store

# iOS
flutter build ios --release
```

### Build with Environment Variables
```bash
# Build with .env file
flutter build web --dart-define-from-file=.env

# Or pass individual variables
flutter build web --dart-define=FIREBASE_EMAIL=admin@example.com
```

## 🚀 CI TestFlight Distribution

This project includes automated CI/CD pipeline for distributing iOS builds to TestFlight using GitHub Actions and Fastlane.

### Overview

The CI pipeline automatically:
1. Builds and signs the iOS app on push to `develop` branch
2. Uploads the build to TestFlight via App Store Connect API
3. Supports manual workflow dispatch with custom release notes
4. Provides a stable public TestFlight link for long-term distribution

### Required GitHub Secrets

You must configure the following secrets in your GitHub repository (`Settings` → `Secrets and variables` → `Actions` → `New repository secret`):

#### App Store Connect API Key

| Secret Name | Description | How to Obtain |
|------------|-------------|---------------|
| `APP_STORE_CONNECT_KEY_ID` | API Key ID (e.g., `AB12CD34EF`) | App Store Connect → Users and Access → Keys |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID (UUID format) | App Store Connect → Users and Access → Keys (top right) |
| `APP_STORE_CONNECT_KEY_P8` | Private key content (`.p8` file) | Download when creating the key (only shown once!) |

**Creating App Store Connect API Key:**

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Navigate to **Users and Access** → **Keys** tab (under Integrations)
3. Click **Generate API Key** or **+** button
4. Enter a name (e.g., "GitHub Actions CI")
5. Select **Access**: Choose **App Manager** or **Developer** role
6. Click **Generate**
7. **Important**: Download the `.p8` file immediately - you cannot download it again!
8. Copy the **Key ID** and **Issuer ID** from the page

**Adding the P8 key to GitHub:**
```bash
# On macOS/Linux, copy the entire content of the .p8 file:
cat AuthKey_AB12CD34EF.p8 | pbcopy  # macOS
cat AuthKey_AB12CD34EF.p8           # Linux (copy manually)

# Then paste it as the APP_STORE_CONNECT_KEY_P8 secret value in GitHub
```

#### Code Signing Certificates

| Secret Name | Description | How to Obtain |
|------------|-------------|---------------|
| `IOS_DISTRIBUTION_CERT_BASE64` | Base64-encoded distribution certificate (`.p12`) | Export from Xcode or Keychain Access |
| `IOS_DISTRIBUTION_CERT_PASSWORD` | Password for the `.p12` certificate | Set when exporting the certificate |

**Exporting Distribution Certificate:**

1. **Option A: From Xcode**
   - Open Xcode → Preferences → Accounts
   - Select your Apple ID → Select Team → Manage Certificates
   - Right-click **Apple Distribution** certificate → Export
   - Save as `.p12` and set a password
   - Convert to base64:
     ```bash
     base64 -i distribution_certificate.p12 | pbcopy  # macOS
     base64 -w 0 distribution_certificate.p12         # Linux
     ```

2. **Option B: From Keychain Access** (macOS)
   - Open **Keychain Access** app
   - Select **login** keychain → **My Certificates**
   - Find your **Apple Distribution** certificate
   - Right-click → Export "Apple Distribution: ..."
   - Save as `.p12` format with a password
   - Convert to base64:
     ```bash
     base64 -i YourCertificate.p12 | pbcopy
     ```

#### Provisioning Profile

| Secret Name | Description | How to Obtain |
|------------|-------------|---------------|
| `IOS_PROVISION_PROFILE_BASE64` | Base64-encoded provisioning profile (`.mobileprovision`) | Apple Developer Portal |

**Creating and Exporting Provisioning Profile:**

1. Go to [Apple Developer Portal](https://developer.apple.com/account/resources/profiles/list)
2. Click **+** to create a new profile
3. Select **App Store** distribution type
4. Select your **App ID** (`com.insearching.portfolio`)
5. Select your **Distribution Certificate**
6. Enter a name (e.g., "Portfolio AppStore")
7. Click **Generate** and download the `.mobileprovision` file
8. Convert to base64:
   ```bash
   base64 -i Portfolio_AppStore.mobileprovision | pbcopy  # macOS
   base64 -w 0 Portfolio_AppStore.mobileprovision         # Linux
   ```

#### Optional Secrets

| Secret Name | Description | Default |
|------------|-------------|---------|
| `KEYCHAIN_PASSWORD` | Password for temporary keychain in CI | Auto-generated UUID |

### Setting Up TestFlight Public Link

After your first successful build is uploaded and processed:

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Select your app → **TestFlight** tab
3. In the left sidebar, under **External Testing**, click on a group or create a new one
4. Click **Add Build** and select your uploaded build
5. Fill in the **Test Details** (What to Test)
6. Click **Submit for Review** (first time only - required for external testing)
7. Once approved, click **Public Link** in the group
8. Click **Enable Public Link**
9. Choose **Open to Anyone** or configure filters
10. Copy the public link (format: `https://testflight.apple.com/join/XXXXXXXX`)

**Important Notes:**
- The public link remains stable across builds
- Users can install new builds automatically through TestFlight
- Each build expires after 90 days, but the link doesn't
- You must keep uploading new builds to maintain availability
- External testing requires Apple's review for the first build only

### Running the Workflow

#### Automatic Trigger

The workflow automatically runs when you push to `develop` branch and changes include:
- iOS code (`ios/**`)
- Flutter code (`lib/**`)
- Dependencies (`pubspec.yaml`, `pubspec.lock`)
- Workflow or Fastlane files

```bash
git checkout develop
git add .
git commit -m "feat: Add new feature for iOS"
git push origin develop
```

#### Manual Trigger

You can also trigger the workflow manually with custom parameters:

1. Go to your GitHub repository
2. Click **Actions** tab
3. Select **Deploy to Firebase Hosting on merge** workflow
4. Click **Run workflow** button
5. (Optional) Enter custom **Release notes**
6. (Optional) Override the **Scheme** name (default: `Runner`)
7. Click **Run workflow**

**Via GitHub CLI:**
```bash
# With default changelog
gh workflow run firebase-hosting-merge.yml

# With custom changelog
gh workflow run firebase-hosting-merge.yml \
  -f changelog="Fixed critical bug in authentication flow"

# With custom scheme
gh workflow run firebase-hosting-merge.yml \
  -f scheme="Runner" \
  -f changelog="Performance improvements and bug fixes"
```

### Monitoring Builds

**In GitHub Actions:**
- Go to **Actions** tab in your repository
- Click on the latest **Deploy to Firebase Hosting on merge** workflow run
- Monitor real-time logs for each step
- Download build artifacts (IPA, dSYM) from the workflow run

**In App Store Connect:**
1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Select your app → **TestFlight** tab
3. Check **iOS** builds section
4. Wait for Apple to process the build (typically 5-15 minutes)
5. Once status shows ✅, the build is ready for testing

### Troubleshooting

#### Build fails with "No signing certificate found"

**Solution:**
- Verify `IOS_DISTRIBUTION_CERT_BASE64` is correctly base64-encoded
- Ensure `IOS_DISTRIBUTION_CERT_PASSWORD` matches the certificate password
- Check that the certificate is a **Distribution** certificate (not Development)
- Verify the certificate hasn't expired in Apple Developer Portal

#### Build fails with "No matching provisioning profile found"

**Solution:**
- Ensure `IOS_PROVISION_PROFILE_BASE64` is correctly base64-encoded
- Verify the provisioning profile:
  - Type is **App Store** (not Ad Hoc or Development)
  - App ID matches `com.insearching.portfolio`
  - Certificate matches your distribution certificate
  - Profile hasn't expired
- Re-download and re-encode the provisioning profile if needed

#### Upload fails with "Invalid API Key"

**Solution:**
- Verify all three API key secrets are correct:
  - `APP_STORE_CONNECT_KEY_ID`
  - `APP_STORE_CONNECT_ISSUER_ID`
  - `APP_STORE_CONNECT_KEY_P8` (must be complete `.p8` file content)
- Ensure the API key has **App Manager** or **Developer** access
- Check the API key hasn't been revoked in App Store Connect

#### Build succeeds but doesn't appear in TestFlight

**Common reasons:**
- Apple is still processing the build (wait 5-15 minutes)
- Build has the same version/build number as existing build
- Build was uploaded but needs compliance information
- Check email for messages from Apple about the build

**Solution:**
- Increment version or build number in `pubspec.yaml`:
  ```yaml
  version: 1.0.1+2  # Increment build number (+2)
  ```
- Check App Store Connect for any required compliance responses
- Verify App Store Connect API key has proper permissions

#### "Missing compliance" or export restrictions

If Apple asks about encryption:
- Most apps need to add `ITSAppUsesNonExemptEncryption = NO` to `Info.plist`
- Or respond to the compliance questions in App Store Connect

### Local Testing

Test the Fastlane setup locally before pushing to CI:

```bash
# Install dependencies
bundle install

# Set environment variables (create a .env.local file)
export APP_STORE_CONNECT_KEY_ID="your_key_id"
export APP_STORE_CONNECT_ISSUER_ID="your_issuer_id"
export APP_STORE_CONNECT_KEY_P8="$(cat path/to/AuthKey_XXXXXX.p8)"
export IOS_WORKSPACE="$(pwd)/ios/Runner.xcworkspace"
export IOS_SCHEME="Runner"
export CHANGELOG="Test build from local machine"

# Run build only (no upload)
bundle exec fastlane ios build_only

# Run full beta lane (build + upload)
bundle exec fastlane ios beta
```

### Security Best Practices

✅ **Do:**
- Store all sensitive data in GitHub Secrets
- Use App Store Connect API key (avoids 2FA issues)
- Regularly rotate certificates and provisioning profiles
- Use strong passwords for certificate `.p12` files
- Enable branch protection on `develop` branch

❌ **Don't:**
- Commit certificates, provisioning profiles, or API keys to the repository
- Share API keys or certificates publicly
- Use personal Apple ID credentials in CI
- Store secrets in code or configuration files

### Workflow Features

- ✅ **Automatic code signing** with temporary keychain
- ✅ **App Store Connect API** authentication (no 2FA required)
- ✅ **Build artifacts** uploaded to GitHub (IPA, dSYM)
- ✅ **Automatic cleanup** of sensitive files
- ✅ **Detailed logging** and error messages
- ✅ **Job summaries** with next steps
- ✅ **Configurable** via workflow inputs
- ✅ **Caching** for Ruby gems and Flutter SDK

### Cost Considerations

- GitHub Actions provides **2,000 free macOS minutes/month** for private repositories
- Each build typically takes **15-25 minutes**
- Monitor usage in **Settings** → **Billing** → **Actions usage**
- Consider triggering builds only on significant changes

## 🤝 Contributing

When contributing to this project:

1. **Follow Clean Architecture**: Maintain clear separation between layers
2. **Use BLoC Pattern**: All state management must use BLoC
3. **Write Tests**: Add unit tests for use cases and BLoCs
4. **Follow Style Guide**: Use Flutter/Dart conventions and linting rules
5. **Document Changes**: Update relevant documentation
6. **Add Type Safety**: Use strong typing and avoid `dynamic` where possible

### Code Style
```bash
# Run linter
flutter analyze

# Format code
flutter format .

# Run tests
flutter test
```

## 📚 Additional Documentation

This project includes detailed documentation for specific topics:

### Core Documentation
- **[CRASHLYTICS_SETUP.md](CRASHLYTICS_SETUP.md)**: Firebase Crashlytics integration for error tracking
- **[VERSION_MANAGEMENT.md](VERSION_MANAGEMENT.md)**: Managing Flutter SDK and app versions
- **[scripts/README.md](scripts/README.md)**: Utility scripts for Firebase data management

### iOS TestFlight CI/CD
- **[QUICKSTART_TESTFLIGHT.md](QUICKSTART_TESTFLIGHT.md)**: ⚡ Quick start guide (30 minutes to first build!)
- **[IOS_TESTFLIGHT_SETUP.md](IOS_TESTFLIGHT_SETUP.md)**: Complete implementation details and reference
- **[.github/SECRETS_CHECKLIST.md](.github/SECRETS_CHECKLIST.md)**: GitHub secrets configuration checklist
- **[fastlane/README_SETUP.md](fastlane/README_SETUP.md)**: Local Fastlane setup and testing guide

## 📞 Contact

- **Email**: hrabas.serhii@gmail.com
- **GitHub**: [insearching](https://github.com/insearching)

---

**Built with ❤️ using Flutter and Clean Architecture**
