import 'package:caravan/screens/more%20screens/welcome_screen.dart';
import 'package:caravan/screens/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _navigateToHome();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimated = true;
      });
    });
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 4));

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Welcome()),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Wrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 255, 255, 255), // Change to your preferred color
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 3),
            left: _isAnimated
                ? MediaQuery.of(context).size.width / 2 - 50
                : MediaQuery.of(context).size.width,
            top: MediaQuery.of(context).size.height / 2 - 50,
            curve: Curves.easeInOut,
            child: Image.asset(
              'assets/splashImage.png', // Replace with your image path
              width: 100,
              height: 100,
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 150.0),
              child: Text(
                'Caravan',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
