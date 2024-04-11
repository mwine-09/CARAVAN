// ignore_for_file: use_build_context_synchronously

import 'package:caravan/models/user.dart';
import 'package:caravan/providers/user_provider.dart';
import 'package:caravan/screens/more%20screens/complete_profile.dart';
import 'package:caravan/services/auth.dart';
import 'package:caravan/shared/constants/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Choose Username',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: false,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Column(children: [
              const Text(
                'Choose a username',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: 280,
                height: 50,
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _usernameController,
                  decoration: myTextFieldStyle.copyWith(
                      hintText: 'Enter your username', labelText: 'username'),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(280, 50)),
                onPressed: () {
                  String username = _usernameController.text;
                  userProvider.setUsername(username);

                  String email = userProvider.getEmail();
                  String password = userProvider.getPassword();
                  // create account
                  AuthService()
                      .registerWithEmailAndPassword(email, password, username);
                  // log the user in
                  AuthService()
                      .signInWithEmailAndPassword(email, password)
                      .then((value) => {userProvider.setUid(value)});
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CompleteProfile()));
                },
                child: Text('Next',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.black, fontSize: 18)),
              )
            ]))));
  }
}
