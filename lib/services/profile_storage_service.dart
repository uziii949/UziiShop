import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzii_shop/models/user_profile_model.dart';

class ProfileStorageService {
  static const String _profileKey = 'uzii_user_profile';

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, json.encode(profile.toJson()));
  }

  Future<UserProfile?> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString(_profileKey);
      if (jsonStr == null) return null;
      return UserProfile.fromJson(json.decode(jsonStr));
    } catch (e) {
      return null;
    }
  }

  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }
}