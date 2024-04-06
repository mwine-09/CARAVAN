import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
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
  Future<void> addTrip(
      String tripId,
      String driverId,
      String departureLocation,
      String destination,
      DateTime departureTime,
      int availableSeats,
      String tripStatus) async {
    try {
      await _firestore.collection('trips').doc(tripId).set({
        'driver ID': driverId,
        'departure location': departureLocation,
        'destination': destination,
        'departure time': departureTime,
        'available seats': availableSeats,
        'trip status': tripStatus,
      });
    } catch (e) {
      // Handle any errors
      print('Error adding trip: $e');
    }
  }

  // fetch all trips from the "trips" collection
  Stream<QuerySnapshot> fetchTrips() {
    return _firestore.collection('trips').snapshots();
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

  // Add a new message to the "messages" collection
  Future<void> addMessage(String messageId, String senderId, String receiverId,
      String messageContent, String messageType, DateTime timestamp) async {
    try {
      await _firestore.collection('messages').doc(messageId).set({
        'sender ID': senderId,
        'receiver ID': receiverId,
        'message content': messageContent,
        'message type': messageType,
        'timestamp': timestamp,
      });
    } catch (e) {
      // Handle any errors
      print('Error adding message: $e');
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
}
