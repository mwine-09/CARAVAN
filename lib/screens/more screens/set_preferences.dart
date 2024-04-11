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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  textAlign: TextAlign.center,
                  'Select your preferences',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                  // textAlign: TextAlign.start,
                  ),
              const SizedBox(
                height: 10,
              ),
              Text('Choose as many to improve your experience!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color.fromARGB(171, 255, 255, 255),
                        fontSize: 16,
                      )
                  // textAlign: TextAlign.start,
                  ),
              const SizedBox(
                height: 16,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
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
                              horizontal: 12.0, vertical: 12),
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
                                    color:
                                        selectedPreferences.contains(preference)
                                            ? Colors.white
                                            : Colors.black,
                                    fontSize: 14),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: ShapeBorder.lerp(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: Colors.white)),
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: Colors.white)),
            0.5),
        onPressed: () {
          // Save selected preferences
          userProfileProvider.preferences = selectedPreferences;

          print(userProfileProvider.toString());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EmergencyContactScreen()));
        },
        child: Text(
          "Next",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.black,
                fontSize: 18,
              ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PreferencesScreen(),
  ));
}
