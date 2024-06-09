import 'package:caravan/screens/authenticate/interim_login.dart';
import 'package:flutter/material.dart'; // Add this line

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            const Spacer(),
            Text("Caravan",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0)),
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
            Text(
              "Be fast, save money and share rides with us today!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
              // center the text
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  // Navigate to sign in screen
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyLogin(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(380, 50),
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                child: Text(
                  'Get started',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                )
                // i want a button with width that span across the whole screen
                ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
