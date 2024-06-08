import 'package:caravan/providers/chat_provider.dart';
import 'package:caravan/services/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:caravan/models/user_profile.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider extends ChangeNotifier {
  static UserProfile _userProfile = UserProfile();

  UserProfile get userProfile => _userProfile;

  set userProfile(UserProfile value) {
    _userProfile = value;
    notifyListeners();
  }

  Future<void> initialize(String uid) async {
    try {
      UserProfile? profile = await DatabaseService().getUserProfile(uid);
      userProfile = profile;
    } catch (e) {
      logger.e('Failed to initialize user profile: $e');
      userProfile =
          UserProfile(); // Set to a default value if initialization fails
    }
  }

  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      String? userProfileString = prefs.getString('userProfile');
      if (userProfileString != null && userProfileString.isNotEmpty) {
        _userProfile = UserProfile.fromJson(jsonDecode(userProfileString));
      } else {
        _userProfile = UserProfile(); // Default value
      }
      notifyListeners();
    } catch (e) {
      logger.e('Failed to load user profile: $e');
      _userProfile = UserProfile(); // Set to a default value if loading fails
      notifyListeners();
    }
  }

  Future<void> saveUserProfile(UserProfile userProfile) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString('userProfile', jsonEncode(userProfile.toJson()));
      _userProfile = userProfile;
      logger.i('User profile saved successfully.');
      notifyListeners();
    } catch (e) {
      logger.e('Failed to save user profile: $e');
    }
  }

  void updateUserProfile(UserProfile newProfile) {
    userProfile = newProfile;
  }

  void reset() {
    _userProfile = UserProfile();
    notifyListeners();
  }
}
