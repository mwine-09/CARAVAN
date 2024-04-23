import 'package:caravan/models/user_profile.dart';

class Trip {
  String id;
  String location;
  String destination;
  int availableSeats;
  DateTime dateTime;
  String tripStatus;
  UserProfile? createdBy;
  String driverID;

  Trip.empty()
      : id = '',
        createdBy = UserProfile(),
        location = '',
        destination = '',
        tripStatus = '',
        availableSeats = 0,
        driverID = '',
        dateTime = DateTime.now();

  Trip({
    required this.id,
    this.createdBy,
    required this.location,
    required this.destination,
    required this.availableSeats,
    required this.dateTime,
    required this.tripStatus,
    required this.driverID,
  });
}
