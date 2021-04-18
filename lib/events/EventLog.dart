import 'package:intl/intl.dart';
import 'package:kostka/events/EventInProgress.dart';

class EventLog {

  static const START = 'start';
  static const END = 'end';
  static const TYPE = 'type';

  final DateTime start;
  final DateTime end;
  final String type;

  final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String get formattedStart => dateFormat.format(start);
  String get formattedEnd => dateFormat.format(end);

  // konstruktor domyślny
  EventLog(this.start, this.end, this.type);

  factory EventLog.fromProgress(EventInProgress event){
    return EventLog(event.start, DateTime.now(), event.type);
  }

  factory EventLog.fromJson(Map<String, dynamic> map) {
    var start = DateTime.fromMillisecondsSinceEpoch(map[START]);
    var end = DateTime.fromMillisecondsSinceEpoch(map[END]);
    return EventLog(start, end, map[TYPE]);
  }

  Map<String, dynamic> toJson() => {
        START: start.millisecondsSinceEpoch,
        END: end.millisecondsSinceEpoch,
        TYPE: type,
      };
  Duration getEventDuration(){
    return end.difference(start);
  }
}
