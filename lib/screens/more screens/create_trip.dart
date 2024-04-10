import 'package:caravan/components/date_time_picker.dart';
import 'package:caravan/models/user.dart';
import 'package:caravan/services/auth.dart';
import 'package:caravan/services/database_service.dart';
import 'package:caravan/shared/constants/text_field.dart';
import 'package:flutter/material.dart';

class CreateTripScreen extends StatelessWidget {
  const CreateTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Add Trip'),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: const AddTripForm(),
    );
  }
}

class AddTripForm extends StatefulWidget {
  const AddTripForm({Key? key}) : super(key: key);

  @override
  _AddTripFormState createState() => _AddTripFormState();
}

class _AddTripFormState extends State<AddTripForm> {
  final _formKey = GlobalKey<FormState>();
  String _departureLocation = '';
  String _destination = '';
  final DateTime _departureTime = DateTime.now();
  int _availableSeats = 0;
  String _tripStatus = '';
  UserModel? user = AuthService().getCurrentUser();
  String _driverId = '';
  String _feedback = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text(user?.username ?? 'No username'),
            TextFormField(
              style: myInputTextStyle,
              decoration:
                  myTextFieldStyle.copyWith(labelText: 'Departure Location'),
              onChanged: (value) {
                setState(() {
                  _departureLocation = value;
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
            const SizedBox(height: 16),
            const DepartureTimePicker(),
            const SizedBox(height: 16),
            TextFormField(
              style: myInputTextStyle,
              decoration:
                  myTextFieldStyle.copyWith(labelText: 'Available Seats'),
              onChanged: (value) {
                _availableSeats = int.tryParse(value) ?? 0;
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
            Text(_feedback, style: TextStyle(color: Colors.green)),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _driverId = user!.uid;
                  DatabaseService().addTrip(
                    _driverId,
                    _departureLocation,
                    _destination,
                    _departureTime,
                    _availableSeats,
                    _tripStatus,
                  );
                  setState(() {
                    _feedback = 'Trip saved successfully!';
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
