import 'package:shared_preferences/shared_preferences.dart';

class Token {
  static final Token _instance = Token._internal();
  factory Token() => _instance;
  Token._internal();

  static const _tokenKey = 'auth_token';

  Future<void> savetoken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> gettoken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
