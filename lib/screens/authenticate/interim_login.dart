import 'package:caravan/components/loading_screen.dart';
import 'package:caravan/models/user.dart';
import 'package:caravan/providers/user_provider.dart';
import 'package:caravan/screens/authenticate/email_register.dart';
import 'package:caravan/services/auth.dart';
import 'package:caravan/shared/constants/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    var loginInputDecoration = InputDecoration(
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.0),
      ),
      labelText: 'Password',
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
      border: const OutlineInputBorder(),
    );
    UserProvider userProvider = Provider.of(context, listen: true);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Caravan",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0)),
                  const SizedBox(
                    height: 16,
                  ),
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
                  Text(
                    "Get started!",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Column(
                      children: [
                        Text(
                          "Enter your email and password",
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration:
                        loginInputDecoration.copyWith(labelText: 'Email'),
                    style: const TextStyle(
                        color: Colors.white, overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    decoration:
                        loginInputDecoration.copyWith(labelText: 'Password'),
                    style: myInputTextStyle,
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        AuthService()
                            .signInWithEmailAndPassword(email, password)
                            .then((value) {
                          userProvider.setUsername(value.username);
                          userProvider.setUid(value.uid);
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/home');
                          print('Signed in: ${value.username}');
                        }).onError((error, stackTrace) {
                          // tell the user that the email or password is incorrect on the screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoadingScreen(durationtime: 20,)));
                        });
                      } catch (e) {
                        // tell the user that the email or password is incorrect
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoadingScreen(durationtime: 10000,)));

                        print('Error signing in: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 255, 255)),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          // color: Color.fromARGB(255, 252, 252, 252),
                          fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    },
                    child: Text(
                      'Don\'t have an account? Register',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
