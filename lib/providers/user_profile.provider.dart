import 'package:caravan/providers/chat_provider.dart';
import 'package:caravan/services/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:caravan/models/user_profile.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider extends ChangeNotifier {
  static UserProfile _userProfile = UserProfile();

  void initialize(String uid) {
    DatabaseService().getUserProfile(uid).then((value) {
      userProfile = value;
    });
  }

  UserProfile get userProfile => _userProfile;

  set userProfile(UserProfile value) {
    _userProfile = value;
    notifyListeners();
  }

  void updateUserProfile(UserProfile newProfile) {
    userProfile = newProfile;
  }

  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _userProfile = UserProfile.fromJson(
        jsonDecode(prefs.getString('userProfile') ?? '{}'));
    notifyListeners();
  }

  Future<void> saveUserProfile(UserProfile userProfile) async {
    logger.i('Saving user profile: $userProfile');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfile', jsonEncode(userProfile.toJson()));
    _userProfile = userProfile;
    logger.e("Done saving profile to shared preferences");
    notifyListeners();
  }

  void reset() {
    userProfile = UserProfile();
  }
}
