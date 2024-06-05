import 'package:caravan/components/date_time_picker.dart';
import 'package:caravan/models/trip.dart';
import 'package:caravan/screens/more%20screens/available_trips.dart';
import 'package:caravan/services/auth.dart';
import 'package:caravan/services/database_service.dart';
import 'package:caravan/shared/constants/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateTripScreen extends StatelessWidget {
  final Trip tripdetails;
  const CreateTripScreen({super.key, required this.tripdetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Create Trip',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                )),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: AddTripForm(tripdetails: tripdetails),
    );
  }
}

class AddTripForm extends StatefulWidget {
  final Trip tripdetails;
  const AddTripForm({super.key, required this.tripdetails});

  @override
  _AddTripFormState createState() => _AddTripFormState();
}

class _AddTripFormState extends State<AddTripForm> {
  final _formKey = GlobalKey<FormState>();

  User user = AuthService().getCurrentUser();

  String _feedback = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              style: myInputTextStyle,
              decoration:
                  myTextFieldStyle.copyWith(labelText: 'Departure Location'),
              controller:
                  TextEditingController(text: widget.tripdetails.location),
              enabled: false,
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: myInputTextStyle,
              decoration: myTextFieldStyle.copyWith(labelText: 'Destination'),
              controller:
                  TextEditingController(text: widget.tripdetails.destination),
              enabled: false,
            ),
            const SizedBox(height: 16),
            DepartureTimePicker(
              onChanged: (value) {
                widget.tripdetails.dateTime = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              cursorColor: Colors.white,
              keyboardType: TextInputType.number,
              style: myInputTextStyle,
              decoration:
                  myTextFieldStyle.copyWith(labelText: 'Available Seats'),
              onChanged: (value) {
                widget.tripdetails.availableSeats = int.tryParse(value) ?? 0;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  minimumSize: const Size(280, 50)),
              onPressed: () async {
                widget.tripdetails.tripStatus = TripStatus.scheduled;
                if (_formKey.currentState!.validate()) {
                  widget.tripdetails.createdBy = user.uid;

                  try {
                    await DatabaseService().addTrip(widget.tripdetails);

                    setState(() {
                      _feedback = 'Trip saved successfully!';
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        _feedback,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                      ),
                    ));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AvailableTrips()),
                    );
                  } catch (e) {
                    setState(() {
                      _feedback = "Failed to save trip!";
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        _feedback,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                      ),
                    ));
                  }
                } else {
                  setState(() {
                    _feedback = "Please correct the errors in the form.";
                  });

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      _feedback,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                    ),
                  ));
                }
              },
              child: Text('Post Trip',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.black, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
