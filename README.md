# Portfolio

A professional portfolio web application built with Flutter, showcasing projects, skills,
experience, and blog posts.

## 📑 Table of Contents

- [Getting Started](#-getting-started)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Key Technologies](#-key-technologies)
- [Features](#-features)
- [Light & Dark Theme Support](#-light--dark-theme-support)
- [Firebase Setup](#-firebase-setup)
- [Testing](#-testing)
- [Building](#-building)
- [Contributing](#-contributing)
- [Contact](#-contact)
- [Recent Changes](#-recent-changes)

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

This project follows a clean, layered architecture pattern with clear separation of concerns:

```
┌─────────────────────────────────────────┐
│         UI / BLoC Layer                 │
│  (Presentation & State Management)      │
│  - Widgets                              │
│  - BLoC (Business Logic Components)     │
│  - State Management                     │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│       Repository Layer                  │
│  - BlogRepository                       │
│  - PositionRepository                   │
│  - PortfolioRepository                  │
│  (Business Logic & Data Aggregation)    │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│         DAO Layer                       │
│  - PostDao → FirebasePostDao            │
│  - PositionDao → FirebasePositionDao    │
│  (Direct Database Access)               │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│       Database (Firebase)               │
│  - Realtime Database                    │
└─────────────────────────────────────────┘
```

### Layer Responsibilities

#### 1. **UI/BLoC Layer** (`lib/main/ui/`, `lib/main/bloc/`)

- Presentation logic and UI components
- State management using BLoC pattern
- User interactions and events
- Responsive layouts (mobile, tablet, desktop)

#### 2. **Repository Layer** (`lib/main/data/repository/`)

- Business logic implementation
- Data aggregation from multiple sources
- Business-level error handling
- Caching strategies
- Single source of truth for the application

**Key Repositories:**

- `PortfolioRepository`: Central repository aggregating all portfolio data
- `BlogRepository`: Manages blog posts
- `PositionRepository`: Manages job positions

#### 3. **DAO Layer** (`lib/main/data/dao/`)

- Direct database operations (CRUD)
- Data serialization/deserialization
- Database-specific error handling
- Raw data transformation

**Key DAOs:**

- `PostDao` / `FirebasePostDao`: Database operations for blog posts
- `PositionDao` / `FirebasePositionDao`: Database operations for positions

#### 4. **Data Models** (`lib/main/data/`)

- Plain Dart objects representing domain entities
- Immutable data structures
- Type-safe data representation

**Models:**

- `Post`: Blog post data
- `Position`: Job position data
- `Project`: Portfolio project data
- `Skill`: Professional skill data
- `Education`: Education/certification data
- `PersonalInfo`: Personal information and contacts

## 🏗️ Project Structure

```
lib/
├── main.dart                      # Application entry point
├── firebase_options.dart          # Firebase configuration
├── main/
│   ├── service_locator.dart      # Dependency injection setup
│   ├── ui/                       # UI components
│   │   ├── components/           # Reusable UI components
│   │   ├── responsive/           # Responsive layouts
│   │   ├── blog/                 # Blog-related UI
│   │   ├── personal_info/        # Personal info UI
│   │   └── ...
│   ├── bloc/                     # BLoC state management
│   ├── data/
│   │   ├── dao/                  # Data Access Objects
│   │   │   ├── post_dao.dart
│   │   │   └── position_dao.dart
│   │   ├── repository/           # Repositories
│   │   │   ├── blog_repository.dart
│   │   │   ├── position_repository.dart
│   │   │   └── portfolio_repository.dart
│   │   ├── *.dart                # Data models
│   │   └── repository.dart       # Static local data
│   └── mixins/                   # Reusable mixins
└── utils/                        # Utility functions and constants
    ├── colors.dart
    ├── theme.dart
    └── ...
```

## 🔧 Key Technologies

- **Flutter**: Cross-platform UI framework
- **Firebase Realtime Database**: Backend data storage
- **BLoC Pattern**: State management
- **GetIt**: Dependency injection
- **url_launcher**: External link handling

## 📝 Data Access Object (DAO) Pattern

### Why DAO?

The DAO pattern provides several benefits:

1. **Separation of Concerns**: Database logic is isolated from business logic
2. **Testability**: Easy to mock DAOs for testing repositories
3. **Flexibility**: Easy to swap database implementations (e.g., Firebase → SQLite)
4. **Maintainability**: Changes to database structure only affect DAO layer
5. **Single Responsibility**: Each layer has a clear, single purpose

### Usage Example

```dart
// In service_locator.dart - Register dependencies
locator.registerLazySingleton<PostDao>(
  () => FirebasePostDao(databaseReference: locator())
);

locator.registerLazySingleton<BlogRepository>(
  () => BlogRepository(postDao: locator())
);

// In repository - Use DAO
class BlogRepository {
  final PostDao postDao;
  
  Future<List<Post>> readPosts() async {
    try {
      return await postDao.readPosts();
    } catch (e) {
      throw Exception('Failed to read posts: $e');
    }
  }
}
```

### Adding a New DAO

1. **Create abstract interface** defining operations:

```dart
abstract class UserDao {
  Future<User> getUser(String id);
  Future<void> saveUser(User user);
}
```

2. **Implement concrete class**:

```dart
class FirebaseUserDao implements UserDao {
  final DatabaseReference databaseReference;
  
  FirebaseUserDao({required this.databaseReference});
  
  @override
  Future<User> getUser(String id) async {
    final snapshot = await databaseReference.child('users/$id').once();
    // Parse and return user
  }
  
  @override
  Future<void> saveUser(User user) async {
    await databaseReference.child('users/${user.id}').set({
      'name': user.name,
      'email': user.email,
    });
  }
}
```

3. **Register in service_locator.dart**:

```dart
locator.registerLazySingleton<UserDao>(
  () => FirebaseUserDao(databaseReference: locator())
);
```

4. **Inject into repository**:

```dart
class UserRepository {
  final UserDao userDao;
  
  UserRepository({required this.userDao});
  
  Future<User> getUser(String id) async {
    try {
      return await userDao.getUser(id);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }
}
```

## 🎨 Features

- **Responsive Design**: Optimized layouts for mobile, tablet, and desktop
- **Light & Dark Themes**: Full theme support with seamless switching
- **Personal Information**: Contact details and social media links
- **Skills Showcase**: Visual representation of technical and soft skills
- **Project Portfolio**: Detailed project descriptions with images and links
- **Work Experience**: Dynamic position/role information from Firebase
- **Blog**: Integrated blog posts fetched from Firebase
- **Education**: Certifications and educational background
- **Modern UI**: Neumorphic design with smooth animations

## 🔥 Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Firebase Realtime Database
3. Configure Firebase for your Flutter app (see `firebase_options.dart`)
4. Set up database structure:

```json
{
  "posts": [
    {
      "title": "Post Title",
      "description": "Post description",
      "imageLink": "https://...",
      "link": "https://..."
    }
  ],
  "positions": [
    {
      "title": "Company Name",
      "position": "Job Title",
      "description": "Job description",
      "icon": "assets/img/icon.png"
    }
  ]
}
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## 📦 Building

```bash
# Build for web
flutter build web

# Build for desktop
flutter build macos  # or windows/linux

# Build for mobile
flutter build apk    # Android
flutter build ios    # iOS
```

## 🤝 Contributing

When making changes to the architecture or adding new features, please:

1. Follow the established layered architecture pattern
2. Use DAOs for all direct database access
3. Keep repositories focused on business logic
4. Update this README with any architectural changes
5. Write tests for new features
6. Follow Dart/Flutter style guidelines

## 📄 License

This project is a personal portfolio application.

## 📞 Contact

- **Email**: hrabas.serhii@gmail.com
- **GitHub**: [Your GitHub Profile]
- **LinkedIn**: [Your LinkedIn Profile]

---

## 🌓 Light & Dark Theme Support

Your portfolio now supports **both light and dark themes** with automatic system theme detection!

> **✨ Smart Theming:** The app automatically follows your system's theme preference (light/dark).
> The theme toggle button only appears if system theme detection is unavailable, allowing manual
> override.

### Quick Start

1. **Automatic**: The app follows your device's system theme by default
2. **Manual Override**: If system theme is not available, use the theme toggle button 🌙/☀️ in the
   left panel
3. **Inverted Colors**: Light theme uses inverted colors from dark theme for perfect contrast

### Theme Features

#### Available Themes

**Dark Theme**:

- Background: Dark grey (#212428)
- Text: Light grey-blue (#C4CFDE)
- Accent: Pink (#F9004D)
- Optimized for reduced eye strain in low-light environments

**Light Theme** (Inverted Colors):

- Background: Light beige (#DEDBD7) - Inverted from dark background
- Text: Dark brown (#3C3021) - Inverted from light text
- Accent: Pink (#F9004D) - Same as dark theme
- All colors are mathematically inverted from the dark theme for perfect contrast

Both themes are fully responsive with optimized font sizes:

- **Desktop**: Larger fonts (48px/32px/24px/18px)
- **Mobile**: Smaller fonts (36px/24px/18px/14px)

### For Developers

#### System Theme Detection

The app uses `ThemeMode.system` by default, automatically following the device's theme preference.
The theme toggle button only appears when system theme is not available.

#### Using the Theme Toggle Button

The toggle button automatically hides when in system mode:

```dart
import 'package:portfolio/main/ui/components/theme_toggle_button.dart';

// Animated version (auto-hides in system mode)
const AnimatedThemeToggleButton
(
size: 24.0)

// Other variants also support auto-hide
const ThemeToggleButton()
const ThemeToggleSwitch()
```

#### Checking Current Theme

```dart
import 'package:portfolio/utils/theme_provider.dart';
import 'package:provider/provider.dart';

// Method 1: Using Provider
final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

// Method 2: Using Theme brightness
final isDark = Theme.of(context).brightness == Brightness.dark;

// Method 3: Using Consumer (reactive)
Consumer<ThemeProvider>(
  builder: (context, themeProvider, child) {
    return Text(themeProvider.isDarkMode ? 'Dark' : 'Light');
  },
);
```

#### Making Widgets Theme-Aware

**Option 1: Use conditional colors**

```dart
final isDark = Theme.of(context).brightness == Brightness.dark;
final bgColor = isDark ? UIColors.backgroundColor : UIColors.lightBackgroundColor;
```

**Option 2: Use theme colors directly**

```dart
color: Theme.of(context).textTheme.bodyMedium?.color,
```

**Option 3: Use ThemeProvider with Consumer**

```dart
Consumer<ThemeProvider>(
  builder: (context, themeProvider, child) {
    return Container(
      color: themeProvider.isDarkMode 
          ? UIColors.backgroundColor 
          : UIColors.lightBackgroundColor,
    );
  },
);
```

#### Available Theme Colors

**Dark Theme Colors:**

```dart
UIColors.backgroundColor          // #212428 - Main background
UIColors.backgroundColorDark      // #1D2023 - Darker sections
UIColors.backgroundColorLight     // #1F2328 - Lighter sections
UIColors.defaultTextColor         // #C4CFDE - Default text
UIColors.lightGrey                // #F5F6F7 - Secondary text
UIColors.darkGrey                 // #383B41 - Borders/dividers
UIColors.hoverColor               // #9FA8DA - Hover states
```

**Light Theme Colors (Inverted):**

```dart
UIColors.lightBackgroundColor      // #DEDBD7 - Inverted from #212428
UIColors.lightBackgroundColorDark  // #E2DFDC - Inverted from #1D2023
UIColors.lightBackgroundColorLight // #E0DCD7 - Inverted from #1F2328
UIColors.lightTextColor            // #3C3021 - Inverted and adjusted for readability
UIColors.lightTextColorSecondary   // #0A0908 - Inverted from #F5F6F7
UIColors.lightBorderColor          // #C7C4BE - Inverted from #383B41
UIColors.lightHoverColor           // #605723 - Inverted from #9FA8DA
UIColors.lightShadowColor          // rgba(255,255,255,0.15) - Inverted shadow
```

**Common Colors (Both Themes):**

```dart
UIColors.accent      // #F9004D - Primary accent (pink)
UIColors.logoBlue    // #245F97 - Brand blue
UIColors.goldTips    // #E1B714 - Gold accent
UIColors.white       // #FFFFFF
UIColors.black       // #000000
```

### Customization

#### Change Default Theme

Edit `lib/utils/theme_provider.dart`:

```dart
ThemeMode _themeMode = ThemeMode.light; // or ThemeMode.dark
```

#### Add Custom Theme Colors

1. Add to `lib/utils/colors.dart`:

```dart
static const Color myCustomColor = Color(0xFFXXXXXX);
```

2. Use in your widgets:

```dart
Container(color: UIColors.myCustomColor)
```

#### Create Your Own Toggle Button

```dart
import 'package:portfolio/utils/theme_provider.dart';
import 'package:provider/provider.dart';

ElevatedButton(
  onPressed: () {
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
  },
  child: Text('Toggle Theme'),
)
```

### Theme Implementation Details

#### Architecture

**State Management:**

- `lib/utils/theme_provider.dart` - `ThemeProvider` class using `ChangeNotifier`
- Methods: `toggleTheme()`, `setDarkMode()`, `setLightMode()`, `setThemeMode()`

**Theme Definitions:**

- `lib/utils/theme.dart` - Four theme variants:
    - `desktopTheme` - Dark theme for desktop
    - `phoneTheme` - Dark theme for mobile
    - `desktopLightTheme` - Light theme for desktop
    - `phoneLightTheme` - Light theme for mobile

**UI Components:**

- `lib/main/ui/components/theme_toggle_button.dart` - Three toggle button variants
- Integrated in `lib/main/ui/left_panel.dart` at the top

#### Files Modified

- ✅ `lib/utils/colors.dart` - Added light theme colors
- ✅ `lib/utils/theme.dart` - Added light theme definitions
- ✅ `lib/main.dart` - Integrated ThemeProvider
- ✅ `lib/main/ui/left_panel.dart` - Added theme toggle button
- ✅ All scaffolds (desktop/mobile/tablet) - Made theme-aware

#### Files Created

- ✅ `lib/utils/theme_provider.dart` - Theme state management
- ✅ `lib/main/ui/components/theme_toggle_button.dart` - Toggle UI components

### Advanced Usage

#### Persist Theme Preference

To save theme preference across app restarts, add `shared_preferences`:

```dart
// In ThemeProvider
Future<void> toggleTheme() async {
  _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  notifyListeners();
  
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
}

// Load on startup
Future<void> loadTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDarkMode') ?? true;
  _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
  notifyListeners();
}
```

#### Follow System Theme

Use `ThemeMode.system` to automatically match the device's theme:

```dart
ThemeMode _themeMode = ThemeMode.system;
```

#### Add More Theme Variants

To add a high-contrast theme:

1. Define colors in `lib/utils/colors.dart`
2. Create theme in `lib/utils/theme.dart`:

```dart
static ThemeData highContrastTheme = ThemeData(
  brightness: Brightness.light,
  // ... custom high-contrast configuration
);
```

3. Update `ThemeProvider` to support the new mode

### Best Practices

1. ✅ **Always use theme colors** instead of hardcoded colors
2. ✅ **Test both themes** when adding new UI components
3. ✅ **Use semantic colors** (e.g., `Theme.of(context).textTheme.bodyMedium?.color`)
4. ✅ **Avoid direct color references** like `Color(0xFF...)` in widgets
5. ✅ **Use ThemeProvider** for complex theme-dependent logic

### Troubleshooting

**Theme not applying after toggle:**

- Ensure `ThemeProvider` is provided at the root level in `main.dart`
- Check that `MaterialApp` receives both `theme` and `darkTheme`
- Verify `themeMode` is being observed with `Consumer<ThemeProvider>`

**Colors not updating in custom widgets:**

- Use `Theme.of(context)` instead of hardcoded colors
- Wrap widgets with `Consumer<ThemeProvider>` if needed
- Ensure colors are defined in both theme variants

**Build errors:**

- Run `flutter clean && flutter pub get`
- Restart your IDE/editor
- Check all imports are correct

---

## 📚 Recent Changes

### Light Theme Support (2025-01-08)

Added complete light and dark theme support with seamless switching:

- ✅ Created `ThemeProvider` for theme state management
- ✅ Added light theme color palette (8 new colors)
- ✅ Implemented `desktopLightTheme` and `phoneLightTheme` variants
- ✅ Created three theme toggle button components
- ✅ Integrated theme toggle in left navigation panel
- ✅ Made all scaffolds theme-aware (desktop/mobile/tablet)
- ✅ Responsive design maintained across both themes
- ✅ Fixed deprecated API warnings
- ✅ Production-ready with full documentation

**Benefits:**

- Improved user experience with theme choice
- Better accessibility (light mode for bright environments)
- Modern, professional appearance
- Smooth animated transitions
- No breaking changes to existing functionality

### DAO Layer Implementation (2025-01-08)

Implemented a clean DAO (Data Access Object) layer to separate database access from business logic:

- ✅ Created `PostDao` and `FirebasePostDao` for blog post operations
- ✅ Created `PositionDao` and `FirebasePositionDao` for position operations
- ✅ Refactored `BlogRepository` to use `PostDao` instead of direct Firebase access
- ✅ Refactored `PositionRepository` to use `PositionDao` instead of direct Firebase access
- ✅ Updated `service_locator.dart` to register DAOs
- ✅ All repositories now follow clean architecture principles
- ✅ Improved testability and maintainability

**Benefits:**
- Clear separation between data access and business logic
- Easy to mock for testing
- Flexible - can swap database implementations
- Follows SOLID principles
