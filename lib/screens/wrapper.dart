import 'package:caravan/providers/chat_provider.dart';
import 'package:caravan/providers/user_profile.provider.dart';
import 'package:caravan/screens/authenticate/interim_login.dart';
import 'package:caravan/screens/main_scaffold.dart';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:caravan/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          if (user == null) {
            return const MyLogin();
          } else {
            // Initialize the user profile

            return const HomePage();
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
