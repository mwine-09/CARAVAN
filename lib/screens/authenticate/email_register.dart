import 'package:caravan/models/user_profile.dart';
import 'package:caravan/screens/authenticate/interim_login.dart';
import 'package:caravan/screens/authenticate/username_screen.dart';
import 'package:caravan/shared/constants/text_field.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  UserProfile userProfile = UserProfile();
  bool passwdObsecure = true;
  bool passwdConfirmObsecure = true;

  // Email validation regex
  final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  @override
  Widget build(BuildContext context) {
    var loginInputDecoration = InputDecoration(
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.0),
      ),
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
      border: const OutlineInputBorder(),
    );

    return Scaffold(
      backgroundColor: Colors.black,
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
                    Text("Get started!",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                            )),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: loginInputDecoration.copyWith(
                          labelText: 'Email Address'),
                      style: myInputTextStyle,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: passwdObsecure,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: loginInputDecoration.copyWith(
                        labelText: 'Password',
                        suffixIcon: GestureDetector(
                          child: Icon(
                            passwdObsecure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onTap: () {
                            setState(() {
                              passwdObsecure = !passwdObsecure;
                            });
                          },
                        ),
                      ),
                      style: myInputTextStyle,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: passwdConfirmObsecure,
                      onChanged: (value) {
                        confirmPassword = value;
                      },
                      decoration: loginInputDecoration.copyWith(
                        labelText: 'Confirm Password',
                        suffixIcon: GestureDetector(
                          child: Icon(
                            passwdConfirmObsecure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onTap: () {
                            setState(() {
                              passwdConfirmObsecure = !passwdConfirmObsecure;
                            });
                          },
                        ),
                      ),
                      style: myInputTextStyle,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          userProfile.completeProfile(
                            email: email,
                          );
                          print('User Profile: ${userProfile.email}');

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UsernameScreen(
                                userProfile: userProfile,
                                password: password,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(280, 50),
                        // reduce rounded corners
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ).copyWith(
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: Text('Register',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                  )),
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
                              builder: (context) => const MyLogin()),
                        );
                      },
                      child: Text(
                        'Already have an account? Login',
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
