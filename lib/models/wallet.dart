import 'package:caravan/models/transaction_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class Wallet {
  double balance;
  List<History>? history;

  double get getBalance => balance;

  set setBalance(double value) {
    balance = value;
  }

  get getHistory => history;

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
    };
  }

  Wallet({
    required this.balance,
    this.history,
  });

  factory Wallet.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Safely convert balance to double
    double balanceValue = 0.0;
    if (data['balance'] is int) {
      logger.e("Value is int");
      balanceValue = (data['balance'] as int).toDouble();
    } else if (data['balance'] is double) {
      logger.e("Value is double");

      balanceValue = data['balance'];
    } else {
      print("Error from wallet parsing");
      print("Unexpected balance type: ${data['balance']?.runtimeType}");
    }

    return Wallet(
      balance: balanceValue,
      history: [], // Initially empty, will be populated later
    );
  }
}
