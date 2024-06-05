import 'package:caravan/screens/authenticate/interim_login.dart';
import 'package:caravan/screens/tabs/main_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  // Declare your providers as final fields
  // final UserProfileProvider userProfileProvider;

  // Initialize your providers in the constructor
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authChanges = FirebaseAuth.instance.authStateChanges();

    return StreamBuilder<User?>(
      stream: authChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          logger.e("This is user data:  $user");

          if (user == null) {
            return const MyLogin();
          } else {
            return const HomePage(
              tabDestination: 1,
            );
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        }
      },
    );
  }
}
