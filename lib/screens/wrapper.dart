import 'package:caravan/providers/notification_provider.dart';
import 'package:caravan/providers/trips_provider.dart';
import 'package:caravan/screens/authenticate/interim_login.dart';
import 'package:caravan/screens/tabs/main_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

Logger logger = Logger();

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authChanges = FirebaseAuth.instance.authStateChanges();

    final notificationProvider = NotificationProvider();
    final tripDetailsProvider = TripDetailsProvider();

    return StreamBuilder<User?>(
      stream: authChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          logger.e("This is user data:  $user");

          if (user == null) {
            return const MyLogin();
          } else {
            logger.i("User is logged in: $user");

            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: notificationProvider,
                ),
                ChangeNotifierProvider.value(
                  value: tripDetailsProvider,
                ),
              ],
              child: const HomePage(tabDestination: 1),
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
