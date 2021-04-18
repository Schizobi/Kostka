import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kostka/events/event_manager.dart';
import 'package:kostka/view/event_row.dart';


class Today extends StatefulWidget {

  final EventManager manager;

  const Today(this.manager);

  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {

  @override
  void initState() {
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(
                "Strona:${widget.manager.currentEdge}",
                style: TextStyle(fontSize: 32),
              ),
              Expanded(
                child: ListView(
                  children: widget.manager.getTodayEvents().map<Widget>((e) => EventRow(e)).toList(),

                ),
              )
            ],
          ),
        )
    );
  }
}