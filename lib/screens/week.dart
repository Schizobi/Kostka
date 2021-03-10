import 'package:flutter/material.dart';

class Week extends StatefulWidget {
  @override
  _WeekState createState() => _WeekState();
}

class _WeekState extends State<Week> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text(
            "Week",
          ),
        )
    );
  }
}
