import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tennisfy/components/others.dart';
import '../helpers/media_query_helpers.dart';
import '../models/game_model.dart';

Container statsCard(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  List<ELOHistory> ELOHistoryList = _buildELOHistoryList(
      snapshot.data.get('UID'),
      (jsonDecode(snapshot.data.get('ELOHistory')) as List<dynamic>)
          .cast<int>());
  //is this going to wrok when the game list isnt empty?
  List<Game> gamesPlayed = jsonDecode(snapshot.data.get('GamesPlayed'))
      .map((commentJson) => Game.fromJson(commentJson))
      .toList()
      .cast<Game>();

  int _numberOfWins = 0;
  gamesPlayed.forEach(
    (element) {
      if (element.winnerUID == snapshot.data.get('UID')) {
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
            smallVerticalDivider(context),
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
            smallVerticalDivider(context),
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

///
///Aux class to build stats graph
///

class ELOHistory {
  int ELO;
  int gameNr;
  ELOHistory(this.ELO, this.gameNr);
}
