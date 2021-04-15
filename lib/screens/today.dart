import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kostka/events/event_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Today extends StatefulWidget {

  final EventManager manager;

  const Today(this.manager);

  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {
   String _timeString= '';


  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }


  void _getTime() {
    final String formattedDateTime = DateFormat(' kk:mm:ss').format(DateTime.now()).toString();
    if (mounted) {
      setState(
              () {
            _timeString = formattedDateTime;
          }
      );
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
                "Strona:${widget.manager.currentEdge}",
                style: TextStyle(fontSize: 32),
              ),
              Expanded(
                child: ListView(
                  children: widget.manager.getTodayEvents().map<Widget>((e) => Text(e.start.toString())).toList(),

                ),
              )
            ],
          ),
        )
    );
  }
}