import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String phoneNumber = '+256 760588927';
  String profilePicture = 'assets/default_profile.jpg';
  // String password = '********';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
        title: const Center(
          child: Text('Profile',
              style: TextStyle(
                  color: Color.fromARGB(255, 254, 254, 254),
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(profilePicture),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Phone Number:',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('$phoneNumber',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
              // const SizedBox(height: 16),
              // Text('Password: $password',
              //     style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement edit phone number functionality
                },
                child: const Text('Edit Phone Number'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement edit profile picture functionality
                },
                child: const Text('Edit Profile Picture'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement edit password functionality
                },
                child: const Text('Edit phone number'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
