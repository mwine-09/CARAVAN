import 'package:caravan/screens/more%20screens/profile.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: Text(
              "Profile",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () {
              // Handle profile tap
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.white),
            title: Text(
              'Delete account',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () {
              // Handle option 2 tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.white),
            title: Text(
              'Notifications',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () {
              // Handle option 3 tap
            },
          ),
          // Add more list tiles for additional options
        ],
      ),
    );
  }
}
