class Trip {
  final String id;
  final String location;
  final String destination;
  final int availableSeats;
  final DateTime dateTime;
  final String tripStatus;
  final String driverID;

  Trip.empty()
      : id = '',
        driverID = '',
        location = '',
        destination = '',
        tripStatus = '',
        availableSeats = 0,
        dateTime = DateTime.now();

  Trip({
    required this.id,
    required this.driverID,
    required this.location,
    required this.destination,
    required this.availableSeats,
    required this.dateTime,
    required this.tripStatus,
  });
}
