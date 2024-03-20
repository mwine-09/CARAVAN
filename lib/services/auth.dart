// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:caravan/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // _auth is an instance of FirebaseAuth class and it is a private variable
  // create a user based on the firebase user
  BaseUser? _userFromFireBase(User user) {
    // ignore: unnecessary_null_comparison
    return user != null ? BaseUser(uid: user.uid) : null;
    // if user is not null, return the user data
    // else return null
  }

  //
  // sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      BaseUser? user = _userFromFireBase(result.user!);
      return user;
      // UserCredential is a class that holds the user data
      // signInAnonymously() is a method that returns a Future object
      // await is used to wait for the Future object to return a value
      // result is a variable of type UserCredential that holds the user data
      // user is a variable of type User that holds the user data
      // return user;
      // return the user data
    } catch (e) {
      print(e.toString());
      // print the error message
      return null;
      // return null
    }
  }

  // sign in with email and password

  //register with email and password

  // sign out
}
