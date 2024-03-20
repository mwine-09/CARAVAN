import 'package:caravan/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFF232323),
      //   title: const Text('Welcome to Caravan',
      //       style: TextStyle(
      //           color: Color.fromARGB(255, 254, 254, 254),
      //           fontSize: 16,
      //           fontWeight: FontWeight.bold)),
      // ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            const Spacer(),
            const Text("Caravan",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'San Francisco')),
            const Spacer(),
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/car.png'),
                ),
              ),
            ),
            const Spacer(),
            const Text(
              "Be fast, save money and share rides with us today!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'San Francisco',
              ),
              // center the text
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Navigate to sign in screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignIn(),
                    ));
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(400, 50),
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: const BeveledRectangleBorder()),

              child: const Text(
                'Get started',
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 18),
              ),
              // i want a button with width that span across the whole screen
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
