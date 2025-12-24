import '../models/user_model.dart';
import '../services/database_service.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Repository for user database operations
class UserRepository {
  final DatabaseService _databaseService;

  UserRepository(this._databaseService);

  /// Hash password using SHA256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Create new user (register)
  Future<User?> createUser(String name, String email, String password) async {
    try {
      final db = await _databaseService.database;
      final hashedPassword = _hashPassword(password);

      final user = User(name: name, email: email, password: hashedPassword);

      final id = await db.insert('users', user.toMap());
      return user.copyWith(id: id);
    } catch (e) {
      return null;
    }
  }

  /// Get user by email
  Future<User?> getUserByEmail(String email) async {
    final db = await _databaseService.database;
    final results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (results.isEmpty) return null;
    return User.fromMap(results.first);
  }

  /// Login user
  Future<User?> login(String email, String password) async {
    final user = await getUserByEmail(email);
    if (user == null) return null;

    final hashedPassword = _hashPassword(password);
    if (user.password != hashedPassword) return null;

    return user;
  }

  /// Check if email exists
  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }
}
