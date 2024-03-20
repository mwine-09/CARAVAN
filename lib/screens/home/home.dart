// ignore_for_file: avoid_print

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
      appBar: AppBar(
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            // Handle menu icon press
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[850],
        title: const Text('Hello John Doe!',
            style: TextStyle(
                color: Color.fromARGB(255, 254, 254, 254),
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigator.pop(context);
              // Handle notifications icon press
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyCard(
                  'Create a trip',
                  AssetImage('assets/car.png'),
                ),
                MyCard(
                  'Request for a ride',
                  AssetImage('assets/car.png'),
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
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
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

class MyCard extends StatelessWidget {
  final String title;
  final AssetImage icon;
  const MyCard(this.title, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Card(
      child: Container(
        height: 150,
        // width should fit the content
        width: (MediaQuery.of(context).size.width - 50) / 2,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Transform.translate(
              offset: const Offset(-30, 0),
              child: Image(
                image: icon,
                height: 100,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
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
      color: Colors.grey[850],
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
