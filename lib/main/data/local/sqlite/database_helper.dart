import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Helper class to manage SQLite database
class DatabaseHelper {
  static const String _databaseName = 'portfolio_cache.db';
  static const int _databaseVersion = 2;

  // Table names
  static const String postsTable = 'posts';
  static const String positionsTable = 'positions';
  static const String projectsTable = 'projects';
  static const String educationTable = 'education';
  static const String skillsTable = 'skills';
  static const String personalInfoTable = 'personal_info';

  /// Initialize and create the database
  static Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create tables on database creation
  static Future<void> _onCreate(Database db, int version) async {
    // Create posts table
    await db.execute('''
      CREATE TABLE $postsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        imageLink TEXT NOT NULL,
        link TEXT NOT NULL
      )
    ''');

    // Create positions table
    await db.execute('''
      CREATE TABLE $positionsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        position TEXT NOT NULL,
        description TEXT NOT NULL,
        icon TEXT NOT NULL
      )
    ''');

    // Create projects table
    await db.execute('''
      CREATE TABLE $projectsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image TEXT NOT NULL,
        title TEXT NOT NULL,
        role TEXT NOT NULL,
        description TEXT NOT NULL,
        link TEXT
      )
    ''');

    // Create education table
    await db.execute('''
      CREATE TABLE $educationTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        text TEXT,
        link TEXT,
        imageUrl TEXT
      )
    ''');

    // Create skills table
    await db.execute('''
      CREATE TABLE $skillsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        value INTEGER NOT NULL,
        type TEXT NOT NULL
      )
    ''');

    // Create personal_info table
    await db.execute('''
      CREATE TABLE $personalInfoTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        email TEXT NOT NULL,
        socials TEXT NOT NULL
      )
    ''');
  }

  /// Handle database upgrades
  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Handle database migrations here
    if (oldVersion < 2) {
      // Add personal_info table in version 2
      await db.execute('''
        CREATE TABLE $personalInfoTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          image TEXT NOT NULL,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          email TEXT NOT NULL,
          socials TEXT NOT NULL
        )
      ''');
    }
  }
}
