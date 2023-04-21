import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../models/comment_model.dart';
import '../../models/game_model.dart';
import '../../models/user_model.dart';
import 'auth.dart';
import '../helper_methods.dart';

///
///This class holds all the functions of the 'Users' collection
///

class FirebaseUsers {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('Users');

  String currentUserUID = Auth().currentUserUID;

  Future<UserData> getUserData(String userUID) async {
    final DocumentSnapshot userDoc = await usersRef.doc(userUID).get();

    return UserData.fromJson(userDoc.data() as Map<String, dynamic>)
        as UserData;
  }

  Stream<UserData?> getUserDataStream(String userUID) {
    final userDoc = FirebaseFirestore.instance.collection('Users').doc(userUID);

    return userDoc
        .snapshots()
        .map((document) => UserData.fromJson(document.data()!));
  }

  Future<String> getProfileImageURL(String userUID) async {
    final imageURL = await FirebaseStorage.instance
        .ref()
        .child("ProfilePictures/" + userUID + ".jpg")
        .getDownloadURL();

    return imageURL;
  }

  ///
  ///Simplify this function
  ///
  Stream<QuerySnapshot> getUsersOrderedByDistance(
      GeoPoint currentUserLocation, double radiusInKm) {
    // define constants for radius of the earth in km and the radius of the search area
    const double EARTH_RADIUS = 6371.0;
    double searchRadius = radiusInKm;

    // convert search radius to radians
    double searchRadiusInRadians = searchRadius / EARTH_RADIUS;

    // get the coordinates of the user's location
    double userLat = currentUserLocation.latitude;
    double userLng = currentUserLocation.longitude;

    // calculate the bounding coordinates of the search area
    double minLat = userLat - searchRadiusInRadians;
    double maxLat = userLat + searchRadiusInRadians;
    double minLng = userLng - searchRadiusInRadians / cos(radians(userLat));
    double maxLng = userLng + searchRadiusInRadians / cos(radians(userLat));

    // create a query for all users within the search area
    return FirebaseFirestore.instance
        .collection('Users')
        .where('Location', isGreaterThanOrEqualTo: GeoPoint(minLat, minLng))
        .where('Location', isLessThanOrEqualTo: GeoPoint(maxLat, maxLng))
        .snapshots();
  }

// helper function to convert degrees to radians
  double radians(double degrees) {
    return degrees * pi / 180.0;
  }

  Future<int> getUserELOTopPercentage(String userUID) async {
    List<int> allUsersELOList = [];
    int userELO = await getUserELO(userUID);

//this block of code adds every users ELO to the list
    CollectionReference _documentRef =
        FirebaseFirestore.instance.collection("Users");
    QuerySnapshot querySnapshot = await _documentRef.get();
    for (var documentSnapshot in querySnapshot.docs) {
      allUsersELOList.add(documentSnapshot.get('ELO') as int);
    }

    // Sort the user list in descending order based on ELO value
    allUsersELOList.sort((a, b) => a.compareTo(b));

    // Calculate the index of the user's ELO value in the sorted list
    int userIndex = allUsersELOList.indexWhere((user) => user == userELO);

    // Calculate the percentage of users whose ELO value is higher than the user's
    double topPercentage =
        (allUsersELOList.length - userIndex) / allUsersELOList.length * 100;

    debugPrint(topPercentage.toString());

    return topPercentage.toInt();
  }

  Future<List<String>> getUserChatsIdsList(String userUID) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

    return (jsonDecode(userDoc.get('ChatsIDsList')) as List).cast<String>();
  }

  ///
  ///Retrieves  user full name
  ///
  Future<String> getUserFullName(String userUID) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

    return userDoc.get('FirstName') + ' ' + userDoc.get('LastName');
  }

  ///
  ///retrieves current user biography
  ///

  Future<String> getUserBio(String userUID) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

    return userDoc.get('Biography');
  }

  ///
  ///Retrieves user ELO
  ///
  Future<int> getUserELO(String userUID) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

    return userDoc.get('ELO');
  }

  ///
  ///retrieves current user date of birth as String
  ///

  Future<DateTime> getUserDateOfBirth(String userUID) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

    return dateFromFirebase(userDoc.get('DateOfBirth'));
  }

  ///
  ///retrieves current user bool value - hasSetupAccount
  ///

  Future<bool> getUserHasSetupAccount(String userUID) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

    return userDoc.get('HasSetupAccount');
  }

  ///
  ///retrieves current user int value - Reputation
  ///

  Future<double> getUserReputation(String userUID) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

    return userDoc.get('Reputation');
  }

  ///
  ///retrieves current user number of friends
  ///
  Future<int> getUserNumberOfFriends(String userUID) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

    return userDoc.get('NumberOfFriends');
  }

  ///
  ///retrieves current user friends list
  ///
  Future<List<String>> getUserFriendsList(String userUID) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

    return userDoc.get('FriendsList');
  }

// void addGamePlayed(String player1, String player2) async {
//     Game newGame =
//         Game(isCompetitive: false, player1UID: player1, player2UID: player2);

//     List<Game> _gamesPlayed = await getUserGamesPlayed(player1);
//     print("List of games: " + _gamesPlayed.toString());
//     _gamesPlayed.add(newGame);

//     await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(player1)
//         .update({'GamesPlayed': jsonEncode(_gamesPlayed)});
//   }

  ///
  ///Retrieves list of games the user played
  ///
  Future<List<Game>> getUserGamesPlayed(String userUID) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

    return jsonDecode(userDoc.get('GamesPlayed'))
        .map((gameJson) => Game.fromJson(gameJson))
        .toList()
        .cast<Game>();
  }

  ///
  ///Retrieves number of games the user played
  ///
  Future<int> getUserNumberOfGamesPLayed(String userUID) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

    return userDoc.get('NumberOfGamesPlayed');
  }

  ///
  ///retrieves the users next games list ??should it be a stream??
  ///
  Future<List<Game>> getUserNextGamesList(String userUID) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

    return (jsonDecode(userDoc.get('NextGamesList')) as List).cast<Game>();
  }

  ///
  ///Retreives a list off all user comments
  ///
  Future<List<Comment>> getUserCommentsList(String userUID) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

    return jsonDecode(userDoc.get('CommentsList'))
        .map((commentJson) => Comment.fromJson(commentJson))
        .toList()
        .cast<Comment>();
  }

  ///
  ///Checks if two users are friends or not
  ///
  Future<bool> userAreFriends(String userUID1, String userUID2) async {
    UserData user1 = await getUserData(userUID1);

    if (user1.friendsList.contains(userUID2)) {
      return true;
    } else {
      return false;
    }
  }

  ///
  ///Checks if a user has sent a friend request to another user
  ///
  Future<bool> userSentFriendRequest(
      String senderUID, String recieverUID) async {
    UserData reciever = await getUserData(recieverUID);
    if (reciever.friendRequests.contains(senderUID)) {
      return true;
    } else {
      return false;
    }
  }

  ///
  ///Sends a friend request, it recieves as argument both the user sender and the reciever
  ///
  Future<void> sendFriendRequest(String senderUID, String recieverUID) async {
    UserData reciever = await getUserData(recieverUID);
    if (!reciever.friendRequests.contains(senderUID)) {
      reciever.friendRequests.add(senderUID);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(recieverUID)
          .update(reciever.toJson());
    } else {
      print('Already sent a firend request');
    }
  }

  ///
  ///Unsends a friend request, it recieves as argument both the user sender and the reciever
  ///

  Future<void> unsendFriendRequest(String senderUID, String recieverUID) async {
    UserData reciever = await getUserData(recieverUID);
    if (reciever.friendRequests.contains(senderUID)) {
      reciever.friendRequests.remove(senderUID);
      print(reciever.friendRequests.toString());
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(recieverUID)
          .update(reciever.toJson());
    } else
      print(
          'error, user has not sent friend request'); //useful print, used for debugging, leave it? use in every method?
  }

  Future acceptFriendRequest(String recieverUID, String senderUID) async {
    UserData reciever = await getUserData(recieverUID);
    UserData sender = await getUserData(senderUID);

//remove request from requests list,add sender to reciever friends list and update firebase reference
    reciever.friendRequests.remove(senderUID);
    reciever.friendsList.add(senderUID);

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(recieverUID)
        .update(reciever.toJson());

    //add  reciever to sender friends list and update firebase reference
    sender.friendsList.add(recieverUID);

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(senderUID)
        .update(sender.toJson());
  }

  Future unfriend(String recieverUID, String senderUID) async {
    UserData reciever = await getUserData(recieverUID);
    UserData sender = await getUserData(senderUID);

    if (!reciever.friendsList.contains(sender.UID) ||
        !sender.friendsList.contains(recieverUID)) {
      print('error, users are not firends');
      return;
    }
//remove sender to reciever friends list and update firebase reference

    reciever.friendsList.remove(senderUID);

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(recieverUID)
        .update(reciever.toJson());

    //remove  reciever to sender friends list and update firebase reference
    sender.friendsList.remove(recieverUID);

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(senderUID)
        .update(sender.toJson());
  }

  Future rejectFriendRequest(String recieverUID, String senderUID) async {
    UserData reciever = await getUserData(recieverUID);

//remove request from requests list
    reciever.friendRequests.remove(senderUID);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(recieverUID)
        .update(reciever.toJson());
  }
}
