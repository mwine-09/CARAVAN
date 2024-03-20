// ignore_for_file: avoid_print, use_build_context_synchronously, duplicate_ignore
import 'package:caravan/screens/authenticate/register.dart';
// import 'package:caravan/screens/main_template.dart';
import 'package:caravan/services/auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  String phoneNumber = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Enter your phone number",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                setState(() {
                  phoneNumber = value;
                });
              },
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: 'Phone number',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // Respond to button press
                dynamic result = await _auth.signInAnon();
                // get user input and pass it to the signInWithPhoneNumber function
                // print(phoneNumber);
                // dynamic result = await _auth.signInWithPhoneNumber(phoneNumber);
                if (result == null) {
                  print('error signing in');
                } else {
                  //  navigate to the home screen
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/main-template');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const MainTemplate()),
                  // );
                  print('signed in');
                  print(result.uid);
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(280, 50),
                // reduce rounded corners
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: const Text('send code',
                  style: TextStyle(color: Colors.black, fontSize: 20)),
            ),
            const SizedBox(height: 10),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
