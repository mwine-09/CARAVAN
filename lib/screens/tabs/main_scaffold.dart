import 'package:caravan/screens/tabs/chatroom_screen.dart';
import 'package:caravan/screens/tabs/history.dart';
import 'package:caravan/screens/tabs/home.dart';
import 'package:caravan/screens/tabs/settings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final int tabDestination;
  const HomePage({super.key, required this.tabDestination});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  late int currentTab;

  @override
  void initState() {
    super.initState();
    currentTab = widget.tabDestination;
    _pageController = PageController(initialPage: currentTab);
  }

  void onTabTapped(int index) {
    setState(() {
      currentTab = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: const <Widget>[
          HistoryScreen(),
          Home(),
          ChatListScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentTab,
          enableFeedback: true,
          selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
          unselectedItemColor: Colors.grey,
          onTap: onTabTapped,
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
          ],
        ),
      ),
    );
  }
}
