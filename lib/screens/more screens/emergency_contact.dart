import 'package:caravan/models/emergency_contact.dart';
import 'package:caravan/providers/user_profile.provider.dart';
import 'package:caravan/providers/user_provider.dart';
import 'package:caravan/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<String> relationships = <String>['Father', 'Mother', 'Sister', 'Brother'];

class EmergencyContactScreen extends StatefulWidget {
  const EmergencyContactScreen({super.key});

  @override
  _EmergencyContactScreenState createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
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
        color: Color.fromARGB(255, 122, 17, 17),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  subtitleTextStyle: const TextStyle(fontSize: 14),
                  title: Text(
                    contacts[index].name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    contacts[index].relationship,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  trailing: Text(
                    contacts[index].phoneNumber,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                );
              },
            ),
          ),
          if (contacts.isNotEmpty)
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  userProfileProvider.setEmergencyContacts(contacts);
                  // get the data in hte userprofile provider and insert into the database
                  DatabaseService().createUserProfile(
                      userProvider.getUid(), userProfileProvider.toMap());

                  Navigator.pushNamed(context, '/home');
                },
                child: const SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Finish"),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
          const Spacer()
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
                      child: const Text('OK'),
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
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
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
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
