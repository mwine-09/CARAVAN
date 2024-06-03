import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get current user
  User getCurrentUser() {
    try {
      User user = _auth.currentUser!;
      return user;
    } catch (e) {
      logger.i(e.toString());
      rethrow;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        await user.sendEmailVerification();
        await user.updateDisplayName(name);
      } else {
        logger.i('User is null');
        return null;
      }

      return user;
    } catch (e) {
      logger.i(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user == null) {
        logger.i('User is null');
        return null;
      }

      return user;
    } catch (e) {
      logger.i("Error from the sign in function ${e.toString()}");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      logger.i(e.toString());
    }
  }
}
