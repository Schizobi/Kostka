import 'package:intl/intl.dart';

class EventInProgress {

  static const START = 'start';
  static const TYPE = 'type';

  final DateTime start;
  final String type;
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String get formattedStart => dateFormat.format(start);
  Duration get timeNow => DateTime.now().difference(start);
  format(String formattedTimeNow) => timeNow.toString().split('.').first.padLeft(8, "0");

  EventInProgress(this.start, this.type);


  factory EventInProgress.fromJson2(Map<String, dynamic> map) {
    return EventInProgress(map[START], map[TYPE]);
  }

  Map<String, dynamic> toJson() => {
    START: formattedStart,
    TYPE: type,
  };
}
/*
dodac plugin shared preferences
na sztywwno wpisac 5 eventow i je zapisz
i potem odczytywanie
 */