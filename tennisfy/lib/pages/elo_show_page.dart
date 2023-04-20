import 'package:flutter/material.dart';
import 'package:tennisfy/helpers/services/auth.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/helpers/services/firebase_users.dart';
import 'package:tennisfy/pages/nav_bar.dart';

class EloShowPage extends StatefulWidget {
  int ELO;

  EloShowPage({Key? key, required this.ELO}) : super(key: key);
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  @override
  State<EloShowPage> createState() => _EloShowPageState();
}

class _EloShowPageState extends State<EloShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Congratulations !",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const Text(
                    "Your starting ELO is",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Container(
                height: displayHeight(context) * 0.3,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.ELO.toString(),
                    style: const TextStyle(
                        fontSize: 100, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              FutureBuilder(
                initialData: 0,
                future: FirebaseUsers()
                    .getUserELOTopPercentage(Auth().currentUser!.uid),
                builder: ((context, AsyncSnapshot<int> snapshot) {
                  return Text(
                    "This means you are in the top " +
                        snapshot.data.toString() +
                        "%"
                            " of all users",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  );
                }),
              ),
              SizedBox(height: displayHeight(context) * 0.06),
              Container(
                height: displayHeight(context) * 0.06,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          _infoPopUps(context,
                              'By taking into account multiple factors that can impact a users performance, our algorithm provides a comprehensive and fair assessment of their abilities. Additionally, the use of capped maximum and minimum values ensures that the rating falls within a reasonable range, providing users with a clear understanding of their performance. ');
                        },
                        child: const Text(
                          "How is my starting ELO calculated ?",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w900),
                        ),
                      );
                    }),
                    GestureDetector(
                      onTap: () {
                        _infoPopUps(context,
                            'Please note that your starting ELO cannot be changed at this time. However, we encourage you to add a warning to your profile description to let others know. Our matching algorithm is designed to naturally approach the "real" value of your skill level as you play against other users, so your ELO rating should become more accurate over time. Thank you for your understanding and we hope you enjoy the game!');
                      },
                      child: const Text(
                        "Can I change my ELO ?",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w900),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.06),
              Align(
                alignment: Alignment.center,
                child: Container(
                    width: displayWidth(context) * 0.9,
                    height: displayHeight(context) * 0.06,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NavBar()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Text(
                          "Finish",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 20),
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _infoPopUps(BuildContext context, String text) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
          child: Container(
            height: displayHeight(context) * 0.3,
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      text,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                  child: Container(
                    width: displayWidth(context) * 0.9,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        'Got it !',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 20),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
