import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger logger = Logger();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> deposit(double amount) async {
    try {
      await _firestore.runTransaction((transaction) async {
        DocumentReference balanceRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('wallet')
            .doc('balance');

        DocumentSnapshot balanceSnapshot = await transaction.get(balanceRef);
        double currentBalance = 0.0;
        if (balanceSnapshot.exists) {
          var balanceData =
              (balanceSnapshot.data() as Map<String, dynamic>?)?['balance'];
          if (balanceData is int) {
            currentBalance = balanceData.toDouble();
          } else if (balanceData is double) {
            currentBalance = balanceData;
          }
        }

        transaction.update(balanceRef, {'balance': currentBalance + amount});

        _addTransactionHistory(transaction, 'deposit', amount);
      });
      logger.i('Deposited \$$amount successfully.');
    } catch (e) {
      logger.e('Failed to deposit: $e');
      rethrow;
    }
  }

  void _addTransactionHistory(
    Transaction transaction,
    String type,
    double amount, {
    String? recipientId,
  }) {
    DocumentReference historyRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('wallet')
        .doc('balance')
        .collection('history')
        .doc();

    Map<String, dynamic> historyData = {
      'type': type,
      'amount': amount,
      'timestamp': FieldValue.serverTimestamp(),
      'recipientId': recipientId,
    };

    transaction.set(historyRef, historyData);
  }

  Future<void> withdraw(double amount) async {
    try {
      await _firestore.runTransaction((transaction) async {
        DocumentReference balanceRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('wallet')
            .doc('balance');

        DocumentSnapshot balanceSnapshot = await transaction.get(balanceRef);
        double currentBalance = 0.0;
        if (balanceSnapshot.exists) {
          var balanceData =
              (balanceSnapshot.data() as Map<String, dynamic>?)?['balance'];
          if (balanceData is int) {
            currentBalance = balanceData.toDouble();
          } else if (balanceData is double) {
            currentBalance = balanceData;
          }
        }

        if (currentBalance < amount) {
          throw Exception('Insufficient balance');
        }

        transaction.update(balanceRef, {'balance': currentBalance - amount});

        _addTransactionHistory(transaction, 'withdraw', amount);
      });
      logger.i('Withdrawn \$$amount successfully.');
    } catch (e) {
      logger.e('Failed to withdraw: $e');
      rethrow;
    }
  }

  Future<List<History>> getHistory() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('wallet')
          .doc('balance')
          .collection('history')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => History.fromSnapshot(doc)).toList();
    } catch (e) {
      logger.e('Failed to get history: $e');
      rethrow;
    }
  }
}

class History {
  final String type;
  final double amount;
  final DateTime timestamp;
  final String? recipientId;

  History({
    required this.type,
    required this.amount,
    required this.timestamp,
    this.recipientId,
  });

  factory History.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return History(
      type: data['type'],
      amount: (data['amount'] as num).toDouble(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      recipientId: data['recipientId'],
    );
  }
}
