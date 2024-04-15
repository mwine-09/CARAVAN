import 'package:caravan/providers/user_provider.dart';
import 'package:caravan/screens/more%20screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of(context);
    String username = userProvider.getUsername();
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
        // iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage('assets/default_profile.jpg'),
              child: Stack(
                children: [
                  if (userProvider.getUid() == userProvider.getUid)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // use file picker
                        },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              userProvider.getUsername(),
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              userProvider.getEmail(),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.white),
                    title: Text(
                      "Personal data",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
                    onTap: () {
                      UserProvider userProvider =
                          Provider.of<UserProvider>(context, listen: false);
                      String uid = userProvider.getUid();

                      // Handle profile tap
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => // Initialize userProfile variable
                                    ProfileScreen(
                              uid: uid,
                            ),
                          ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.car_rental, color: Colors.white),
                    title: Text(
                      "Driver",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                    ),
                    trailing: Switch(
                        value: false,
                        onChanged: (value) {
                          value = true;
                        }),
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
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
                    onTap: () {
                      // Handle option 2 tap
                    },
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.notifications, color: Colors.white),
                    title: Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
                    onTap: () {
                      // Handle option 3 tap
                    },
                  ),
                  // Add more list tiles for additional options
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
