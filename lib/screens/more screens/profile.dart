import 'package:caravan/components/editable_textfield.dart';
import 'package:caravan/models/user_profile.dart';
import 'package:caravan/providers/user_profile.provider.dart';
import 'package:caravan/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProfileProvider userProfileProvider =
        Provider.of(context, listen: true);
    UserProfile userProfile = userProfileProvider.userProfile;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit personal information",
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
                // userProfileProvider.updateFirstName(value);
              },
            ),
            EditableProfileField(
              label: 'Last Name',
              value: userProfile.lastName ?? '',
              onSave: (value) {
                // Handle saving the updated value
                // userProfileProvider.updateLastName(value);
              },
            ),
            EditableProfileField(
              label: 'Age',
              value: userProfile.age?.toString() ?? '',
              onSave: (value) {
                // Handle saving the updated value
                // userProfileProvider.updateAge(int.parse(value));
              },
            ),
            // Add other fields as needed
          ],
        ),
      ),
    );
  }
}
