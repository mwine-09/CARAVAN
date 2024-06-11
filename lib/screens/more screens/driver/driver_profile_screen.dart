import 'package:caravan/models/emergency_contact.dart';
import 'package:caravan/models/trip.dart';
import 'package:caravan/models/user_profile.dart';
import 'package:caravan/models/wallet.dart';
import 'package:caravan/providers/trips_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriverProfileScreen extends StatefulWidget {
  final String tripId;
  const DriverProfileScreen({super.key, required this.tripId});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  late TripDetailsProvider tripProvider;

  @override
  Widget build(BuildContext context) {
    tripProvider = Provider.of<TripDetailsProvider>(context);
    Trip trip = tripProvider.availableTrips
        .firstWhere((trip) => trip.id == widget.tripId);
    UserProfile driver = trip.driver!;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('${driver.username ?? 'Driver'}\'s Profile',
            style: const TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/background_image.png'), // Add your background image here
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay with some transparency
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: driver.photoUrl != null
                      ? NetworkImage(driver.photoUrl!)
                      : const AssetImage('assets/default_avatar.png')
                          as ImageProvider,
                ),
                const SizedBox(height: 20),
                Text(
                  '${driver.firstName} ${driver.lastName}',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  driver.email ?? 'No email provided',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                buildProfileField('Car Brand', driver.carBrand),
                buildProfileField('Car Make', driver.make),
                buildProfileField('Number Plate', driver.numberPlate),
                buildProfileField('Phone Number', driver.phoneNumber),
                buildProfileField('Age', driver.age?.toString()),
                buildProfileField(
                    'Preferences', driver.preferences?.join(', ')),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),
          Expanded(
            child: Text(
              value ?? 'Not provided',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
