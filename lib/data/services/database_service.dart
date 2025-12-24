import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Database service for SQLite operations
class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'lundbrowder.db';
  static const int _databaseVersion = 1;

  /// Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Calculations table
    await db.execute('''
      CREATE TABLE calculations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        age_group TEXT NOT NULL,
        selected_areas TEXT NOT NULL,
        total_tbsa REAL NOT NULL,
        severity TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
