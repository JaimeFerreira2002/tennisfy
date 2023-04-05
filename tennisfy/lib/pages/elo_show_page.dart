import 'package:flutter/material.dart';

class EloShowPage extends StatefulWidget {
  int ELO;

  EloShowPage({Key? key, required this.ELO}) : super(key: key);

  @override
  State<EloShowPage> createState() => _EloShowPageState();
}

class _EloShowPageState extends State<EloShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.ELO.toString()),
      ),
    );
  }
}
