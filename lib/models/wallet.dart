class Wallet {
  double _balance;

  Wallet(this._balance);

  double get balance => _balance;

  set balance(double value) {
    _balance = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': _balance,
    };
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(json['balance']);
  }
}
