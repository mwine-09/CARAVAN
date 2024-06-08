import 'package:caravan/models/emergency_contact.dart';
import 'package:caravan/models/wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String? userID;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  Wallet? wallet;
  int? age;
  String? carBrand;
  String? make;
  String? numberPlate;
  String? phoneNumber;
  List<String>? preferences;
  List<EmergencyContact>? emergencyContacts;
  bool isDriver;
  String? photoUrl;

  UserProfile({
    this.userID,
    this.username,
    this.firstName,
    this.lastName,
    this.age,
    this.email,
    this.wallet,
    this.carBrand,
    this.make,
    this.numberPlate,
    this.phoneNumber,
    this.preferences,
    this.emergencyContacts,
    this.photoUrl,
    this.isDriver = false, // Default role is passenger
  });

  // to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['username'] = username;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['wallet'] = wallet?.toJson();
    data['age'] = age;
    data['carBrand'] = carBrand;
    data['photoUrl'] = photoUrl;
    data['make'] = make;
    data['isDriver'] = isDriver;
    data['numberPlate'] = numberPlate;
    data['phoneNumber'] = phoneNumber;
    data['preferences'] = preferences;
    data['emergencyContacts'] =
        emergencyContacts?.map((e) => e.toJson()).toList();

    return data;
  }

  // from snapshot
  factory UserProfile.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    Wallet? wallet;
    if (data.containsKey('wallet')) {
      wallet = Wallet.fromJson(data['wallet']);
    }
    return UserProfile(
      userID: snapshot.id,
      username: data['username'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      age: data['age'],
      wallet: wallet,
      carBrand: data['carBrand'],
      make: data['make'],
      photoUrl: data['profilePicture'],
      isDriver: data['isDriver'],
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
      'wallet': wallet?.toJson(),
      'numberPlate': numberPlate,
      'phoneNumber': phoneNumber,
      'preferences': preferences,
      'emergencyContacts': emergencyContacts?.map((e) => e.toMap()).toList(),
      'isDriver': isDriver,
      'photoUrl': photoUrl,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userID: json['userID'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      age: json['age'],
      carBrand: json['carBrand'],
      make: json['make'],
      numberPlate: json['numberPlate'],
      phoneNumber: json['phoneNumber'],
      preferences: List<String>.from(json['preferences']),
      emergencyContacts: (json['emergencyContacts'] as List<dynamic>?)
          ?.map((e) => EmergencyContact.fromJson(e))
          .toList(),
      photoUrl: json['photoUrl'],
      isDriver: json['isDriver'],
    );
  }

  @override
  String toString() {
    return 'UserProfile(userID: $userID, username: $username, firstName: $firstName, lastName: $lastName, email: $email, age: $age, carBrand: $carBrand, make: $make, numberPlate: $numberPlate, phoneNumber: $phoneNumber, preferences: $preferences, emergencyContacts: $emergencyContacts, isDriver: $isDriver, photoUrl: $photoUrl, wallet: $wallet)';
  }
}
