import 'package:caravan/providers/user_provider.dart';
import 'package:caravan/screens/authenticate/interim_login.dart';
import 'package:caravan/screens/authenticate/username_screen.dart';
import 'package:caravan/screens/more%20screens/complete_profile.dart';
import 'package:caravan/services/auth.dart';
import 'package:caravan/services/database_service.dart';
import 'package:caravan/shared/constants/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email = '';
  String password = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
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
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 280,
                  height: 50,
                  child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      decoration: myTextFieldStyle,
                      style: myInputTextStyle),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 280,
                  height: 50,
                  child: TextField(
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      decoration:
                          myTextFieldStyle.copyWith(labelText: 'Password'),
                      style: myInputTextStyle),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 280,
                  height: 50,
                  child: TextField(
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          confirmPassword = value;
                        });
                      },
                      decoration: myTextFieldStyle.copyWith(
                          labelText: 'Confirm Password'),
                      style: myInputTextStyle),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Implement your registration logic here
                    if (password == confirmPassword) {
                      // Passwords match, proceed with registration

                      userProvider.setUserEmail(email);
                      userProvider.setUserPassword(password);

                      // create user with email and password
                      // then navigate to complete profile screen

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UsernameScreen()));
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
                  ),
                  child: const Text('Register',
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                const SizedBox(
                  height: 20,
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
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
