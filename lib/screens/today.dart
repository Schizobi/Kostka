import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Today extends StatefulWidget {
  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {
  String _timeString;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final String formattedDateTime =
    //DateFormat('yyyy-MM-dd \n kk:mm:ss').format(DateTime.now()).toString();
    DateFormat(' kk:mm:ss').format(DateTime.now()).toString();
    setState(() {
      _timeString = formattedDateTime;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text(
              _timeString.toString()
          ),
        )
    );
  }
}