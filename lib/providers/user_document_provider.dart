import 'package:flutter/material.dart';

class DriverDocumentProvider with ChangeNotifier {
  bool _isDriver = false;
  bool _documentsApproved = false;
  bool _documentsSubmitted = false;

  bool get isDriver => _isDriver;
  bool get documentsApproved => _documentsApproved;
  bool get documentsSubmitted => _documentsSubmitted;

  void setDriver(bool isDriver) {
    if (isDriver && !_documentsApproved) {
      if (!_documentsSubmitted) {
        throw Exception('Please submit your documents for review.');
      } else {
        throw Exception('Your documents have not been approved yet.');
      }
    }

    _isDriver = isDriver;
    notifyListeners();
  }

  void setDocumentsApproved(bool approved) {
    _documentsApproved = approved;
    notifyListeners();
  }

  void setDocumentsSubmitted(bool submitted) {
    _documentsSubmitted = submitted;
    notifyListeners();
  }

  void reset() {
    _isDriver = false;
    _documentsApproved = false;
    _documentsSubmitted = false;
    notifyListeners();
  }
}
