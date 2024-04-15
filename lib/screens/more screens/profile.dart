import 'package:caravan/components/editable_textfield.dart';
import 'package:caravan/models/user_profile.dart';
import 'package:caravan/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
            child: FutureBuilder(
                future: DatabaseService().getUserProfile(widget.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SpinKitChasingDots(
                            color: Color.fromARGB(255, 201, 201, 201),
                            size: 100,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Loading...',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Colors.white,
                                ),
                      ),
                    );
                  } else {
                    UserProfile userProfile = snapshot.data as UserProfile;

                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              EditableProfileField(
                                label: 'First Name',
                                value: userProfile.firstName ?? '',
                                onSave: (value) {
                                  // Handle saving the updated value
                                },
                              ),
                              EditableProfileField(
                                label: 'Last Name',
                                value: userProfile.lastName ?? '',
                                onSave: (value) {
                                  // Handle saving the updated value
                                },
                              ),
                              EditableProfileField(
                                label: 'Age',
                                value: userProfile.age?.toString() ?? '',
                                onSave: (value) {
                                  // Handle saving the updated value
                                },
                              ),
                              EditableProfileField(
                                label: 'Car Brand',
                                value: userProfile.carBrand ?? '',
                                onSave: (value) {
                                  // Handle saving the updated value
                                },
                              ),
                              EditableProfileField(
                                label: 'Make',
                                value: userProfile.make ?? '',
                                onSave: (value) {
                                  // Handle saving the updated value
                                },
                              ),
                              EditableProfileField(
                                label: 'Number Plate',
                                value: userProfile.numberPlate ?? '',
                                onSave: (value) {
                                  // Handle saving the updated value
                                },
                              ),
                              EditableProfileField(
                                label: 'Phone Number',
                                value: userProfile.phoneNumber ?? '',
                                onSave: (value) {
                                  // Handle saving the updated value
                                },
                              ),
                              if (userProfile.emergencyContacts != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Emergency Contacts:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    ...userProfile.emergencyContacts!
                                        .map((contact) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Name: ${contact.name}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium),
                                          Text(
                                              'Phone Number: ${contact.phoneNumber}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium),
                                          const Divider(),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              Text('Role: ${userProfile.role}',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ]));
                  }
                })));
  }
}
