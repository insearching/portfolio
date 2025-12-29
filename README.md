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

- **[CRASHLYTICS_SETUP.md](CRASHLYTICS_SETUP.md)**: Firebase Crashlytics integration for error tracking
- **[VERSION_MANAGEMENT.md](VERSION_MANAGEMENT.md)**: Managing Flutter SDK and app versions
- **[scripts/README.md](scripts/README.md)**: Utility scripts for Firebase data management

## 📞 Contact

- **Email**: hrabas.serhii@gmail.com
- **GitHub**: [insearching](https://github.com/insearching)

---

**Built with ❤️ using Flutter and Clean Architecture**
