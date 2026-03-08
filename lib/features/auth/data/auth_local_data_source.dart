import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {

  final _secureStorage = const FlutterSecureStorage();

  static const _usernameKey = 'username';
  static const _passwordKey = 'password';
  static const _loggedInKey = 'logged_in';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  Future<void> register(String username, String password) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_usernameKey, username);
    await prefs.setBool(_loggedInKey, true);

    await _secureStorage.write(
      key: _passwordKey,
      value: password,
    );
  }

  Future<bool> login(String username, String password) async {

    final prefs = await SharedPreferences.getInstance();

    final storedUsername = prefs.getString(_usernameKey);
    final storedPassword = await _secureStorage.read(key: _passwordKey);

    if (storedUsername == username && storedPassword == password) {
      await prefs.setBool(_loggedInKey, true);
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
  }
}