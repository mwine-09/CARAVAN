// ignore_for_file: avoid_print

// import 'dart:html';

import 'package:caravan/components/promo_card.dart';
import 'package:caravan/components/wallet_widget.dart';
import 'package:caravan/credentials.dart';
import 'package:caravan/models/user_profile.dart';
import 'package:caravan/models/wallet.dart';
import 'package:caravan/providers/notification_provider.dart';
import 'package:caravan/providers/user_profile.provider.dart';
import 'package:caravan/screens/authenticate/interim_login.dart';
import 'package:caravan/screens/more%20screens/available_trips.dart';
import 'package:caravan/screens/more%20screens/notifications.dart';
import 'package:caravan/screens/more%20screens/payments/payment_screen.dart';

import 'package:caravan/screens/more%20screens/request_sent.dart';
import 'package:caravan/services/payment_service.dart';
import 'package:caravan/services/secure_storage.dart';
import 'package:caravan/services/wallet_management.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import 'package:caravan/screens/more%20screens/notifications.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

Logger logger = Logger();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void setProvider() async {
    await Provider.of<UserProfileProvider>(context).loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    int unreadNotificationsCount =
        notificationProvider.unreadNotificationsCount;
    final TextEditingController pinController = TextEditingController();

    void savePin() async {
      String pin = pinController.text;
      if (pin.length == 4) {
        await SecureStorageService().writeSecureData('userPin', pin);
        Navigator.pop(context);
      } else {
        // Show an error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN must be 4 digits')),
        );
      }
    }

    UserProfile userProfile = context.watch<UserProfileProvider>().userProfile;
    if (userProfile.userID == null) {
      setProvider();

      return const MyLogin();
    }

    String username = userProfile.username ?? 'User';

    logger.e(
        "This is the wallet balance from the home screen: ${userProfile.wallet?.balance}");

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Hello $username !',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 1,
                ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Handle your button tap here
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationsScreen()));
                  },
                ),
                if (unreadNotificationsCount > 0)
                  Positioned(
                    right: 0,
                    top: 7,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: Center(
                        child: Text(
                          "$unreadNotificationsCount", // Replace with your dynamic value
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              WalletWidget(wallet: userProfile.wallet ?? Wallet(balance: 0.0)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyCard(
                      title: 'Trips',
                      icon: const AssetImage('assets/car.png'),
                      onTap: () {
                        // Handle tap on request for a ride
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AvailableTrips()),
                        );
                      }),
                  MyCard(
                    title: 'Schedule a trip',
                    icon: const AssetImage('assets/car.png'),
                    onTap: () {
                      // Handle tap on request for a ride
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RequestSendScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Promos',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              const Flexible(
                child: PromoCard(
                  title: "Nzuri vibes",
                  description: "Experience Kampala Lifestyle",
                  imageUrl:
                      'https://res.cloudinary.com/hz3gmuqw6/image/upload/c_fill,f_auto,q_60,w_750/v1/goldenapron/6244b2d8ab2d5',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyCard extends StatefulWidget {
  final String title;
  final AssetImage icon;
  // void function
  void Function() onTap;

  MyCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: const Color.fromARGB(255, 252, 250, 248),
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onTap,
        child: Card(
          child: Container(
            height: 140,
            // width should fit the content
            width: (MediaQuery.of(context).size.width - 50) / 2,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 36, 36, 36),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Transform.translate(
                  offset: const Offset(-30, 0),
                  child: Image(
                    image: widget.icon,
                    width: 140,
                  ),
                ),
                const SizedBox(height: 8),
                Text(widget.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
              ],
            ),
          ),
        ));
  }
}

class WalletWidget extends StatefulWidget {
  const WalletWidget({super.key, required this.wallet});
  final Wallet wallet;

  @override
  _WalletWidgetState createState() => _WalletWidgetState();
}

final _paymentService = PaymentService(
  clientId: clientId,
  secret: secret,
);

class _WalletWidgetState extends State<WalletWidget> {
  bool _isBalanceVisible = false;
  // final TextEditingController _controller = TextEditingController();
  final String _selectedCountryCode = '+256';
  final TextEditingController _phoneNumberController = TextEditingController();

  UserProfileProvider userProfileProvider = UserProfileProvider();
  final TextEditingController _amountController = TextEditingController();
  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? errorMessage;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: const Color.fromARGB(255, 36, 36, 36),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // MY WALLET text should be at the beginning of the card
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'MY WALLET',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: _toggleBalanceVisibility,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: GestureDetector(
                      onTap: () async {
                        String? storedPin = await SecureStorageService()
                            .readSecureData('userPin');

                        if (userProfileProvider.userProfile.pin == null ||
                            storedPin == null) {
                          showPinSetupBottomSheet(context, (pin) {
                            // Save the pin to the user's profile or secure storage
                            // Example:
                            userProfileProvider.userProfile.pin = pin;

                            // Or store the pin in secure storage
                            SecureStorageService()
                                .writeSecureData('userPin', pin);
                          });
// snakbar feedback
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('PIN has been set successfully')),
                          );

                          return;
                        }

                        if (!_isBalanceVisible) {
                          showPinVerificationBottomSheet(
                            context,
                            userProfileProvider.userProfile.pin,
                            _toggleBalanceVisibility,
                          );
                        }
                      },
                      child: Text(
                        _isBalanceVisible
                            ? 'UGX ${widget.wallet.balance}'
                            : 'UGX ******',
                        key: ValueKey<bool>(_isBalanceVisible),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Divider(
              color: Color.fromARGB(255, 187, 187, 187),
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                ActionCard(
                  imagePath: "assets/deposit.png",
                  label: "Deposit",
                  onPressed: () {
                    // _showDepositBottomSheet(context);
                    _showDepositBottomSheet(context);
                  },
                  imageSize: 30,
                ),
                ActionCard(
                  imagePath: "assets/withdraw-money-icon.png",
                  label: "Withdraw",
                  imageSize: 35,
                  onPressed: () {
                    _showWithdrawBottomSheet(context);
                  },
                ),
                // ActionCard(
                //   imagePath: "assets/transferIcon.png",
                //   label: "Transfer",
                //   imageSize: 30,
                //   onPressed: () {},
                // ),
                ActionCard(
                  imagePath: "assets/timesheet-icon.png",
                  label: "History",
                  imageSize: 35,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionHistoryScreen(
                                userId: FirebaseAuth.instance.currentUser!.uid,
                              )),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showDepositBottomSheet(BuildContext context) {
    bool isError = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20.0,
            left: 20.0,
            right: 20.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Deposit',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(_selectedCountryCode,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(95, 95, 95, 95),
                          labelText: "Phone number",
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        maxLength: 9,
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 1.0),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(95, 106, 106, 106),
                    labelText: "Amount",
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    errorText:
                        isError ? 'Amount must be greater than 2000' : null,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      if (double.tryParse(value) != null &&
                          double.parse(value) <= 2000) {
                        isError = true;
                      } else {
                        isError = false;
                      }
                    });
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        double amount = double.parse(_amountController.text);
                        String phonenumber =
                            '256${_phoneNumberController.text}';
                        await _paymentService.deposit(
                            amount: amount,
                            phone: phonenumber,
                            reference: "Top up",
                            reason: "Deposit to my account");

                        await _paymentService.updateWallet(amount, 'deposit');

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Deposit successful!')),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Deposit failed: $e')),
                        );
                      }
                      _amountController.clear();
                      _phoneNumberController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 0, 0, 0), // Adjust color as needed
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showWithdrawBottomSheet(BuildContext context) {
    bool isError = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Withdraw',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(_selectedCountryCode,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(95, 95, 95, 95),
                          labelText: "Phone number",
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        maxLength: 9,
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 1.0),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(95, 106, 106, 106),
                    labelText: "Amount",
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    errorText:
                        isError ? 'Amount must be greater than 2000' : null,
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      if (double.tryParse(value) != null &&
                          double.parse(value) <= 2000) {
                        isError = true;
                      } else {
                        isError = false;
                      }
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      double amount = double.parse(_amountController.text);
                      String phonenumber = '256${_phoneNumberController.text}';

                      await _paymentService.payout(
                        amount: amount,
                        phone: phonenumber,
                        reference: "Withdraw",
                      );
                      await _paymentService.updateWallet(amount, 'withdraw');

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Withdrawal successful!')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Withdrawal failed: $e')),
                      );

                      Navigator.pop(context);
                    }
                    _amountController.clear();
                    _phoneNumberController.clear();
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
