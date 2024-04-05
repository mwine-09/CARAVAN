import 'dart:ffi';

import 'package:caravan/components/date_time_picker.dart';
import 'package:caravan/models/user.dart';
import 'package:caravan/services/auth.dart';
import 'package:caravan/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CreateTripScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Trip'),
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
  BaseUser? user = AuthService().getCurrentUser();
  String _driverId = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Departure Location'),
              onChanged: (value) {
                setState(() {
                  _departureLocation = value;
                  print(user!.name);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Destination'),
              onChanged: (value) {
                setState(() {
                  _destination = value;
                });
              },
            ),
            //  date time picker for departure time
            DepartureTimePicker(),

            TextFormField(
              decoration: InputDecoration(labelText: 'Available Seats'),
              onChanged: (value) {
                _availableSeats = int.parse(value);
                // Parse the value to int and assign it to _availableSeats
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Trip Status'),
              onChanged: (value) {
                setState(() {
                  _tripStatus = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Validate form input
                if (_formKey.currentState!.validate()) {
                  // Save the trip details to FireStore
                  _driverId = user!.uid;
                  DatabaseService().addTrip(
                      'tripId',
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
