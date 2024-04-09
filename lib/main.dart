import 'package:caravan/firebase_options.dart';
import 'package:caravan/providers/trips_provider.dart';
import 'package:caravan/providers/user_provider.dart';
import 'package:caravan/screens/tabs/history.dart';
import 'package:caravan/screens/more%20screens/welcome_screen.dart';
import 'package:caravan/screens/main_scaffold.dart';
import 'package:caravan/screens/tabs/profile.dart';
import 'package:caravan/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => TripDetailsProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
  ], child: const MyRideSharingApp()));
}

class MyRideSharingApp extends StatelessWidget {
  const MyRideSharingApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Wrapper(),
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
        ),

        // primarySwatch: Colors.blue,

        primaryColor: Colors.black,
        secondaryHeaderColor: Colors.white,
      ),

      routes: {
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfileScreen(),
        '/history': (context) => const HistoryScreen(),
        '/index': (context) => const Welcome(),
      },
      // initialRoute: '/index',
    );
  }
}
