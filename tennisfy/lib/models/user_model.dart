import 'dart:convert';
import 'package:tennisfy/models/comment_model.dart';
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
  int ELO;
  bool hasSetupAccount;
  List<Game> gamesPlayed;
  List<String> friendsList; //list of uid of friends
  List<String> nextGamesList; //list with Id's of user next games
  double reputation;
  DateTime dateJoined;
  List<Comment> comments;
  List<String>
      friendRequests; //list with UID that sent this user a friend request
  List<int> ELOHistory;

  UserData(
      {required this.UID,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.dateOfBirth,
      required this.sex,
      required this.bio,
      required this.ELO,
      required this.hasSetupAccount,
      required this.gamesPlayed,
      required this.friendsList,
      required this.nextGamesList,
      required this.reputation,
      required this.dateJoined,
      required this.comments,
      required this.friendRequests,
      required this.ELOHistory});

  Map<String, dynamic> toJson() => {
        'UID': UID,
        'Email': email,
        'FirstName': firstName,
        'LastName': lastName,
        'DateOfBirth': dateToFirebase(dateOfBirth),
        'Sex': sex,
        'Biography': bio,
        'ELO': ELO,
        'HasSetupAccount': hasSetupAccount,
        'GamesPlayed': jsonEncode(gamesPlayed),
        'FriendsList': jsonEncode(friendsList),
        'NextGamesList': jsonEncode(nextGamesList),
        'Reputation': reputation,
        'DateJoined': dateToFirebase(dateJoined),
        'CommentsList': jsonEncode(comments),
        'FriendRequests': jsonEncode(friendRequests),
        'ELOHistory': jsonEncode(ELOHistory),
      };

  ///
  ///We are getting one at a time, is this stil necessary?
  ///
  static fromJson(Map<String, dynamic> json) {
    List<dynamic> gamesPlayedJsonList = jsonDecode(json['GamesPlayed']);
    List<dynamic> nextGamesJsonList = jsonDecode(json['NextGamesList']);
    List<dynamic> friendsJsonList = jsonDecode(json['FriendsList']);
    List<dynamic> commentsJsonList = jsonDecode(json['CommentsList']);
    List<dynamic> friendRequestsJsonList = jsonDecode(json['FriendRequests']);

    return UserData(
        UID: json['UID'],
        email: json['Email'],
        firstName: json['FirstName'],
        lastName: json['LastName'],
        dateOfBirth: dateFromFirebase(json['DateOfBirth']),
        sex: json['Sex'],
        ELO: json['ELO'],
        bio: json['Biography'],
        hasSetupAccount: json['HasSetupAccount'],
        gamesPlayed: gamesPlayedJsonList.cast<Game>(),
        friendsList: friendsJsonList.cast<String>(),
        nextGamesList: nextGamesJsonList.cast<String>(),
        reputation: json['Reputation'],
        dateJoined: dateFromFirebase(json['DateJoined']),
        comments: commentsJsonList.cast<Comment>(),
        friendRequests: friendRequestsJsonList.cast<String>(),
        ELOHistory: jsonDecode(json['ELOHistory']));
  }
}
