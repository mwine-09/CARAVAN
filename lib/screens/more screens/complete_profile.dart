import 'package:caravan/providers/user_profile.provider.dart';
import 'package:caravan/providers/user_provider.dart';
import 'package:caravan/screens/more%20screens/set_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

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
    UserProfileProvider userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: true);
    UserProvider userProvider = Provider.of(context, listen: true);
    String username = userProvider.getUsername();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Complete Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 320,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TextFormField(
                //   style: myInputTextStyle,
                //   controller: _usernameController,
                //   decoration: myFormtextFieldStyle.copyWith(
                //     labelText: 'Username',
                //   ),
                // ),
                Text(
                  "Hello $username",
                  style: const TextStyle(color: Colors.white),
                ),
                TextFormField(
                  style: myInputTextStyle,
                  controller: _firstNameController,
                  decoration: myFormtextFieldStyle.copyWith(
                    labelText: 'First Name',
                  ),
                ),
                TextFormField(
                  style: myInputTextStyle,
                  controller: _lastNameController,
                  decoration: myFormtextFieldStyle.copyWith(
                    labelText: 'Last Name',
                  ),
                ),
                // age field for numbers

                TextFormField(
                  style: myInputTextStyle,
                  controller: _ageController,
                  decoration: myFormtextFieldStyle.copyWith(
                    labelText: 'Age',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  style: myInputTextStyle,
                  controller: _phoneNumberController,
                  decoration: myFormtextFieldStyle.copyWith(
                    labelText: 'Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    userProfileProvider.completeProfile(
                      username: username,
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      age: int.parse(_ageController.text),
                      phoneNumber: _phoneNumberController.text,
                    );

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PreferencesScreen()));
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
