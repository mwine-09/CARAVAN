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

    return StreamBuilder<User?>(
      stream: authChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          logger.e("This is user data:  $user");

          if (user == null) {
            return const MyLogin();
          } else {
            final notificationProvider =
                Provider.of<NotificationProvider>(context, listen: false);
            notificationProvider.startListeningToNotifications();
            final tripDetailsProvider =
                Provider.of<TripDetailsProvider>(context, listen: false);
            tripDetailsProvider.initializeTripsListener();
            logger.i("User is logged in: $user");

            return MultiProvider(
              providers: [
                //  create the trip provider here
                ChangeNotifierProvider(
                    create: (context) => TripDetailsProvider()),
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
