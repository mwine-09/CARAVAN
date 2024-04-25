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
    const SettingsScreen()
  ];

  late PageController _pageController;
  int currentTab = 0;

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
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: tabs,
      ),
      bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: currentTab,
            backgroundColor: Colors.black,
            selectedItemColor: Colors.white,
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
          )),
    );
  }
}
