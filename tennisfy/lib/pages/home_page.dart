import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tennisfy/components/costum_appBar.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/helpers/services/firebase_getters.dart';
import 'package:tennisfy/models/game_model.dart';
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
                  SizedBox(height: displayHeight(context) * 0.025),
                  _statsCard(context, ELOHistoryList, snapshot, _gamesPlayed),
                  SizedBox(height: displayHeight(context) * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Your next Games",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w200),
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
                  const Text("Current ELO",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
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
