import 'package:caravan/screens/more%20screens/trip_details.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AvailableTrips extends StatelessWidget {
  const AvailableTrips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      appBar: AppBar(
        title: const Text(
          'Available Trips',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        // back icon
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Expanded(
            child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('/trips').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final notifications = snapshot.data?.docs;
              return ListView.builder(
                itemCount: notifications?.length,
                itemBuilder: (context, index) {
                  final notification = notifications?[index].data();
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          color: Color.fromARGB(255, 255, 255, 255),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 10),
                                      //  rectangle image
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/default_profile.jpg'),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Destination:" +
                                                  (notification as Map<String,
                                                      dynamic>)['destination'],
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                                "PickUp: " +
                                                    (notification as Map<String,
                                                            dynamic>)[
                                                        'departure location'],
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            SizedBox(height: 5),
                                            Text(
                                              "Date: ${DateFormat.yMMMMd().format((notification as Map<String, dynamic>)['departure time'].toDate())}",
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              "Time: ${DateFormat.jm().format((notification as Map<String, dynamic>)['departure time'].toDate())}",
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ]),
                                    ]),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TripDetailsScreen()));
                                    },
                                    // make the button to be a rectangle with round corners
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(320, 50),
                                        backgroundColor:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        )),
                                    child: const Text(
                                      'Request Trip',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                              ]))));
                  //  ListTile(
                  //   title: Text(
                  //       (notification as Map<String, dynamic>)['destination']),
                  //   subtitle: Text(notification['departure location']),
                  // );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              );
            }
          },
        )),
      ),
    );
  }
}
