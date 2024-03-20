import 'package:caravan/firebase_options.dart';
import 'package:caravan/screens/history.dart';
import 'package:caravan/screens/home/home.dart';
import 'package:caravan/screens/index.dart';
import 'package:caravan/screens/main_template.dart';
import 'package:caravan/screens/profile.dart';
import 'package:caravan/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutterfire_cli/flutterfire_cli.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyRideSharingApp());
}

class MyRideSharingApp extends StatelessWidget {
  const MyRideSharingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: Wrapper(),
      routes: {
        '/': (context) => const Wrapper(),
        '/home': (context) => const Home(),
        '/profile': (context) => const ProfileScreen(),
        '/history': (context) => const HistoryScreen(),
        '/main-template': (context) => const MainTemplate(),
        '/index': (context) => const Welcome(),
      },
      initialRoute: '/index',
    );
  }
}
