import "package:cloud_firestore/cloud_firestore.dart";

class Trip {
  final String id;
  // final String driverName;
  final String location;
  final String destination;
  final int availableSeats;
  final DateTime dateTime;

  Trip.empty()
      : id = '',
        // driverName = '',
        location = '',
        destination = '',
        availableSeats = 0,
        dateTime = DateTime.now();

  Trip({
    required this.id,
    // required this.driverName,
    required this.location,
    required this.destination,
    required this.availableSeats,
    required this.dateTime,
  });

  factory Trip.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Trip(
      id: doc.id,
      // driverName: data['driverName'],
      location: data['departure location'],
      destination: data['destination'],
      availableSeats: data['available seats'],
      dateTime: data['departure time'].toDate(),
    );
  }
}
