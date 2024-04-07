import 'package:caravan/models/user.dart';
import 'package:flutter/material.dart';

class BaseUserProvider extends ChangeNotifier {
  BaseUser? _baseUser;

  BaseUser? get baseUser => _baseUser;

  void setBaseUser(BaseUser baseUser) {
    _baseUser = baseUser;
    notifyListeners();
  }
}
