import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/helpers/services/firebase_getters.dart';

import '../helpers/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomBarIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
            child: GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  FutureBuilder(
                    future: getProfileImageURL(Auth().currentUser!.uid),
                    initialData: "Loading...",
                    builder: ((context, AsyncSnapshot<String> snapshot) {
                      return CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          backgroundImage: snapshot.data != null
                              ? Image.network(snapshot.data!).image
                              : Image.network(
                                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                                  .image);
                    }),
                  ),
                  SizedBox(
                    width: displayWidth(context) * 0.04,
                  ),
                  FutureBuilder(
                    initialData: "Loading",
                    future: getUserFullName(Auth().currentUser!.uid),
                    builder: ((context, AsyncSnapshot<String> snapshot) {
                      debugPrint(snapshot.data);
                      return Text(
                        snapshot.data!,
                        //here we need a costum text style, non of the establushed fits good
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
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
              text: "Search",
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
              icon: Icons.settings,
              text: "Settings",
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
        child: TextButton(
            onPressed: () {
              signOut();
            },
            child: Text("Sign out")),
      ),
    );
  }
}
