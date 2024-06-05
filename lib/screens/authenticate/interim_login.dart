import 'dart:io';

import 'package:caravan/models/user_profile.dart';
import 'package:caravan/providers/chat_provider.dart';
import 'package:caravan/providers/notification_provider.dart';
import 'package:caravan/providers/trips_provider.dart';

import 'package:caravan/providers/user_profile.provider.dart';
import 'package:caravan/screens/authenticate/email_register.dart';
import 'package:caravan/screens/more%20screens/complete_profile.dart';
import 'package:caravan/services/auth.dart';
import 'package:caravan/services/database_service.dart';

import 'package:flutter/material.dart';

import 'package:logger/web.dart';
import 'package:provider/provider.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  _MyLoginState createState() => _MyLoginState();
}

Logger logger = Logger();

class _MyLoginState extends State<MyLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  late String email;
  late String password;
  String errorMessage = ''; // Add this variable to hold the error message

  bool isValidEmail(String email) {
    // Use a regular expression to check if the email is in a valid format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

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
    UserProfileProvider userProfileProvider =
        Provider.of(context, listen: true);

    Provider.of<TripDetailsProvider>(context, listen: true);

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Caravan",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(
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
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      decoration:
                          loginInputDecoration.copyWith(labelText: 'Email'),
                      style: const TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !isValidEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: _obscureText,
                      // obscuringCharacter: '9',
                      style: const TextStyle(
                          color: Colors.white, letterSpacing: 2),
                      cursorColor: Colors.white,

                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },

                      decoration: loginInputDecoration.copyWith(
                        labelText: 'Password',
                        suffixIcon: GestureDetector(
                          child: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Display error message if it is not empty
                    errorMessage.isNotEmpty
                        ? Text(errorMessage,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Colors.red,
                                  fontSize: 16,
                                ))
                        : const SizedBox(),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            barrierDismissible:
                                false, // Prevent dialog from being dismissed
                            builder: (BuildContext context) {
                              return AlertDialog(
                                titleTextStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                backgroundColor: Colors.white,
                                content: const Row(
                                  children: <Widget>[
                                    CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 20),
                                    Text("Signing in..."),
                                  ],
                                ),
                              );
                            },
                          );

                          AuthService()
                              .signInWithEmailAndPassword(email, password)
                              .then((value) async {
                            Navigator.pop(context); // Close the loading dialog
                            if (value != null) {
                              // Provider.of<NotificationProvider>(context);

                              // get email
                              final userProfile = UserProfile();
                              final userExists = await DatabaseService()
                                  .checkIfUserExists(value.uid);
                              if (!userExists) {
                                userProfile.completeProfile(
                                    userID: value.uid,
                                    email: email,
                                    username: value.displayName);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CompleteProfile(
                                            userProfile: userProfile)));
                                return;
                              }

                              DatabaseService()
                                  .getUserProfile(value.uid)
                                  .then((value) {
                                // userProfileProvider.userProfile = value;
                                userProfileProvider.saveUserProfile(value);
                                userProfileProvider.userProfile.email = email;
                                Provider.of<NotificationProvider>(context);
                                chatProvider.reset();
                                chatProvider.listenToChatrooms(value.userID!);
                              });

                              logger.i(
                                  'Chat provider: ${chatProvider.chatrooms.length}');
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/home');

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Logged in as ${value.displayName}",
                                  ),
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    textColor: Colors.white,
                                    label: 'OK',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                  ),
                                ),
                              );
                            } else {
                              // User is null, show error message
                              setState(() {
                                errorMessage = 'Invalid email or password';
                              });
                            }
                          }).catchError((error) {
                            Navigator.pop(context); // Close the loading dialog
                            // Show an error message
                            setState(() {
                              errorMessage =
                                  'An error occurred while signing in. Please try again.';
                            });

                            logger.i('Error signing in: $error');
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 50),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ).copyWith(
                        backgroundColor: WidgetStateProperty.all(
                            const Color.fromARGB(255, 255, 255, 255)),
                        foregroundColor: WidgetStateProperty.all(Colors.black),
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
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
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
      ),
    );
  }
}
