// ignore_for_file: library_private_types_in_public_api

import 'package:caravan/screens/history.dart';
import 'package:caravan/screens/home/home.dart';
import 'package:caravan/screens/profile.dart';
import 'package:flutter/material.dart';

class MainTemplate extends StatefulWidget {
  const MainTemplate({super.key});

  @override
  _MainTemplateState createState() => _MainTemplateState();
}

class _MainTemplateState extends State<MainTemplate> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    // Replace these with your own screens
    const HistoryScreen(), const Home(), const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor:
            Colors.white, // Color of the selected item icon and text
        unselectedItemColor:
            Colors.grey[400], // Color of the unselected items' icons and text
        selectedLabelStyle: const TextStyle(
            color: Colors.white), // Color of the selected item text
        backgroundColor: Colors.grey[850],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
    );
  }
}
