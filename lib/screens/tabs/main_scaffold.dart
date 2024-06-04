import 'package:caravan/screens/tabs/chatroom_screen.dart';
import 'package:caravan/screens/tabs/history.dart';
import 'package:caravan/screens/tabs/home.dart';
import 'package:caravan/screens/tabs/settings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final tabs = <Widget>[
    const HistoryScreen(),
    const Home(),
    const ChatListScreen(),
    const SettingsScreen()
  ];

  int currentTab = 1;

  void goToTab(int index) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTab],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentTab,
        enableFeedback: true,
        // backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: Colors.grey,
        onTap: goToTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history_outlined,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.history,
              color: Colors.white,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.messenger_outline,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.messenger,
              color: Colors.white,
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_outlined,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            label: 'Settings',
          ),
          // Add more items as needed...
        ],
      ),
    );
  }
}
