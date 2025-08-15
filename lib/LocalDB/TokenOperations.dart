// ignore_for_file: file_names
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbatica/model/user.dart';

class TokenOperations {
  /// Save user profile by converting User object to JSON
  Future<void> saveUserProfile(User user) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(user.toJson());
    await prefs.setString('user', jsonString);
  }

  /// Load user profile and return User object (null if not found)
  Future<User?> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('user');

    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return User.fromJson(jsonMap);
  }

  /// Delete the stored user profile
  Future<bool> deleteUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove('user');
  }
}
