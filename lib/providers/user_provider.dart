import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User user = User();

  void setUserEmail(String email) {
    user.email = email;
    notifyListeners();
  }

  void setUserPassword(String password) {
    user.password = password;
    notifyListeners();
  }

  void setUsername(String username) {
    user.username = username;
    notifyListeners();
  }

  void setUid(String uid) {
    user.uid = uid;
    notifyListeners();
  }

  String getEmail() {
    return user.email;
  }

  String getPassword() {
    return user.password;
  }

  String getUsername() {
    return user.username;
  }

  String getUid() {
    return user.uid;
  }
}

class User {
  String uid = '';
  String email = '';
  String password = '';
  String username = '';
}
