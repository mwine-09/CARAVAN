import 'package:caravan/models/emergency_contact.dart';

class User {
  final String uid;
  final String? username;
  final String? firstName;
  final String? lastName;
  final int? age;
  final String? carBrand;
  final String? make;
  final String? numberPlate;
  final String? phoneNumber;
  final List<String>? preferences;
  final List<EmergencyContact>? emergencyContacts;

  User({
    required this.uid,
    this.username,
    this.firstName,
    this.lastName,
    this.age,
    this.carBrand,
    this.make,
    this.numberPlate,
    this.phoneNumber,
    this.preferences,
    this.emergencyContacts,
  });
}
