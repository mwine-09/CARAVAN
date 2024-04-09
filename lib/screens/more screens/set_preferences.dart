import 'package:caravan/providers/user_profile.provider.dart';
import 'package:caravan/screens/more%20screens/emergency_contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@override
class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  List<String> selectedPreferences = [];

  List<String> preferences = [
    'smoking',
    'no smoking',
    'loud music',
    'no music',
    'low music',
    'fastest route',
    'scenic route',
    'meet new people',
    'pet-friendly',
    'child-friendly',
    'eco-conscious',
    'quick stops',
    'long rides',
    'local knowledge sharing',
    'comfortable ride',
    'adventure seeker',
    'foodie',
    'sightseeing enthusiast',
    'night owl',
    'early bird',
    'tech-savvy',
    'nature lover',
    'sports fan',
    'bookworm',
    'musician',
    'artist',
    'photographer',
  ];

  @override
  Widget build(BuildContext context) {
    UserProfileProvider userProfileProvider =
        Provider.of(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Preferences',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your preferences',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              // textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Select as many as you can to improve your experience',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 214, 214, 214),
              ),
              // textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 16,
            ),
            Wrap(
              spacing: 10,
              runSpacing: 25,
              children: preferences
                  .map(
                    (preference) => GestureDetector(
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
                            horizontal: 12.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: selectedPreferences.contains(preference)
                              ? Colors.blue
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          preference,
                          style: TextStyle(
                            color: selectedPreferences.contains(preference)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save selected preferences
          userProfileProvider.preferences = selectedPreferences;

          print(selectedPreferences);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EmergencyContactScreen()));
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PreferencesScreen(),
  ));
}
