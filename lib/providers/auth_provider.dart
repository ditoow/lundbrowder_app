import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';

/// Authentication state enum
enum AuthState { initial, loading, authenticated, unauthenticated, error }

/// Provider for authentication state management
class AuthProvider with ChangeNotifier {
  final UserRepository _userRepository;

  static const String _userIdKey = 'logged_in_user_id';
  static const String _userEmailKey = 'logged_in_user_email';

  AuthState _state = AuthState.initial;
  User? _currentUser;
  String? _errorMessage;

  AuthProvider(this._userRepository);

  // Getters
  AuthState get state => _state;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;

  /// Check if user is already logged in (session persistence)
  Future<bool> checkLoginStatus() async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString(_userEmailKey);

      if (savedEmail != null) {
        // Try to get user from database
        final user = await _userRepository.getUserByEmail(savedEmail);
        if (user != null) {
          _currentUser = user;
          _state = AuthState.authenticated;
          notifyListeners();
          return true;
        }
      }

      _state = AuthState.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _state = AuthState.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  /// Save login session
  Future<void> _saveSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, user.id ?? 0);
    await prefs.setString(_userEmailKey, user.email);
  }

  /// Clear login session
  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _userRepository.login(email, password);

      if (user != null) {
        _currentUser = user;
        _state = AuthState.authenticated;
        await _saveSession(user);
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Email atau password salah';
        _state = AuthState.unauthenticated;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  /// Register new user
  Future<bool> register(String name, String email, String password) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check if email already exists
      final emailExists = await _userRepository.emailExists(email);
      if (emailExists) {
        _errorMessage = 'Email sudah terdaftar';
        _state = AuthState.unauthenticated;
        notifyListeners();
        return false;
      }

      final user = await _userRepository.createUser(name, email, password);

      if (user != null) {
        _currentUser = user;
        _state = AuthState.authenticated;
        await _saveSession(user);
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Gagal mendaftar. Silakan coba lagi.';
        _state = AuthState.unauthenticated;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _clearSession();
    _currentUser = null;
    _state = AuthState.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
