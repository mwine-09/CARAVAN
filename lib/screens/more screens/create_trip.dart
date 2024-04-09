import 'dart:ffi';

import 'package:caravan/components/date_time_picker.dart';
import 'package:caravan/models/user.dart';
import 'package:caravan/services/auth.dart';
import 'package:caravan/services/database_service.dart';
import 'package:caravan/shared/constants/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CreateTripScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Add Trip'),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: AddTripForm(),
    );
  }
}

class AddTripForm extends StatefulWidget {
  @override
  _AddTripFormState createState() => _AddTripFormState();
}

class _AddTripFormState extends State<AddTripForm> {
  final _formKey = GlobalKey<FormState>();
  // set _driverId to the current user's ID

  String _departureLocation = '';
  String _destination = '';
  DateTime _departureTime = DateTime.now();
  int _availableSeats = 0;
  String _tripStatus = '';
  UserModel? user = AuthService().getCurrentUser();
  String _driverId = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            // create a trip
            Text(user?.username ?? 'No username'),
            TextFormField(
              style: myInputTextStyle,
              decoration:
                  myTextFieldStyle.copyWith(labelText: 'Departure Location'),
              onChanged: (value) {
                setState(() {
                  _departureLocation = value;
                  print(user?.username);
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: myInputTextStyle,
              decoration: myTextFieldStyle.copyWith(labelText: 'Destination'),
              onChanged: (value) {
                setState(() {
                  _destination = value;
                });
              },
            ),
            //  date time picker for departure time
            const DepartureTimePicker(),
            const SizedBox(height: 16),
            TextFormField(
              style: myInputTextStyle,
              decoration:
                  myTextFieldStyle.copyWith(labelText: 'Available Seats'),
              onChanged: (value) {
                _availableSeats = int.parse(value);
                // Parse the value to int and assign it to _availableSeats
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: myInputTextStyle,
              decoration: myTextFieldStyle.copyWith(labelText: 'Trip Status'),
              onChanged: (value) {
                setState(() {
                  _tripStatus = value;
                });
              },
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              onPressed: () {
                // Validate form input
                if (_formKey.currentState!.validate()) {
                  // Save the trip details to FireStore
                  _driverId = user!.uid;
                  DatabaseService().addTrip(
                      _driverId,
                      _departureLocation,
                      _destination,
                      _departureTime,
                      _availableSeats,
                      _tripStatus);
                  // Call your addTrip function here

                  // Navigator.pop(context) to go back to the previous screen
                }
              },
              child: Text('Save Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
