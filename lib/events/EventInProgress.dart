import 'package:intl/intl.dart';

class EventInProgress {

  static const START = 'start';
  static const TYPE = 'type';

  final DateTime start;
  final String type;
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  final DateFormat timeFormat = DateFormat("HH:mm:ss");
  String get formattedStart => dateFormat.format(start);
  Duration get duration => DateTime.now().difference(start);
  String get durationFormatted => timeFormat.format(DateTime.fromMillisecondsSinceEpoch(duration.inMilliseconds));

  EventInProgress(this.start, this.type);


  factory EventInProgress.fromJson(Map<String, dynamic> map) {
    var start = DateTime.fromMillisecondsSinceEpoch(map[START]);
    return EventInProgress(start, map[TYPE]);
  }

  Map<String, dynamic> toJson() => {
    START: start.millisecondsSinceEpoch,
    TYPE: type,
  };
}
/*
dodac plugin shared preferences
na sztywwno wpisac 5 eventow i je zapisz
i potem odczytywanie
 */