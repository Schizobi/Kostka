import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TimeShow())
  );
}

class TimeShow extends StatefulWidget {
  @override
  _TimeShowState createState() => _TimeShowState();
}

class _TimeShowState extends State<TimeShow> {
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
      appBar: AppBar(
        title: Text('Time'),
      ),
      body: Center(
        child: Text(
      _timeString.toString()
        ),
      )
    );
  }
}

