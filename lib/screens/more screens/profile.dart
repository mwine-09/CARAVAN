import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Profile',
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              // Add user's profile picture here
              backgroundImage: AssetImage('assets/default_profile.jpg'),
            ),
            // allow user to change profile picture
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Add change profile picture functionality here
              },
              child: Text('Change profile picture'),
            ),

            const SizedBox(height: 20),
            const Text(
              // Add user's name here
              'John Doe',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            const Text(
              // Add user's email here
              'johndoe@example.com',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logout functionality here
              },
              child: Text('Logout'),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
