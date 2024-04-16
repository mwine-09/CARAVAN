import 'dart:io';

import 'package:caravan/models/user_profile.dart';
import 'package:caravan/providers/user_profile.provider.dart';
import 'package:caravan/providers/user_provider.dart';
import 'package:caravan/screens/more%20screens/profile.dart';
import 'package:caravan/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    UserProfileProvider userProfileProvider = Provider.of(context);
    UserProfile userProfile = userProfileProvider.userProfile;
    String username = userProfileProvider.userProfile.username!;
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
              backgroundImage: userProfile.photoUrl != null
                  ? NetworkImage(userProfile.photoUrl!)
                  : const AssetImage('assets/default_profile.jpg')
                      as ImageProvider,
              child: Stack(
                children: [
                  if (userProfile.photoUrl == null)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();

                          if (result != null) {
                            File file = File(result.files.single.path!);
                          } else {
                            // User canceled the picker
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(username,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    )),
            Text(userProfile.email!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    )),
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
                      value: userProfile.isDriver,
                      onChanged: (newValue) {
                        setState(() {
                          userProfile.isDriver = newValue;
                          DatabaseService()
                              .toggleIsDriver(userProfile.userID!, newValue);
                        });
                      },
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey[300],
                    ),
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
