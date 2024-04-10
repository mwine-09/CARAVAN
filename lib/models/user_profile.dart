import 'package:caravan/models/emergency_contact.dart';

class UserProfile {
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
  final String role;

  UserProfile({
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
    this.role = 'passenger', // Default role is passenger
  });

  // to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['age'] = age;
    data['carBrand'] = carBrand;
    data['make'] = make;
    data['numberPlate'] = numberPlate;
    data['phoneNumber'] = phoneNumber;
    data['preferences'] = preferences;
    data['emergencyContacts'] =
        emergencyContacts?.map((e) => e.toJson()).toList();
    data['role'] = role; // Include role in JSON

    return data;
  }
}
