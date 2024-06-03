class DriverDocument {
  final String id;
  final String userId;
  final String documentName;
  final String documentUrl;
  final String status; // e.g., 'pending', 'approved', 'rejected'

  DriverDocument({
    required this.id,
    required this.userId,
    required this.documentName,
    required this.documentUrl,
    required this.status,
  });
}
