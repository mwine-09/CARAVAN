import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String? email;
  final String username;

  UserModel({
    required this.uid,
    this.email,
    required this.username,
  });

  factory UserModel.fromFirebase(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      username: user.displayName ?? '',
    );
  }
}
