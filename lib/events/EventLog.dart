import 'package:intl/intl.dart';
import 'package:kostka/events/EventInProgress.dart';

class EventLog {

  static const START = 'start';
  static const END = 'end';
  static const TYPE = 'type';

  final DateTime start;
  final DateTime end;
  final String type;
  EventInProgress finishEvent;
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String get formattedStart => dateFormat.format(start);
  String get formattedEnd => dateFormat.format(end);

  // konstruktor domyślny
  EventLog(this.start, this.end, this.type, this.finishEvent);


  factory EventLog.fromJson2(Map<String, dynamic> map) {
    return EventLog(map[START], map[END], map[TYPE], map['finishEvent']);
  }

  Map<String, dynamic> toJson() => {
        START: formattedStart,
        END: end,
        TYPE: type,
      };
}
