import 'dart:io';

import 'package:caravan/models/trip.dart';
import 'package:caravan/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart' as p;

class DatabaseService {
  // create a variable that store the user
  User? user = FirebaseAuth.instance.currentUser;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new user to the "users" collection
  Future<void> addUser(
      String userId,
      String name,
      String email,
      String phoneNumber,
      String nationalId,
      String role,
      String profilePicture,
      double rating,
      bool activeStatus) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'phone number': phoneNumber,
        'national ID': nationalId,
        'role': role,
        'profile picture': profilePicture,
        'rating': rating,
        'active status': activeStatus,
      });
    } catch (e) {
      // Handle any errors
      print('Error adding user: $e');
    }
  }

  // Add a new trip to the "trips" collection
  Future<void> addTrip(Trip trip) async {
    try {
      await _firestore.collection('trips').doc().set({
        'createdBy': trip.createdBy,
        'departure location': trip.location,
        'destination': trip.destination,
        'departure time': trip.dateTime,
        'available seats': trip.availableSeats,
        'trip status': trip.tripStatus,
        'polylinePoints': trip.polylinePoints!
            .map((point) =>
                {'latitude': point.latitude, 'longitude': point.longitude})
            .toList(),
      });
    } catch (e) {
      // Handle any errors
      print('Error adding trip: $e');
    }
  }

  // fetch all trips from the "trips" collection
  // Stream<QuerySnapshot> fetchTrips() {
  //   return _firestore.collection('trips').snapshots();
  // }
  Stream<List<Trip>> fetchTrips() {
    return FirebaseFirestore.instance
        .collection('/trips')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              List<LatLng> polylinePoints = (doc['polylinePoints'] as List)
                  .map((point) => LatLng(point['latitude'], point['longitude']))
                  .toList();

              return Trip(
                id: doc.id,
                createdBy: doc['createdBy'],
                location: doc['departure location'],
                destination: doc['destination'],
                availableSeats: doc['available seats'],
                dateTime: (doc['departure time'] as Timestamp).toDate(),
                tripStatus: doc['trip status'],
                polylinePoints: polylinePoints,
              );
            }).toList());
  }

  // Add a new booking to the "bookings" collection
  Future<void> addBooking(String bookingId, String tripId, String passengerId,
      DateTime bookingTime, String bookingStatus) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).set({
        'trip ID': tripId,
        'passenger ID': passengerId,
        'booking time': bookingTime,
        'booking status': bookingStatus,
      });
    } catch (e) {
      // Handle any errors
      print('Error adding booking: $e');
    }
  }

  // Add a new payment to the "payments" collection
  Future<void> addPayment(String paymentId, String bookingId, double amount,
      String paymentMethod, DateTime paymentTime) async {
    try {
      await _firestore.collection('payments').doc(paymentId).set({
        'booking ID': bookingId,
        'amount': amount,
        'payment method': paymentMethod,
        'payment time': paymentTime,
      });
    } catch (e) {
      // Handle any errors
      print('Error adding payment: $e');
    }
  }

  // Add a new rating to the "ratings" collection
  Future<void> addRating(String ratingId, String tripId, String ratedByUserId,
      double ratingValue, String comment, DateTime dateRated) async {
    try {
      await _firestore.collection('ratings').doc(ratingId).set({
        'trip ID': tripId,
        'rated by user ID': ratedByUserId,
        'rating value': ratingValue,
        'comment': comment,
        'date rated': dateRated,
      });
    } catch (e) {
      // Handle any errors
      print('Error adding rating: $e');
    }
  }

  // Add a new wallet transaction to the "wallet_transactions" collection
  Future<void> addWalletTransaction(
      String transactionId,
      String userId,
      String transactionType,
      double amount,
      String description,
      DateTime transactionTime) async {
    try {
      await _firestore
          .collection('wallet_transactions')
          .doc(transactionId)
          .set({
        'user ID': userId,
        'transaction type': transactionType,
        'amount': amount,
        'description': description,
        'transaction time': transactionTime,
      });
    } catch (e) {
      // Handle any errors
      print('Error adding wallet transaction: $e');
    }
  }

  // Future<UserProfile> getUserProfile(String userId) async {
  //   try {
  //     DocumentSnapshot snapshot =
  //         await _firestore.collection('users').doc(userId).get();
  //     return UserProfile.fromSnapshot(snapshot);
  //   } catch (e) {
  //     print('Error getting user profile: $e');
  //     rethrow;
  //   }
  // }
  Future<UserProfile> getUserProfile(String userId) {
    print("The receiver id supplied to the getUserProfile is $userId");
    return _firestore.collection('users').doc(userId).get().then((snapshot) {
      // print("${snapshot.data()} is the snapshot data");
      return UserProfile.fromSnapshot(snapshot);
    }).catchError((e) {
      // print('Error getting user profile: $e');
      throw e;
    });
  }

  Future<bool> checkIfUserExists(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();
      return snapshot.exists;
    } catch (e) {
      print('Error checking if user exists: $e');
      rethrow;
    }
  }

  // Add a new emergency alert to the "emergency_alerts" collection
  Future<void> addEmergencyAlert(
      String alertId,
      String userId,
      DateTime alertTime,
      double latitude,
      double longitude,
      bool resolvedStatus) async {
    try {
      await _firestore.collection('emergency_alerts').doc(alertId).set({
        'user ID': userId,
        'alert time': alertTime,
        'latitude': latitude,
        'longitude': longitude,
        'resolved status': resolvedStatus,
      });
    } catch (e) {
      // Handle any errors
      print('Error adding emergency alert: $e');
    }
  }

  // Add a new emergency contact to the "emergency_contacts" collection
  Future<void> addEmergencyContact(String contactId, String userId,
      String contactName, String contactNumber, String relationship) async {
    try {
      await _firestore.collection('emergency_contacts').doc(contactId).set({
        'user ID': userId,
        'contact name': contactName,
        'contact number': contactNumber,
        'relationship': relationship,
      });
    } catch (e) {
      // Handle any errors
      print('Error adding emergency contact: $e');
    }
  }

  // add create user profile function takes userid and a map

  Future<void> createUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).set(data);
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfile(
      String uid, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('users').doc(uid).update(updatedData);

      // Update the user profile in the user provider
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // function that toggles isDriver in the database
  Future<void> toggleIsDriver(String userId, bool isDriver) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'isDriver': isDriver,
      });
    } catch (e) {
      print('Error toggling isDriver: $e');
      rethrow;
    }
  }

  Future<String> uploadImageToStorage(File file, String userID) async {
    try {
      String downloadUrl = '';
      print("Method for uploading has been called");
      String fileExtension = p.extension(file.path).replaceFirst('.', '');
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
          storage.ref().child('profile_images').child('$userID.$fileExtension');
      print("We have created a reference");
      UploadTask uploadTask = ref.putFile(file);
      print("We are waiting for the upload to complete");
      TaskSnapshot snapshot = await uploadTask;
      print("Upload completed");
      downloadUrl = await snapshot.ref.getDownloadURL();
      print("Image was uploaded successfully");
      print(downloadUrl);
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfilePicture(String userId, String imageUrl) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(userId).update({
      'profilePicture': imageUrl,
    });
  }
}
