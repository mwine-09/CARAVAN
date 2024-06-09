import 'package:caravan/models/transaction_history.dart';

class Wallet {
  double balance;
  List<History>? history;

  Wallet({required this.balance});

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

  Wallet.fromJson(Map<String, dynamic> json) : balance = json['balance'];
}
