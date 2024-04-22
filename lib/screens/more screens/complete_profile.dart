import 'package:caravan/models/user_profile.dart';

import 'package:caravan/screens/more%20screens/set_preferences.dart';
import 'package:flutter/material.dart';

class CompleteProfile extends StatefulWidget {
  final UserProfile userProfile;
  const CompleteProfile({super.key, required this.userProfile});

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _carBrandController = TextEditingController();
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _numberPlateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _preferencesController = TextEditingController();
  final TextEditingController _emergencyContactsController =
      TextEditingController();

  static const myFormtextFieldStyle = InputDecoration(
    labelStyle: TextStyle(color: Colors.white),
    filled: false,
    // fillColor: Color.fromARGB(255, 199, 199, 199),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      gapPadding: 10,
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      gapPadding: 10,
      borderSide: BorderSide(color: Colors.white),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  );

  static const myInputTextStyle = TextStyle(
    color: Colors.white,
    overflow: TextOverflow.ellipsis,
  );

  @override
  void dispose() {
    // _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _carBrandController.dispose();
    _makeController.dispose();
    _numberPlateController.dispose();
    _phoneNumberController.dispose();
    _preferencesController.dispose();
    _emergencyContactsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complete Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: IconButtonTheme(
          data: const IconButtonThemeData(),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 320,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello ${widget.userProfile.username}, Complete your profile to continue!",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          // letterSpacing: 1.5,
                        ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    style: myInputTextStyle,
                    cursorColor: Colors.white,
                    controller: _firstNameController,
                    decoration: myFormtextFieldStyle.copyWith(
                      labelText: 'First Name',
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    style: myInputTextStyle,
                    cursorColor: Colors.white,
                    controller: _lastNameController,
                    decoration: myFormtextFieldStyle.copyWith(
                      labelText: 'Last Name',
                    ),
                  ),
                  // age field for numbers
                  const SizedBox(height: 20),

                  TextFormField(
                    style: myInputTextStyle,
                    cursorColor: Colors.white,
                    controller: _ageController,
                    decoration: myFormtextFieldStyle.copyWith(
                      labelText: 'Age',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    style: myInputTextStyle,
                    cursorColor: Colors.white,
                    controller: _phoneNumberController,
                    decoration: myFormtextFieldStyle.copyWith(
                      labelText: 'Phone Number',
                    ),
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        minimumSize: const Size(280, 50)),
                    onPressed: () {
                      // widget.userProfile.firstName = _firstNameController.text;
                      // widget.userProfile.lastName = _lastNameController.text;
                      // widget.userProfile.age = int.parse(_ageController.text);
                      // widget.userProfile.phoneNumber =
                      //     _phoneNumberController.text;
                      widget.userProfile.completeProfile(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        age: int.parse(_ageController.text),
                        phoneNumber: _phoneNumberController.text,
                        // carBrand: _carBrandController.text,
                        // make: _makeController.text,
                        // numberPlate: _numberPlateController.text,
                        // preferences: _preferencesController.text,
                        // emergencyContacts: _emergencyContactsController.text,
                      );

                      print(widget.userProfile.toJson());

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreferencesScreen(
                                  userProfile: widget.userProfile)));
                    },
                    child: Text('Next',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: Colors.black, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
