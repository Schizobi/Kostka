import 'package:flutter/material.dart';
import 'package:kostka/events/EventLog.dart';

class EventRow extends StatelessWidget {
  final EventLog eventLog;
  EventRow(this.eventLog);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: <Widget>[
          AspectRatio(child: Icon(Icons.forward),aspectRatio: 1,),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Text>[
                      Text(eventLog.type),
                      Text(printDuration(eventLog.getEventDuration())),
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
