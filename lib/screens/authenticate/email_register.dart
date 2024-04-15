import 'package:caravan/models/user_profile.dart';
import 'package:caravan/providers/user_provider.dart';
import 'package:caravan/screens/authenticate/interim_login.dart';
import 'package:caravan/screens/authenticate/username_screen.dart';
import 'package:caravan/shared/constants/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email = '';
  String password = '';
  String confirmPassword = '';
  UserProfile userProfile = UserProfile();

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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
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
                  TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      decoration: loginInputDecoration.copyWith(
                          labelText: 'Email Address'),
                      style: myInputTextStyle),
                  const SizedBox(height: 10),
                  TextField(
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      decoration:
                          loginInputDecoration.copyWith(labelText: 'Password'),
                      style: myInputTextStyle),
                  const SizedBox(height: 10),
                  TextField(
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          confirmPassword = value;
                        });
                      },
                      decoration: loginInputDecoration.copyWith(
                          labelText: 'Confirm Password'),
                      style: myInputTextStyle),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      // Implement your registration logic here
                      if (password == confirmPassword) {
                        // Passwords match, proceed with registration
                        userProfile.completeProfile(
                          email: email,
                        );
                        print('User Profile: ${userProfile.email}');

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UsernameScreen(
                                      userProfile: userProfile,
                                      password: password,
                                    )));
                      } else {
                        // Passwords don't match, show error message
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(280, 50),
                      // reduce rounded corners
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
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
                  SizedBox(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyLogin()));
                        },
                        child: Text(
                          'Already have an account? Login',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                        )),
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
