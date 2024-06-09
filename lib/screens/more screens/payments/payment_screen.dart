import 'package:caravan/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final PaymentService _paymentService = PaymentService();
  late Future<List<History>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _paymentService.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text("Transaction History",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
      ),
      body: FutureBuilder<List<History>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No transaction history available',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )));
          }

          final historyList = snapshot.data!;
          final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
          final DateFormat timeFormat = DateFormat('HH:mm:ss');

          return Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 34, 34, 34),
              ),
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  final history = historyList[index];
                  final String formattedDate =
                      dateFormat.format(history.timestamp);
                  final String formattedTime =
                      timeFormat.format(history.timestamp);
                  return Card(
                    color: const Color.fromARGB(255, 40, 40, 40),
                    shadowColor: const Color.fromARGB(255, 0, 0, 0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                        title: Text(
                          history.type[0].toUpperCase() +
                              history.type.substring(1),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date: $formattedDate",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                            Text(
                              "Time: $formattedTime",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          "Amount: ${history.amount} UGX",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white),
                        )),
                  );
                },
              ));
        },
      ),
    );
  }
}
