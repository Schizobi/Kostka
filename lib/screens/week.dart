import 'package:flutter/material.dart';
import 'package:kostka/events/event_manager.dart';

class Week extends StatefulWidget {

  final EventManager manager;

  const Week(this.manager);

  @override
  _WeekState createState() => _WeekState();
}

class _WeekState extends State<Week> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(
                 "week"
              ),
            Text(
                  (widget.manager.getWeeklyStats()["1"].toString())
              ),
              Text(
                  (widget.manager.getWeeklyStats()["2"].toString())
              ),
              Text(
                  (widget.manager.getWeeklyStats()["3"].toString())
              ),
              Text(
                  (widget.manager.getWeeklyStats()["4"].toString())
              ),
              Text(
                  (widget.manager.getWeeklyStats()["5"].toString())
              ),
              Text(
                  (widget.manager.getWeeklyStats()["6"].toString())
              ),

            ],
          ),
        )
    );
  }
}
