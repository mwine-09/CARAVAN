import 'package:flutter/material.dart';
import 'package:caravan/models/user_profile.dart';

class SelectedDriverScreen extends StatelessWidget {
  final UserProfile userProfile;

  final TextStyle myTextStyle =
      const TextStyle(fontSize: 16, color: Colors.white);

  const SelectedDriverScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            userProfile.username ?? 'Driver',
            style: const TextStyle(color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userProfile.firstName != null)
              Text('First Name: ${userProfile.firstName}', style: myTextStyle),
            if (userProfile.lastName != null)
              Text('Last Name: ${userProfile.lastName}', style: myTextStyle),
            if (userProfile.age != null)
              Text('Age: ${userProfile.age}', style: myTextStyle),
            if (userProfile.carBrand != null)
              Text('Car Brand: ${userProfile.carBrand}'),
            if (userProfile.make != null)
              Text('Make: ${userProfile.make}', style: myTextStyle),
            if (userProfile.numberPlate != null)
              Text('Number Plate: ${userProfile.numberPlate}',
                  style: myTextStyle),
            if (userProfile.phoneNumber != null)
              Text('Phone Number: ${userProfile.phoneNumber}',
                  style: myTextStyle),
            if (userProfile.preferences != null)
              Text('Preferences: ${userProfile.preferences}',
                  style: myTextStyle),
            if (userProfile.emergencyContacts != null)
              Column(
                children: userProfile.emergencyContacts?.map((contact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${contact.name}', style: myTextStyle),
                          Text('Phone Number: ${contact.phoneNumber}',
                              style: myTextStyle),
                          const Divider(),
                        ],
                      );
                    }).toList() ??
                    [],
              ),
            Text('Driver: ${userProfile.isDriver}', style: myTextStyle),
          ],
        ),
      ),
    );
  }
}
