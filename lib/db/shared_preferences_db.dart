import 'dart:convert';

import 'package:flutter/src/material/date.dart';
import 'package:intl/intl.dart';
import 'package:kostka/db/event_db.dart';
import 'package:kostka/events/EventInProgress.dart';
import 'package:kostka/events/EventLog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDB implements EventDB{
  final SharedPreferences pref;
  static const String CURRENT_KEY='current';

  SharedPreferencesDB(this.pref);

  @override
  void setEventInProgress(String type) {
   var event = EventInProgress(DateTime.now(), type);
   var eventEncoded = jsonEncode(event.toJson());
   pref.setString(CURRENT_KEY, eventEncoded);
  }

  @override
  bool hasEventInProgress() {
    return pref.containsKey(CURRENT_KEY);
  }


  @override
  EventInProgress getEventInProgress() {
    var eventString = pref.getString(CURRENT_KEY) ?? "";
    return EventInProgress.fromJson(jsonDecode(eventString));
  }

  @override
  List<EventLog> getEvents(DateTimeRange range) {
    List<EventLog> result =[];
    var step = DateTime(range.start.year,range.start.month,range.start.day);
    var limit =  DateTime(range.end.year,range.end.month,range.end.day);
    while(step.isBefore(limit) || step.isAtSameMomentAs(limit)){
      result.addAll(getEventsForDay(step));
      step=DateTime(step.year,step.month,step.day+1);
    }
    return result;
  }

  @override
  void addEvent(EventLog event) {
    //pobierze liste wszystkich eventow dnai dnia doda ten event do listy i zapisze liste
    List<EventLog> list = getEventsForDay(event.start);
    list.add(event);
    setEventsForDay(list, event.start);
  }

  final DateFormat keyFormat = DateFormat("yyyy_MM_dd");

  String getKey(DateTime datetime){
  return keyFormat.format(datetime);
  }
  Future<bool> setEventsForDay(List<EventLog> list, DateTime day){
    List<String> strings =[];

    strings = List<String>.from(list.map((e) => jsonEncode(e.toJson())));

    return pref.setStringList(getKey(day), strings);
  }
  List<EventLog> getEventsForDay(DateTime day){
    List<EventLog> list =[];
    var key = getKey(day);
    if (pref.containsKey(key)){
        List<String>  strings = pref.getStringList(getKey(day))?? [];

        list = List<EventLog>.from(strings.map((s) => EventLog.fromJson(jsonDecode(s))));

      }
    return list;
  }



}