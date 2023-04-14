import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/helpers/services/firebase_getters.dart';
import 'package:tennisfy/models/game_model.dart';
import '../components/stats_card.dart';
import '../helpers/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: getUserDataStream(Auth().currentUser!.uid),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            //this list is necessary to repeat here because of other widgets in home page
            List<Game> _gamesPlayed =
                (jsonDecode(snapshot.data.get('GamesPlayed')) as List<dynamic>)
                    .cast<Game>();

            return Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Column(
                children: [
                  SizedBox(height: displayHeight(context) * 0.04),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hi " + snapshot.data.get('FirstName') + "! ",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  SizedBox(height: displayHeight(context) * 0.025),
                  statsCard(context, snapshot),
                  SizedBox(height: displayHeight(context) * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Your next Games",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_alt_outlined))
                    ],
                  ),
                  Expanded(
                    child: Container(
                        child: _gamesPlayed.isEmpty
                            ? Center(
                                child: Text(
                                  "You are yet to play your first game",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.6)),
                                ),
                              )
                            : FutureBuilder(
                                future: getUserNextGamesList(
                                    Auth().currentUser!.uid),
                                builder: (context,
                                    AsyncSnapshot<List<Game>> snapshot) {
                                  if (!snapshot.hasData) {
                                    return CircularProgressIndicator();
                                  }
                                  return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          height: displayHeight(context) * 0.2,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(0, 0),
                                                blurRadius: 8.0,
                                                spreadRadius: 0.5,
                                                color: const Color.fromARGB(
                                                        255, 59, 59, 59)
                                                    .withOpacity(0.2),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                })),
                  ),
                ],
              ),
            );
          }),
    );
  }

  List<ELOHistory> _buildELOHistoryList(String uid, List<int> userELOHistory) {
    List<ELOHistory> output = [];
    int counter = 0;
    userELOHistory.forEach((element) {
      output.add(ELOHistory(element, counter));
      counter++;
    });

    return output;
  }
}
