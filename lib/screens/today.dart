import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Today extends StatefulWidget {
  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {
   String _timeString= '';
   String _haveStarted3Times = '';


  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    _incrementStartup();
  }


  void _getTime() {
    final String formattedDateTime =
    //DateFormat('yyyy-MM-dd \n kk:mm:ss').format(DateTime.now()).toString();
    DateFormat(' kk:mm:ss').format(DateTime.now()).toString();
    if (mounted) {
      setState(
              () {
            _timeString = formattedDateTime;
          }
      );
    }
  }



   Future<int> _getIntFromSharedPref() async {
     final prefs = await SharedPreferences.getInstance();
     final startupNumber = prefs.getInt('startupNumber');
     if (startupNumber == null) {
       return 0;
     }
     return startupNumber;
   }


   Future<void> _resetCounter() async {
     final prefs = await SharedPreferences.getInstance();
     await prefs.setInt('startupNumber', 0);
   }


   Future<void> _incrementStartup() async {
     final prefs = await SharedPreferences.getInstance();

     int lastStartupNumber = await _getIntFromSharedPref();
     int currentStartupNumber = ++lastStartupNumber;

     await prefs.setInt('startupNumber', currentStartupNumber);

     if (currentStartupNumber == 3) {
       setState(() => _haveStarted3Times = '$currentStartupNumber Times Completed');
       
       await _resetCounter();
     } else {
       setState(() => _haveStarted3Times = '$currentStartupNumber Times started the app');
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(
                  _timeString.toString()
              ),
              Text(
                _haveStarted3Times,
                style: TextStyle(fontSize: 32),
              ),
            ],
          ),
        )
    );
  }
}