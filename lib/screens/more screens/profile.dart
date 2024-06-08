import 'package:caravan/components/editable_textfield.dart';
import 'package:caravan/models/user_profile.dart';
import 'package:caravan/providers/user_profile.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;

  void _toggleEditing(bool editing) {
    setState(() {
      isEditing = editing;
    });
  }

  void _cancelEditing() {
    setState(() {
      isEditing = false;
    });
    // Handle discarding changes
    // You might want to reload the original user profile details here
  }

  void _saveChanges(UserProfileProvider userProfileProvider) {
    setState(() {
      isEditing = false;
    });
    // Handle saving changes
    // userProfileProvider.saveChanges();
  }

  @override
  Widget build(BuildContext context) {
    UserProfileProvider userProfileProvider =
        Provider.of(context, listen: true);
    UserProfile userProfile = userProfileProvider.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal Information",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: isEditing
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: isEditing
            ? [
                TextButton(
                  onPressed: _cancelEditing,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => _saveChanges(userProfileProvider),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EditableProfileField(
              label: 'Username',
              value: userProfile.username ?? '',
              onSave: (value) {
                // userProfileProvider.updateAge(int.parse(value));
                _toggleEditing(false);
              },
            ),
            GestureDetector(
              onTap: () {
                _toggleEditing(true);
              },
              child: EditableProfileField(
                label: 'First Name',
                value: userProfile.firstName ?? '',
                onSave: (value) {
                  // userProfileProvider.updateFirstName(value);
                  _toggleEditing(false);
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                _toggleEditing(true);
              },
              child: EditableProfileField(
                label: 'Last Name',
                value: userProfile.lastName ?? '',
                onSave: (value) {
                  // userProfileProvider.updateLastName(value);
                  _toggleEditing(false);
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                _toggleEditing(true);
              },
              child: EditableProfileField(
                label: 'Age',
                value: userProfile.age?.toString() ?? '',
                onSave: (value) {
                  // userProfileProvider.updateAge(int.parse(value));
                  _toggleEditing(false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
