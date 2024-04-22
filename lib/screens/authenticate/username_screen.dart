// ignore_for_file: use_build_context_synchronously

import 'package:caravan/models/user_profile.dart';
import 'package:caravan/screens/more%20screens/complete_profile.dart';
import 'package:caravan/services/auth.dart';
import 'package:caravan/shared/constants/text_field.dart';

import 'package:flutter/material.dart';

class UsernameScreen extends StatelessWidget {
  final UserProfile userProfile;
  final String password;
  UsernameScreen(
      {super.key, required this.userProfile, required this.password});

  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                onPressed: () async {
                  String username = _usernameController.text;

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'Creating account...',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  );

                  print(userProfile.username);

                  try {
                    // Register the user
                    await AuthService().registerWithEmailAndPassword(
                      userProfile.email!,
                      password,
                      username,
                    );

                    // Log the user in
                    var user = await AuthService().signInWithEmailAndPassword(
                      userProfile.email!,
                      password,
                    );

                    // Complete the user profile
                    userProfile.completeProfile(
                      userID: user!.uid,
                      username: username,
                      email: userProfile.email,
                    );

                    print(
                        "${userProfile.username} ${userProfile.email} ${userProfile.userID}");
                    print("User logged in successfully");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompleteProfile(
                          userProfile: userProfile,
                        ),
                      ),
                    );
                  } catch (e) {
                    // Handle any errors that occur during registration or login
                    print("Error: $e");
                  }
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
