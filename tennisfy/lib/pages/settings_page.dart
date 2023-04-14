import 'package:flutter/material.dart';
import 'package:tennisfy/helpers/auth.dart';
import 'package:tennisfy/helpers/helper_methods.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/pages/profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 22),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary,
            )),
        bottom: PreferredSize(
          child: Container(
            color: Theme.of(context)
                .colorScheme
                .primary
                .withOpacity(0.2), // choose your desired color
            height: 1.5, // choose your desired height
          ),
          preferredSize: const Size.fromHeight(0.0),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: displayHeight(context) * 0.04),
          _settings_tile(context, Icons.person, "Profile",
              ProfilePage(userUID: Auth().currentUser!.uid)),
          _settings_tile(
              context,
              Icons.settings,
              "Preferences",
              ProfilePage(
                userUID: Auth().currentUser!.uid,
              )),
          _settings_tile(
              context,
              Icons.info,
              "About us",
              ProfilePage(
                userUID: Auth().currentUser!.uid,
              )),
          const Spacer(),
          Container(
            height: displayHeight(context) * 0.2,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  scale: 12,
                ),
                TextButton(
                    onPressed: () {
                      signOut();
                    },
                    child: const Text(
                      "Sign out",
                      style: TextStyle(fontSize: 14),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  GestureDetector _settings_tile(
      BuildContext context, IconData icon, String label, Widget pageToGo) {
    return GestureDetector(
      onTap: () {
        goToPage(context, pageToGo);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
        child: Container(
          height: displayHeight(context) * 0.06,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.tertiary,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 0),
                blurRadius: 8.0,
                spreadRadius: 0.5,
                color: const Color.fromARGB(255, 59, 59, 59).withOpacity(0.2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 30,
                ),
                SizedBox(width: displayWidth(context) * 0.03),
                Text(
                  label,
                  style: const TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
