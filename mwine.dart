import 'package:flutter/material.dart';
import 'package:caravan/models/user_profile.dart';

class SelectedDriverScreen extends StatelessWidget {
  final UserProfile userProfile;

  const SelectedDriverScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: ${userProfile.username}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Name: ${userProfile.firstName} ${userProfile.lastName}'),
            const SizedBox(height: 8),
            Text('Age: ${userProfile.age}'),
            const SizedBox(height: 8),
            Text('Car Brand: ${userProfile.carBrand}'),
            const SizedBox(height: 8),
            Text('Make: ${userProfile.make}'),
            const SizedBox(height: 8),
            Text('Number Plate: ${userProfile.numberPlate}'),
            const SizedBox(height: 8),
            Text('Phone Number: ${userProfile.phoneNumber}'),
            const SizedBox(height: 8),
            Text('Preferences: ${userProfile.preferences?.join(', ')}'),
            const SizedBox(height: 8),
            const Text('Emergency Contacts:'),
            Column(
              children: userProfile.emergencyContacts?.map((contact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${contact.name}'),
                        Text('Phone Number: ${contact.phoneNumber}'),
                        const Divider(),
                      ],
                    );
                  }).toList() ??
                  [],
            ),
          ],
        ),
      ),
    );
  }
}
