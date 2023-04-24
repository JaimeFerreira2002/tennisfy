import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennisfy/models/score_model.dart';

class Game {
  bool isSet;
  bool hasBeenPlayed;
  bool isCompetitive;
  String player1UID;
  String player2UID;
  String? winnerUID;
  Score? finalScore;
  DateTime? dateTimeSet;
  GeoPoint? locationSet;

  Game(
      {this.isSet = false,
      this.hasBeenPlayed = false,
      required this.isCompetitive,
      required this.player1UID,
      required this.player2UID,
      this.winnerUID,
      this.finalScore,
      this.dateTimeSet,
      this.locationSet});

  Map<String, dynamic> toJson() => {
        'IsSet': isSet,
        'HasBeenPlayed': hasBeenPlayed,
        'IsCompetitive': isCompetitive,
        'Player1UID': player1UID,
        'Player2UID': player2UID,
        'WinnerUID': winnerUID,
        'FinalScore': finalScore,
        'DateTimeSet': dateTimeSet,
        'LocationSet': locationSet,
      };

  static fromJson(Map<String, dynamic> json) {
    return Game(
      isSet: json['IsSet'],
      hasBeenPlayed: json['HasBeenPlayed'],
      isCompetitive: json['IsCompetitive'],
      player1UID: json['Player1UID'],
      player2UID: json['Player2UID'],
      winnerUID: json['WinnerUID'] ?? json['WinnerUID'],
      finalScore: json['FinalScore'] ?? json['FinalScore'],
      dateTimeSet: json['DateTimeSet'] ?? json['DateTimeSet'],
      locationSet: json['LocationSet'] ?? json['LocationSet'],
    );
  }
}
