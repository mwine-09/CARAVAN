// ignore_for_file: avoid_print

// import 'dart:html';

import 'package:caravan/providers/user_provider.dart';
import 'package:caravan/screens/authenticate/interim_login.dart';
import 'package:caravan/screens/more%20screens/all_chats.dart';
import 'package:caravan/screens/more%20screens/available_trips.dart';
import 'package:caravan/screens/more%20screens/map_view.dart';

import 'package:caravan/screens/tabs/history.dart';
// import 'package:caravan/screens/more%20screens/notifications.dart';
import 'package:caravan/screens/more%20screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ViewScreens
  final List<Widget> viewScreens = [
    const HistoryScreen(),
    const ProfileScreen(),
  ];
  late PageController _pageController;
  int currentTab = 1;

  goToTab(int page) {
    setState(() {
      currentTab = page;
    });

    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of(context, listen: true);
    String username = userProvider.getUsername();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          'Hello $username !',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 1,
              ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
              // load the notificationscreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllChats()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.power_settings_new,
                color: Colors.white, weight: 0.8),
            onPressed: () {
              // Handle settings icon press
              FirebaseAuth.instance.signOut();
// redirect to login
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyLogin()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SingleCard(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyCard(
                      title: 'View trips',
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
                    title: 'Request for a ride',
                    icon: const AssetImage('assets/car.png'),
                    onTap: () {
                      // Handle tap on request for a ride
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GoogleMapsView()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My previous trips',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: 380,
                  height: 100,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      // generate 3 blank cards with a height 50 and the same width
                      Flexible(
                        child: Container(
                          // height: 100,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 20, 20, 20),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Container(
                          // height: 100,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 20, 20, 20),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Container(
                          // height: 100,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 20, 20, 20),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
            height: 150,
            // width should fit the content
            width: (MediaQuery.of(context).size.width - 50) / 2,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 20, 20, 20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Transform.translate(
                  offset: const Offset(-30, 0),
                  child: Image(
                    image: widget.icon,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 10),
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

class SingleCard extends StatelessWidget {
  const SingleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: const Color.fromARGB(255, 20, 20, 20),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'UGX ********',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2),
            ),
            // const SizedBox(height: 20),

            const Divider(
              color: Colors.white,
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            const SizedBox(height: 20),

            // add a flat button
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // add a money icon
                  const Icon(
                    Icons.money_rounded,
                    color: Colors.black,
                  ),
                  Text(
                    'DEPOSIT MONEY',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
