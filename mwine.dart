import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_app/models/user_profile.dart'; // Import your UserProfile model
import 'package:your_app/providers/user_profile_provider.dart'; // Import your UserProfileProvider

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserProfileProvider userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: true);
    UserProfile userProfile = userProfileProvider.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Personal Information",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EditableProfileField(
              label: 'First Name',
              value: userProfile.firstName ?? '',
              onSave: (value) {
                // Handle saving the updated value
                userProfileProvider.updateFirstName(value);
              },
            ),
            EditableProfileField(
              label: 'Last Name',
              value: userProfile.lastName ?? '',
              onSave: (value) {
                // Handle saving the updated value
                userProfileProvider.updateLastName(value);
              },
            ),
            EditableProfileField(
              label: 'Age',
              value: userProfile.age?.toString() ?? '',
              onSave: (value) {
                // Handle saving the updated value
                userProfileProvider.updateAge(int.parse(value));
              },
            ),
            // Add other fields as needed
          ],
        ),
      ),
    );
  }
}

class EditableProfileField extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onSave;

  const EditableProfileField({
    super.key,
    required this.label,
    required this.value,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter $label',
            // Use the context to access the text theme
            hintStyle: Theme.of(context).textTheme.bodyMedium,
          ),
          controller: TextEditingController(text: value),
          onChanged: onSave,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
