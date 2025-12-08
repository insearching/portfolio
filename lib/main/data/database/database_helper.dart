import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Helper class to manage SQLite database
class DatabaseHelper {
  static const String _databaseName = 'portfolio_cache.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String postsTable = 'posts';
  static const String positionsTable = 'positions';

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

    print('Database tables created successfully');
  }

  /// Handle database upgrades
  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Handle future database migrations here
    print('Database upgraded from version $oldVersion to $newVersion');
  }
}
