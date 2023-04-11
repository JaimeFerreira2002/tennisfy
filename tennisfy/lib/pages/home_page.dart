import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tennisfy/helpers/helper_methods.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/helpers/services/firebase_getters.dart';
import 'package:tennisfy/models/game_model.dart';
import 'package:tennisfy/pages/settings_page.dart';
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
      appBar: appBar(context),
      body: StreamBuilder(
          stream: getUserDataStream(Auth().currentUser!.uid),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            List<ELOHistory> ELOHistoryList = _buildELOHistoryList(
                Auth().currentUser!.uid,
                (jsonDecode(snapshot.data.get('ELOHistory')) as List<dynamic>)
                    .cast<int>());
            List<Game> _gamesPlayed =
                (jsonDecode(snapshot.data.get('GamesPlayed')) as List<dynamic>)
                    .cast<Game>();
            debugPrint("List" + _gamesPlayed.toString());
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
                  SizedBox(height: displayHeight(context) * 0.035),
                  _statsCard(context, ELOHistoryList, snapshot, _gamesPlayed),
                  SizedBox(height: displayHeight(context) * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Your next Games",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_alt_outlined))
                    ],
                  ),
                  Expanded(
                    child: Container(
                        child: _gamesPlayed.isEmpty
                            ? const Center(
                                child:
                                    Text("You are yet to play your first game"),
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

  Container _statsCard(BuildContext context, List<ELOHistory> ELOHistoryList,
      AsyncSnapshot<dynamic> snapshot, List<Game> gamesPlayed) {
    int _numberOfWins = 0;
    gamesPlayed.forEach(
      (element) {
        if (element.winnerUID == Auth().currentUser!.uid) {
          _numberOfWins++;
        }
      },
    );

    return Container(
      height: displayHeight(context) * 0.2,
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
      child: Column(
        children: [
          ClipRRect(
            //clip, like a mask in photoshop
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Container(
              height: displayHeight(context) * 0.13,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                  ),
                  primaryYAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    minorGridLines: const MinorGridLines(width: 0),
                  ),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <AreaSeries<ELOHistory, int>>[
                    AreaSeries<ELOHistory, int>(
                      color: Theme.of(context).colorScheme.secondary,
                      markerSettings: const MarkerSettings(
                          height: 8, width: 8, isVisible: true),
                      dataSource: ELOHistoryList,
                      xValueMapper: (ELOHistory games, _) => games.gameNr,
                      yValueMapper: (ELOHistory games, _) => games.ELO,
                    )
                  ]),
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text("Current ELO", style: TextStyle(fontSize: 12)),
                  Text(
                    snapshot.data.get('ELO').toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 20),
                  ),
                ],
              ),
              Container(
                width: displayWidth(context) * 0.006,
                height: displayHeight(context) * 0.04,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.4)),
              ),
              Column(
                children: [
                  const Text("Games played", style: TextStyle(fontSize: 12)),
                  Text(
                    gamesPlayed.length.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 20),
                  ),
                ],
              ),
              Container(
                width: displayWidth(context) * 0.006,
                height: displayHeight(context) * 0.04,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.4)),
              ),
              Column(
                children: [
                  const Text(
                    "Win/Lose",
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    _numberOfWins.toString() +
                        " / " +
                        (gamesPlayed.length - _numberOfWins).toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 20),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Image.asset(
        "assets/images/logo.png",
      ),
      bottom: PreferredSize(
        child: Container(
          color: Theme.of(context)
              .colorScheme
              .primary
              .withOpacity(0.2), // choose your desired color
          height: 1.0, // choose your desired height
        ),
        preferredSize: const Size.fromHeight(1.0),
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
                        backgroundColor: Theme.of(context).colorScheme.primary,
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
            onPressed: () {
              goToPage(context, SettingsPage());
            },
            icon: Icon(
              Icons.settings_rounded,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ))
      ],
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

///
///Aux class to build stats graph
///

class ELOHistory {
  int ELO;
  int gameNr;
  ELOHistory(this.ELO, this.gameNr);
}
