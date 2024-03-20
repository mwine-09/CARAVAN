// ignore_for_file: avoid_print

import 'package:caravan/screens/create_trip.dart';
import 'package:caravan/screens/history.dart';
import 'package:caravan/screens/notifications.dart';
import 'package:caravan/screens/profile.dart';
import 'package:caravan/screens/request_trip.dart';
import 'package:caravan/screens/trip_details.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor:
            Colors.white, // Color of the selected item icon and text
        unselectedItemColor:
            Colors.grey[400], // Color of the unselected items' icons and text
        selectedLabelStyle: const TextStyle(
            color: Colors.white), // Color of the selected item text
        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
              break;
            case 1:
              // Navigate to ProfileScreen

              break;
            case 2:
              // Navigate to HistoryScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              color: Colors.white,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              color: Colors.white,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: 'Profile',
            backgroundColor: Colors.white,
          ),
        ],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Hello John Doe!',
          style: TextStyle(
            color: Color.fromARGB(255, 254, 254, 254),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),

          maxLines: 1,
          // show all the text
          // increase the width of the text
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
                MaterialPageRoute(
                    builder: (context) => const NotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Handle settings icon press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SingleCard(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyCard(
                    title: 'create a trip',
                    icon: const AssetImage('assets/car.png'),
                    onTap: () {
                      // Handle tap on request for a ride
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateTripScreen()),
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
                          builder: (context) => const TripDetailsScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My previous trips',
                style: TextStyle(
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  // generate 3 blank cards with a height 50 and the same width
                  Flexible(
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 20, 20, 20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 20, 20, 20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 20, 20, 20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            )

            // Image(image: AssetImage('assets/car.png')),
          ],
        ),
      ),
    );
  }
}

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
                Text(
                  widget.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
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
      color: const Color.fromARGB(255, 20, 20, 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // MY WALLET text should be at the beginning of the card
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'MY WALLET',
                style: TextStyle(
                    letterSpacing: 1.5,
                    color: Color.fromARGB(255, 254, 254, 254),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'UGX ********',
              style: TextStyle(
                  color: Color.fromARGB(255, 254, 254, 254),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const Divider(
              color: Colors.white,
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            const SizedBox(height: 20),

            // add a flat button

            //  add a text button with a white background
            TextButton(
              onPressed: null,
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // add a money icon
                  Icon(
                    Icons.money_rounded,
                    color: Colors.black,
                  ),
                  Text(
                    'DEPOSIT MONEY',
                    style: TextStyle(
                        letterSpacing: 1,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
