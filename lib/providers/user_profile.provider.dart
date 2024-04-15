import 'package:caravan/models/emergency_contact.dart';
import 'package:caravan/models/user_profile.dart';
import 'package:flutter/foundation.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfile _userProfile;
  UserProfileProvider(this._userProfile);

  UserProfile get userProfile => _userProfile;

  void updateUserProfile(UserProfile newProfile) {
    _userProfile = newProfile;
    notifyListeners();
  }

  // Add your methods and logic here

  // set emergency contacts
  void setEmergencyContacts(List<EmergencyContact> emergencyContacts) {
    _userProfile.emergencyContacts = emergencyContacts;
    notifyListeners();
  }

// get user profile function
  UserProfile getUserProfile() {
    return _userProfile;
  }

  // set user profile function
  void setUserProfile(UserProfile userProfile) {
    _userProfile = userProfile;
    notifyListeners();
  }
}
