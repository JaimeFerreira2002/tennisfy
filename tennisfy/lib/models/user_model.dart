import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennisfy/models/comment_model.dart';
import 'package:tennisfy/models/game_invite_model.dart';
import '../helpers/helper_methods.dart';
import 'game_model.dart';

class UserData {
  String UID;
  String email;
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  String sex;
  String bio;
  GeoPoint
      location; //location set by the user when setting up the account, could change later
  int ELO;
  bool hasSetupAccount;
  List<Game> gamesPlayed;
  List<String> friendsList; //list of uid of friends
  List<String> nextGamesList; //list with Id's of user next games
  List<GameInvite> gamesInvitesList; //List of invites this user has recieved
  double reputation;
  DateTime dateJoined;
  List<Comment> comments;
  List<String>
      friendRequests; //list with UID that sent this user a friend request
  List<int> ELOHistory;
  List<String> chatsIds; //all of chats the user is participating

  UserData(
      {required this.UID,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.dateOfBirth,
      required this.sex,
      required this.bio,
      required this.location,
      required this.ELO,
      required this.hasSetupAccount,
      required this.gamesPlayed,
      required this.friendsList,
      required this.nextGamesList,
      required this.gamesInvitesList,
      required this.reputation,
      required this.dateJoined,
      required this.comments,
      required this.friendRequests,
      required this.ELOHistory,
      required this.chatsIds});

  Map<String, dynamic> toJson() => {
        'UID': UID,
        'Email': email,
        'FirstName': firstName,
        'LastName': lastName,
        'DateOfBirth': dateToFirebase(dateOfBirth),
        'Sex': sex,
        'Biography': bio,
        'Location': location,
        'ELO': ELO,
        'HasSetupAccount': hasSetupAccount,
        'GamesPlayed': jsonEncode(gamesPlayed),
        'FriendsList': jsonEncode(friendsList),
        'NextGamesList': jsonEncode(nextGamesList),
        'GameInvitesList': jsonEncode(gamesInvitesList),
        'Reputation': reputation,
        'DateJoined': dateToFirebase(dateJoined),
        'CommentsList': jsonEncode(comments),
        'FriendRequests': jsonEncode(friendRequests),
        'ELOHistory': jsonEncode(ELOHistory),
        'ChatsIDsList': jsonEncode(chatsIds),
      };

  ///
  ///We are getting one at a time, is this stil necessary?
  ///
  static fromJson(Map<String, dynamic> json) {
    List<dynamic> gamesPlayedJsonList = jsonDecode(json['GamesPlayed']);
    List<dynamic> nextGamesJsonList = jsonDecode(json['NextGamesList']);
    List<dynamic> gameInvitesJsonList = jsonDecode(json['GameInvitesList']);
    List<dynamic> friendsJsonList = jsonDecode(json['FriendsList']);
    List<dynamic> commentsJsonList = jsonDecode(json['CommentsList']);
    List<dynamic> friendRequestsJsonList = jsonDecode(json['FriendRequests']);
    List<dynamic> ELOHistoryJsonList = jsonDecode(json['ELOHistory']);
    List<dynamic> chatsIDsJsonList = jsonDecode(json['ChatsIDsList']);

    return UserData(
      UID: json['UID'],
      email: json['Email'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      dateOfBirth: dateFromFirebase(json['DateOfBirth']),
      sex: json['Sex'],
      ELO: json['ELO'],
      bio: json['Biography'],
      location: json['Location'],
      hasSetupAccount: json['HasSetupAccount'],
      gamesPlayed: gamesPlayedJsonList
          .map((gameJson) => Game.fromJson(gameJson))
          .toList()
          .cast<Game>(),
      friendsList: friendsJsonList.cast<String>(),
      nextGamesList: nextGamesJsonList.cast<String>(),
      gamesInvitesList: gameInvitesJsonList
          .map((gameInviteJson) => GameInvite.fromJson(gameInviteJson))
          .toList()
          .cast<GameInvite>(),
      reputation: json['Reputation'],
      dateJoined: dateFromFirebase(json['DateJoined']),
      comments: commentsJsonList
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList()
          .cast<Comment>(),
      friendRequests: friendRequestsJsonList.cast<String>(),
      ELOHistory: ELOHistoryJsonList.cast<int>(),
      chatsIds: chatsIDsJsonList.cast<String>(),
    );
  }
}
