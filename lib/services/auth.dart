// ignore_for_file: avoid_print

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:caravan/models/user.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  // _auth is an instance of FirebaseAuth class and it is a private variable
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // create a user based on the firebase user
  UserModel _userFromFireBase(User user) {
    return UserModel(
        uid: user.uid, email: user.email, username: user.displayName!);
  }

  //
  // sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();

      UserModel? user = _userFromFireBase(result.user!);
      return user;
    } catch (e) {
      print(e.toString());
      // print the error message
      return null;
      // return null
    }
  }

// Stream <User> get user{
//   return _auth
// }
// sign in with phone number
  Future signInWithPhoneNumber(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      // await _auth.verifyPhoneNumber(
      //   phoneNumber: phoneNumber,
      //   verificationCompleted: (PhoneAuthCredential credential) async {
      //     UserCredential result = await _auth.signInWithCredential(credential);
      //     UserModel? user = _userFromFireBase(result.user!);
      //     print(user);
      //   },
      //   verificationFailed: (FirebaseAuthException e) {
      //     print(e.message);
      //   },
      //   codeSent: (String verificationId, int? resendToken) {
      //     print('Verification ID: $verificationId');
      //     print('Resend Token: $resendToken');
      //   },
      //   codeAutoRetrievalTimeout: (String verificationId) {
      //     // Auto-resolution timed out
      //     // You can handle this case by prompting the user to enter the code manually
      //     // or by automatically retrying with a new verification request
      //     print('Verification ID: $verificationId');
      //   },
      // );
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // getCurrentUser function as a base user
  UserModel? getCurrentUser() {
    User? user = _auth.currentUser;
    return _userFromFireBase(user!);
  }

  //register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = result.user;

      await user!.sendEmailVerification();
      await user.updateDisplayName(name);

      return _userFromFireBase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      result.toString();
      // print(result.user);
      print("MWine mwinewine");
      User? user = result.user;
      print(user!.displayName);
      return _userFromFireBase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
