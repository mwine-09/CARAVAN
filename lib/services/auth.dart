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
  // Future<User?> signInWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     UserCredential result = await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     User? user = result.user;

  //     if (user == null) {
  //       logger.i('User is null');
  //       return null;
  //     }

  //     return user;
  //   } catch (e) {
  //     logger.i("Error from the sign in function ${e.toString()}");
  //     return null;
  //   }
  // }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user == null) {
        logger.d('User is null');
        return null;
      }

      return user;
    } on FirebaseAuthException catch (e) {
      logger.d("Error from the sign in function ${e.toString()}");
      if (e.code == 'user-not-found') {
        throw AuthException('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Wrong password provided.');
      } else if (e.code == 'network-request-failed') {
        throw AuthException('Network error. Please check your connection.');
      } else {
        throw AuthException('An unexpected error occurred. Please try again.');
      }
    } catch (e) {
      logger.d("Unknown error: ${e.toString()}");
      throw AuthException('An unexpected error occurred. Please try again.');
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

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}
