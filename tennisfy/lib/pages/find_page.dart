import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennisfy/components/profile_image_avatar.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/pages/profile_page.dart';

import '../helpers/services/auth.dart';
import '../helpers/helper_methods.dart';
import '../helpers/services/firebase_users.dart';
import '../models/user_model.dart';

class FindPage extends StatefulWidget {
  const FindPage({Key? key}) : super(key: key);

  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  String userSearchInput = '';
  final String _filterMode = 'Near you';
  TextEditingController userSearchInputController = TextEditingController();

  //filter modes
  bool _distanceIsSelected = false;
  bool _ELOIsSelected = false;
  bool _gamesPlayedIsSelected = false;
  bool _ageIsSelected = false;

  bool _showRecommendedPlayer = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserData?>(
      builder: (context, userData, child) {
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                FutureBuilder(
                  future: FirebaseUsers().findBestFittingAdversary(),
                  builder: (context, AsyncSnapshot<UserData?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.data == null) {
                      return const SizedBox();
                    }
                    return _showRecommendedPlayer
                        ? Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(14, 26, 14, 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Our pick for you !",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _showRecommendedPlayer = false;
                                          });
                                        },
                                        child: Text(
                                          "Dismiss",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.4)),
                                        ))
                                  ],
                                ),
                              ),
                              _buildListTile(snapshot.data!,
                                  context), //eventually costumize this to not be the same as the list?
                            ],
                          )
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                _showRecommendedPlayer = true;
                              });
                            },
                            child: Text(
                              "Show recommended pick",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.4)),
                            ));
                  },
                ),
                SizedBox(height: displayHeight(context) * 0.06),
                Padding(
                  //these indivdual paddings are necessary beacuse of the shadoes of the users list tiles
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Find",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            width: displayWidth(context) * 0.06,
                          ),
                          Text(
                            _filterMode,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.4)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                _filtersPopUp(context);
                              },
                              icon: const Icon(Icons.filter_alt_outlined)),
                          IconButton(
                              onPressed: () {
                                setState(() {});
                              },
                              icon: const Icon(Icons.refresh))
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                    child: _userSearchBar(context)),
                Expanded(
                  child: Container(
                    child: StreamBuilder<dynamic>(
                      stream: FirebaseUsers().orderedUsersStream(
                          _distanceIsSelected,
                          _ELOIsSelected,
                          _gamesPlayedIsSelected,
                          _ageIsSelected),
                      builder: (context, snapshots) {
                        if ((snapshots.connectionState ==
                            ConnectionState.waiting)) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                              itemCount: snapshots.data!.docs.length,
                              itemBuilder: (context, index) {
                                UserData userData = UserData.fromJson(
                                    snapshots.data!.docs[index].data()
                                        as Map<String, dynamic>);

                                return _buildListTile(userData, context);
                              });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _filtersPopUp(BuildContext context) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Filter by",
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _filtersSelectButton(context, setState,
                            _distanceIsSelected, 1, "Distance"),
                        _filtersSelectButton(
                            context, setState, _ELOIsSelected, 2, "ELO"),
                        _filtersSelectButton(
                          context,
                          setState,
                          _gamesPlayedIsSelected,
                          3,
                          "Games played",
                        ),
                        _filtersSelectButton(
                          context,
                          setState,
                          _ageIsSelected,
                          4,
                          "Age",
                        ),
                      ],
                    ),
                    SizedBox(height: displayHeight(context) * 0.04),
                  ],
                ),
              );
            },
          );
        });
  }

  ///This is used to not repeat code in the filters tab
  ///[modeToSelectRef] is to know which variable to change, using int instead of String because it is lighter
  ///1 - Distance
  ///2 - ELO
  ///3 - Games played
  ///4 - Age
  ///we still use [modeToSelect] for rendering colors, not having to use multiple switch cases
  ///[otherValue] is for cases where we have a range slider instead of a simple slider
  ///
  TextButton _filtersSelectButton(
    BuildContext context,
    StateSetter setState,
    bool modeToSelect,
    int modeToSelectRef,
    String label,
  ) {
    return TextButton(
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: modeToSelect
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary.withOpacity(0.2)),
      onPressed: () {
        setState(() {
          switch (modeToSelectRef) {
            case 1:
              _distanceIsSelected = !_distanceIsSelected;
              break;

            case 2:
              _ELOIsSelected = !_ELOIsSelected;
              break;
            case 3:
              _gamesPlayedIsSelected = !_gamesPlayedIsSelected;
              break;
            case 4:
              _ageIsSelected = !_ageIsSelected;
              break;
            default:
          }
        });
      },
      child: Text(
        label,
        style: TextStyle(
            fontSize: 14,
            color: !modeToSelect
                ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
                : Theme.of(context).colorScheme.tertiary),
      ),
    );
  }

  Padding _userSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Container(
        height: displayHeight(context) * 0.06,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
        child: TextField(
          controller: userSearchInputController,
          onChanged: (input) {
            setState(() {
              userSearchInput = input;
            });
          },
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(14),
            hintText: 'Enter user´s name or email',
            hintStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color.fromARGB(255, 178, 178, 178)),
            border: InputBorder.none,
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    userSearchInput = '';
                    userSearchInputController.text = '';
                  });
                },
                icon: const Icon(Icons.cancel)),
          ),
        ),
      ),
    );
  }

  StatelessWidget _buildListTile(UserData userData, BuildContext context) {
    if (userSearchInput.isEmpty) {
      return Visibility(
        visible: userData.UID != Auth().currentUser!.uid &&
            userData
                .hasSetupAccount, // is this good here, or should we use .where() when fetching the users from firebase
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
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
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData.firstName + userData.lastName,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18),
                  ),
                  Text(
                    userData.gamesPlayed.length.toString() +
                        ' ' +
                        'Games played',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.4),
                        fontSize: 12),
                  ),
                ],
              ),
              contentPadding: const EdgeInsets.all(6),
              leading: ProfileImageAvatar(userUID: userData.UID, radius: 26),
              onTap: () {
                goToPage(
                    context,
                    ProfilePage(
                      userData: userData,
                    ));
              },
            ),
          ),
        ),
      );
    } else {
      //everything in lower case to make search easier
      if (userData.firstName
              .toLowerCase()
              .contains(userSearchInput.toLowerCase()) ||
          userData.email
              .toLowerCase()
              .contains(userSearchInput.toLowerCase())) {
        return Visibility(
          visible: userData.UID != Auth().currentUser!.uid,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData.firstName + userData.lastName,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 18),
                ),
                Text(
                  userData.email,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.4),
                      fontSize: 10),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.all(6),
            leading: FutureBuilder(
              //profile image
              future: FirebaseUsers().getProfileImageURL(userData.UID),
              builder: ((context, AsyncSnapshot<String> snapshot) {
                return CircleAvatar(
                  //border
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primary,

                  child: CircleAvatar(
                      radius: 26,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      backgroundImage: snapshot.data != null
                          ? Image.network(snapshot.data!).image
                          : Image.network(
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                              .image),
                );
              }),
            ),
            onTap: () {
              goToPage(
                  context,
                  ProfilePage(
                    userData: userData,
                  ));
            },
          ),
        );
      } else {
        return Container();
      }
    }
  }
}
