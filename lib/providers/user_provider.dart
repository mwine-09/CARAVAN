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

  String getEmail() {
    return user.email;
  }

  String getPassword() {
    return user.password;
  }

  String getUsername() {
    return user.username;
  }
}

class User {
  String email = '';
  String password = '';
  String username = '';
}
