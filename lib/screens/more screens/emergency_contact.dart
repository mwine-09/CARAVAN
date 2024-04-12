import 'package:caravan/models/emergency_contact.dart';
import 'package:caravan/providers/user_profile.provider.dart';
import 'package:caravan/providers/user_provider.dart';
import 'package:caravan/screens/tabs/home.dart';
import 'package:caravan/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<String> relationships = <String>['Father', 'Mother', 'Sister', 'Brother'];

class EmergencyContactScreen extends StatefulWidget {
  const EmergencyContactScreen({super.key});

  @override
  _EmergencyContactScreenState createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<EmergencyContact> contacts = [];
  String _dropdownValue = relationships.first;
  static final myTextFieldStyle = InputDecoration(
    labelStyle: const TextStyle(color: Colors.black),
    labelText: 'Name',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 0, 0, 0),
        width: 2.0,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    UserProfileProvider userProfileProvider =
        Provider.of(context, listen: true);

    UserProvider userProvider = Provider.of(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Emergency Contacts',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: const Color.fromARGB(255, 12, 12, 12),
                    subtitleTextStyle: const TextStyle(fontSize: 14),
                    minVerticalPadding: 5,
                    title: Text(
                      contacts[index].name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                    ),
                    subtitle: Text(contacts[index].relationship,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            )),
                    trailing: Text(contacts[index].phoneNumber,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            )),
                  );
                },
              ),
            ),
            if (contacts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(200, 50)),
                  onPressed: () {
                    userProfileProvider.setEmergencyContacts(contacts);

                    print(userProfileProvider.toString());
                    // get the data in hte userprofile provider and insert into the database
                    DatabaseService().createUserProfile(
                        _firebaseAuth.currentUser!.uid,
                        userProfileProvider.toMap());
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  },
                  child: Text('Done',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.black, fontSize: 18)),
                ),
              ),
            const Spacer(),
            const Spacer()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () {
          if (contacts.length < 3) {
            _showAddContactDialog();
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Maximum Contacts Reached'),
                  content: const Text(
                      'You can only add up to 3 emergency contacts.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'OK',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16,
                                ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String relationship = _dropdownValue;
        String phoneNumber = '';

        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          title: const Text('Add Emergency Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: myTextFieldStyle.copyWith(),
                onChanged: (value) {
                  name = value;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              DropdownButtonFormField<String>(
                decoration:
                    myTextFieldStyle.copyWith(labelText: 'Relationship'),
                value: _dropdownValue,
                onChanged: (String? value) {
                  setState(() {
                    _dropdownValue = value!;
                  });
                },
                items:
                    relationships.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.black, fontSize: 16),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                keyboardType: TextInputType.phone,
                decoration:
                    myTextFieldStyle.copyWith(labelText: "Phone Number"),
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  contacts.add(EmergencyContact(
                    name: name,
                    relationship: relationship,
                    phoneNumber: phoneNumber,
                  ));
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Add',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(color: Colors.black, fontSize: 16),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(color: Colors.black, fontSize: 16),
                )),
          ],
        );
      },
    );
  }
}
