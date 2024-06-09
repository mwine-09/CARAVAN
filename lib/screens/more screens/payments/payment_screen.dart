import 'package:caravan/credentials.dart';
import 'package:caravan/models/transaction_history.dart';
import 'package:caravan/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final PaymentService _paymentService = PaymentService(
    clientId: clientId,
    secret: secret,
  );
  final String userId; // The current user ID

  TransactionHistoryScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: FutureBuilder<List<History>>(
        future: _paymentService.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load history: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No transactions found'));
          } else {
            final transactions = snapshot.data!;
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final history = transactions[index];
                return ListTile(
                  title: Text('Amount: ${history.amount}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date: ${DateFormat('yyyy-MM-dd').format(history.timestamp)}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black),
                      ),
                      Text(
                        "Time: ${DateFormat('HH:mm:ss').format(history.timestamp)}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
