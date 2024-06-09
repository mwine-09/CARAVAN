import 'dart:math';

import 'package:caravan/models/transaction_history.dart';
import 'package:caravan/services/easy_pay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class PaymentService {
  final EasypayService easypayService;
  final Logger logger = Logger();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PaymentService({
    required String clientId,
    required String secret,
  }) : easypayService = EasypayService(clientId: clientId, secret: secret);

  Future<void> deposit({
    required double amount,
    required String phone,
    required String reference,
    required String reason,
  }) async {
    try {
      await easypayService.mmDeposit(
        amount: amount,
        phone: phone,
        reference: generateReference(),
        reason: reason,
      );
      logger.i('Deposit successful');
    } catch (e) {
      logger.e('Deposit failed: $e');
      rethrow;
    }
  }

  Future<void> payout({
    required double amount,
    required String phone,
    required String reference,
  }) async {
    try {
      await easypayService.mmPayout(
        amount: amount,
        phone: phone,
        reference: generateReference(),
      );
      logger.i('Payout successful');
    } catch (e) {
      logger.e('Payout failed: $e');
      rethrow;
    }
  }

  Future<double> checkBalance() async {
    try {
      final balanceData = await easypayService.checkBalance();
      final balance = balanceData['data'];
      logger.i('Balance: $balance');
      return balance;
    } catch (e) {
      logger.e('Balance check failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkTransactionStatus(String reference) async {
    try {
      final statusData = await easypayService.mmStatus(reference);
      logger.i('Transaction status: $statusData');
      return statusData;
    } catch (e) {
      logger.e('Transaction status check failed: $e');
      rethrow;
    }
  }

//functions to make changes to the

// function to update the users wallet incase of a withdraw or deposit

  Future<void> updateWallet(double amount, String action) async {
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

        if (action == 'deposit') {
          transaction.update(balanceRef, {'balance': currentBalance + amount});
        } else if (action == 'withdraw') {
          transaction.update(balanceRef, {'balance': currentBalance - amount});
        } else {
          throw Exception('Invalid action type');
        }

        _addTransactionHistory(transaction, action, amount);
      });
      logger.i('Wallet updated successfully.');
    } catch (e) {
      logger.e('Failed to update wallet: $e');
      rethrow;
    }
  }

  String generateReference() {
    // Generate a random alphanumeric string of length 10
    const characters =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random random = Random();
    String reference = '';
    for (int i = 0; i < 10; i++) {
      reference += characters[random.nextInt(characters.length)];
    }
    return reference;
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
