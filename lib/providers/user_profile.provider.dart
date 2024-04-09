import 'package:caravan/models/emergency_contact.dart';
import 'package:flutter/foundation.dart';

class UserProfileProvider with ChangeNotifier {
  String? username;
  String? firstName;
  String? lastName;
  int? age;
  String? carBrand;
  String? make;
  String? numberPlate;
  String? phoneNumber;
  List<String>? preferences;
  List<EmergencyContact>? emergencyContacts;

  // Add your methods and logic here

  // set emergency contacts
  void setEmergencyContacts(List<EmergencyContact> contacts) {
    emergencyContacts = contacts;
    notifyListeners();
  }

// get user profile function
  UserProfileProvider({
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

    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'carBrand': carBrand,
      'make': make,
      'numberPlate': numberPlate,
      'phoneNumber': phoneNumber,
      'preferences': preferences,
      'emergencyContacts': emergencyContacts?.map((e) => e.toJson()).toList(),
    };
  }

  void completeProfile({
    required String username,
    required String firstName,
    required String lastName,
    required int age,
    required String phoneNumber,
  }) {
    this.username = username;
    this.firstName = firstName;
    this.lastName = lastName;
    this.age = age;
    this.phoneNumber = phoneNumber;

    notifyListeners();
  }
}
