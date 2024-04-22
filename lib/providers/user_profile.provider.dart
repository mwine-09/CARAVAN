import 'package:caravan/services/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:caravan/models/user_profile.dart';

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

  void reset() {
    userProfile = UserProfile();
  }
}
