// import 'dart:js';

import 'package:caravan/firebase_options.dart';

import 'package:caravan/providers/chat_provider.dart';
import 'package:caravan/providers/location_provider.dart';
import 'package:caravan/providers/trips_provider.dart';
import 'package:caravan/providers/user_profile.provider.dart';
import 'package:caravan/providers/user_provider.dart';
import 'package:caravan/screens/authenticate/interim_login.dart';
import 'package:caravan/screens/tabs/history.dart';
import 'package:caravan/screens/more%20screens/welcome_screen.dart';
import 'package:caravan/screens/main_scaffold.dart';
import 'package:caravan/screens/more%20screens/profile.dart';
import 'package:caravan/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LocationProvider()),
    ChangeNotifierProvider(create: (context) => TripDetailsProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => ChatProvider()),
    ChangeNotifierProvider(create: (context) => UserProfileProvider())
  ], child: const MyRideSharingApp()));
}

class MyRideSharingApp extends StatelessWidget {
  const MyRideSharingApp({super.key});
  @override
  Widget build(BuildContext context) {
    // UserProfileProvider userProfileProvider =
    //     Provider.of<UserProfileProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        primarySwatch: Colors.yellow,
        pageTransitionsTheme: const PageTransitionsTheme(),
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          headlineSmall:
              GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400),
          titleLarge: GoogleFonts.roboto(
              fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
          titleMedium: GoogleFonts.roboto(
              fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
          titleSmall: GoogleFonts.roboto(
              fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
          bodyLarge: GoogleFonts.roboto(
              fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
          bodyMedium: GoogleFonts.roboto(
              fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          labelLarge: GoogleFonts.roboto(
              fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
          bodySmall: GoogleFonts.roboto(
              fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
          labelSmall: GoogleFonts.roboto(
              fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            minimumSize: const Size(88, 36),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ),

      routes: {
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfileScreen(),
        '/history': (context) => const HistoryScreen(),
        '/index': (context) => const Welcome(),
        '/login': (context) => const MyLogin()
      },

      home: const Wrapper(),

      // initialRoute: '/index',
    );
  }
}
