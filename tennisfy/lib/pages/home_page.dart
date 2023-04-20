import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/models/user_model.dart';
import '../components/stats_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserData?>(builder: (context, userData, Widget? child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
          child: Column(
            children: [
              SizedBox(height: displayHeight(context) * 0.04),
              Align(
                alignment: Alignment.centerLeft,
                child: userData == null
                    ? const SkeletonLine()
                    : Text(
                        "Hi " + userData.firstName + "! ",
                        style: Theme.of(context).textTheme.headline1,
                      ),
              ),
              SizedBox(height: displayHeight(context) * 0.025),
              userData == null
                  ? SkeletonListTile()
                  : statsCard(context, userData),
              SizedBox(height: displayHeight(context) * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your next Games",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_alt_outlined))
                ],
              ),
              userData == null
                  ? SkeletonListTile()
                  : Expanded(
                      child: Container(
                        child: userData.nextGamesList.isEmpty
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
                            : ListView.builder(
                                itemCount: userData.nextGamesList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: displayHeight(context) * 0.2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
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
                                }),
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }
}
