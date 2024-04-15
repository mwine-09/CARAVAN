import 'package:caravan/models/emergency_contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String? userID;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  int? age;
  String? carBrand;
  String? make;
  String? numberPlate;
  String? phoneNumber;
  List<String>? preferences;
  List<EmergencyContact>? emergencyContacts;
  String role;
  String? photoUrl;

  UserProfile({
    this.userID,
    this.username,
    this.firstName,
    this.lastName,
    this.age,
    this.email,
    this.carBrand,
    this.make,
    this.numberPlate,
    this.phoneNumber,
    this.preferences,
    this.emergencyContacts,
    this.photoUrl,
    this.role = 'passenger', // Default role is passenger
  });

  // to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['username'] = username;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['age'] = age;
    data['carBrand'] = carBrand;
    data['photoUrl'] = photoUrl;
    data['make'] = make;
    data['numberPlate'] = numberPlate;
    data['phoneNumber'] = phoneNumber;
    data['preferences'] = preferences;
    data['emergencyContacts'] =
        emergencyContacts?.map((e) => e.toJson()).toList();
    data['role'] = role; // Include role in JSON

    return data;
  }

  // from snapshot
  factory UserProfile.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserProfile(
      userID: snapshot.id,
      username: data['username'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      age: data['age'],
      carBrand: data['carBrand'],
      make: data['make'],
      photoUrl: data['photoUrl'],
      role: data['role'],
      numberPlate: data['numberPlate'],
      phoneNumber: data['phoneNumber'],
      preferences: List<String>.from(data['preferences']),
      emergencyContacts: (data['emergencyContacts'] as List<dynamic>?)
          ?.map((e) => EmergencyContact.fromMap(e))
          .toList(),
    );
  }

  // create a function, completeProfile that will take the given arguments and set them to model and leave other to be null
  void completeProfile({
    String? userID,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    int? age,
    String? carBrand,
    String? make,
    String? numberPlate,
    String? phoneNumber,
    List<String>? preferences,
    List<EmergencyContact>? emergencyContacts,
    String? photoUrl,
    String? role,
  }) {
    if (userID != null) this.userID = userID;
    if (username != null) this.username = username;
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = lastName;
    if (age != null) this.age = age;
    if (email != null) this.email = email;
    if (carBrand != null) this.carBrand = carBrand;
    if (make != null) this.make = make;
    if (numberPlate != null) this.numberPlate = numberPlate;
    if (phoneNumber != null) this.phoneNumber = phoneNumber;
    if (preferences != null) this.preferences = preferences;
    if (emergencyContacts != null) this.emergencyContacts = emergencyContacts;
    if (photoUrl != null) this.photoUrl = photoUrl;
    if (role != null) this.role = role;
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'age': age,
      'carBrand': carBrand,
      'make': make,
      'numberPlate': numberPlate,
      'phoneNumber': phoneNumber,
      'preferences': preferences,
      'emergencyContacts': emergencyContacts?.map((e) => e.toMap()).toList(),
      'role': role,
      'photoUrl': photoUrl,
    };
  }

  @override
  String toString() {
    return 'UserProfile(userID: $userID, username: $username, firstName: $firstName, lastName: $lastName, email: $email, age: $age, carBrand: $carBrand, make: $make, numberPlate: $numberPlate, phoneNumber: $phoneNumber, preferences: $preferences, emergencyContacts: $emergencyContacts, role: $role, photoUrl: $photoUrl)';
  }
}
