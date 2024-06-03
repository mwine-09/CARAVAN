import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String oldPassword = '';
  String newPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Change Password',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Old Password',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  oldPassword = value;
                });
              },
              obscureText: true,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'New Password',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  newPassword = value;
                });
              },
              obscureText: true,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement password change logic
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
