// ignore_for_file: avoid_print, use_build_context_synchronously, duplicate_ignore
import 'package:caravan/screens/authenticate/register.dart';
import 'package:caravan/screens/main_template.dart';
import 'package:caravan/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // appBar: AppBar(
      //     backgroundColor: const Color(0xFF232323),
      //     elevation: 0.0,
      //     title: const Text('Sign in to Caravan',
      //         style: TextStyle(
      //             color: Color.fromARGB(255, 254, 254, 254),
      //             fontSize: 16,
      //             fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/car.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Sign in to Caravan",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // Respond to button press
                dynamic result = await _auth.signInAnon();
                if (result == null) {
                  print('error signing in');
                } else {
                  //  navigate to the home screen
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/main_template');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const MainTemplate()),
                  // );
                  print('signed in');
                  print(result.uid);
                }
              },
              style: ElevatedButton.styleFrom(
                // primary: Colors.blue,
                // onPrimary: Colors.white,
                minimumSize: const Size(150, 50),
              ),
              child: const Text('Sign in'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Or',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Respond to button press
                    // navigate to the register screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
