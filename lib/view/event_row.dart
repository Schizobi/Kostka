import 'package:flutter/material.dart';
import 'package:kostka/events/EventLog.dart';

class EventRow extends StatelessWidget {
  final EventLog eventLog;
  EventRow(this.eventLog);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: <Widget>[
            AspectRatio(child: Icon(Icons.forward),aspectRatio: 1,),
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,15,0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Text>[
                          Text(eventLog.type),
                          Text(printDuration(eventLog.getEventDuration())),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: getTaskColor(int.parse(eventLog.type)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color getTaskColor(int edge){
  switch(edge){

    case 1:
      return Colors.red;
    case 2:
      return Colors.green;
    case 3:
      return Colors.blue;
    case 4:
      return Colors.pink;
    case 5:
      return Colors.yellow;
    case 6:
      return Colors.teal;
    default:
      return Colors.white;
  }
}


String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
