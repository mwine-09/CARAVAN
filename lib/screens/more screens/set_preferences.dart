import 'package:caravan/models/user_profile.dart';
import 'package:caravan/screens/more%20screens/emergency_contact.dart';
import 'package:flutter/material.dart';

class PreferencesScreen extends StatefulWidget {
  final UserProfile userProfile;
  const PreferencesScreen({super.key, required this.userProfile});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  List<String> selectedPreferences = [];

  final Map<String, List<String>> categorizedPreferences = {
    'Smoking Preferences': ['smoking', 'no smoking'],
    'Music Preferences': ['loud music', 'no music', 'low music'],
    'Route Preferences': ['fastest route', 'scenic route'],
    'Social Preferences': ['meet new people', 'local knowledge sharing'],
    'Travel Preferences': [
      'pet-friendly',
      'child-friendly',
      'eco-conscious',
      'quick stops',
      'long rides',
      'comfortable ride',
      'adventure seeker',
      'sightseeing enthusiast'
    ],
    'Personal Preferences': [
      'foodie',
      'night owl',
      'early bird',
      'tech-savvy',
      'nature lover',
      'sports fan',
      'bookworm',
      'musician',
      'artist',
      'photographer'
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Preferences',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                'Select your preferences',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Choose as many to improve your experience!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color.fromARGB(171, 255, 255, 255),
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 16),
              ...categorizedPreferences.entries.map((entry) {
                String category = entry.key;
                List<String> preferences = entry.value;
                return ExpansionTile(
                  iconColor: Colors.white,
                  // backgroundColor: Colors.white,
                  title: Text(
                    category,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color.fromARGB(255, 252, 252, 252),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  children: preferences
                      .map((preference) => GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedPreferences.contains(preference)) {
                                  selectedPreferences.remove(preference);
                                } else {
                                  selectedPreferences.add(preference);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 12),
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              decoration: BoxDecoration(
                                color: selectedPreferences.contains(preference)
                                    ? Colors.blue
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                preference,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                        color: selectedPreferences
                                                .contains(preference)
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 14),
                              ),
                            ),
                          ))
                      .toList(),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () {
          // Save selected preferences
          widget.userProfile.preferences = selectedPreferences;

          print(widget.userProfile.toString());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EmergencyContactScreen(userProfile: widget.userProfile),
            ),
          );
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            "Next",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
      backgroundColor: Colors.black, // Background color
    );
  }
}
