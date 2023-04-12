import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tennisfy/components/costum_appBar.dart';
import 'package:tennisfy/pages/find_page.dart';
import 'package:tennisfy/pages/history_page.dart';
import 'home_page.dart';
import 'inbox_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _bottomBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: costunAppBar(context),
        bottomNavigationBar: Container(
          height: 90,
          child: GNav(
            gap: 8,
            iconSize: 25,
            selectedIndex: _bottomBarIndex,
            onTabChange: (index) {
              setState(() {
                _bottomBarIndex = index;
              });
            },
            color: const Color.fromARGB(255, 41, 41, 41),
            activeColor: const Color.fromARGB(255, 41, 41, 41),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "Home",
                textStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 41, 41, 41),
                ),
              ),
              GButton(
                icon: Icons.search_rounded,
                text: "Find",
                textStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 41, 41, 41),
                ),
              ),
              GButton(
                icon: Icons.inbox,
                text: "Inbox",
                textStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 41, 41, 41),
                ),
              ),
              GButton(
                icon: Icons.history,
                text: "History",
                textStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 41, 41, 41),
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: _pageSelected(_bottomBarIndex),
        ));
  }
}

Widget _pageSelected(int index) {
  List<Widget> _pagesList = [
    const HomePage(),
    const FindPage(),
    const InboxPage(),
    const HistoryPage()
  ];
  return _pagesList[index];
}
