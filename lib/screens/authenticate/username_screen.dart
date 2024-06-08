// ignore_for_file: use_build_context_synchronously

import 'package:caravan/models/user_profile.dart';
import 'package:caravan/screens/more%20screens/complete_profile.dart';
import 'package:caravan/services/auth.dart';
import 'package:caravan/shared/constants/text_field.dart';
import 'package:flutter/material.dart';

class UsernameScreen extends StatefulWidget {
  final UserProfile userProfile;
  final String password;

  const UsernameScreen(
      {super.key, required this.userProfile, required this.password});

  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';

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
          child: Column(
            children: [
              const Text(
                'Choose a username',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 280,
                      height: 50,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _usernameController,
                        decoration: myTextFieldStyle.copyWith(
                          hintText: 'Enter your username',
                          labelText: 'Username',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        minimumSize: const Size(280, 50),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                            _errorMessage = '';
                          });

                          String username = _usernameController.text;

                          try {
                            // Register the user
                            await AuthService().registerWithEmailAndPassword(
                              widget.userProfile.email!,
                              widget.password,
                              username,
                            );

                            // Log the user in
                            var user =
                                await AuthService().signInWithEmailAndPassword(
                              widget.userProfile.email!,
                              widget.password,
                            );

                            // Complete the user profile
                            widget.userProfile.completeProfile(
                              userID: user!.uid,
                              username: username,
                              email: widget.userProfile.email,
                            );

                            print(
                                "${widget.userProfile.username} ${widget.userProfile.email} ${widget.userProfile.userID}");
                            print("User logged in successfully");

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompleteProfile(
                                  userProfile: widget.userProfile,
                                ),
                              ),
                            );
                          } catch (e) {
                            setState(() {
                              _errorMessage = "Error: $e";
                              _isLoading = false;
                            });
                          }
                        }
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.black,
                            )
                          : Text(
                              'Next',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                            ),
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
