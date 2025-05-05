// ignore_for_file: file_names
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//User:
// bio,
// anonymous user name,
// follower[list of tokens of user], following[list of tokens of users],
// gender,
// interested_topics[],
// tokens,
// number of posts,
// number of comments,
// karma(upvotes, downVotes),
// avatarId,
// country,
// isEmailVerified

class TokenOperations {
  Future<void> saveUserProfile(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(user);
    await prefs.setString('user', jsonString);
  }

  Future<Map<String, dynamic>?> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('user');

    if (jsonString == null) return null;

    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<bool> deleteTokens() async {
    final prefs = await SharedPreferences.getInstance();
    bool status = await prefs.remove('user');
    return status;
  }
}
