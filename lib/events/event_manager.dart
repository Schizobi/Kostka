import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kostka/db/event_db.dart';
import 'package:kostka/events/EventInProgress.dart';
import 'package:kostka/events/EventLog.dart';

class EventManager extends ChangeNotifier{
  final EventDB db;
  bool isPaused = false;

  int currentEdge=0;

  String get currentTaskName{
    switch(currentEdge){

      case 1:
        return "task 1";
      case 2:
        return "task 2";
      case 3:
        return "task 3";
      case 4:
        return "task 4";
      case 5:
        return "task 5";
      case 6:
        return "task 6";
      default:
        return "";
    }
  }

  EventManager(this.db);

  void setEdge(int e){
    if(isPaused){
      return;
    }
    if(currentEdge!=e) {
      currentEdge=e;
      finishCurrentEvent();
     // var newEvent = EventInProgress(DateTime.now(), e.toString());
      db.setEventInProgress(e.toString());//??

      notifyListeners();
    }
  }
  List<EventLog> getTodayEvents(){
    var now = DateTime.now();
     return db.getEvents(DateTimeRange(start: now, end: now));
  }
  Map<String, Duration> getWeeklyStats(){
    Map<String, Duration> weeklyStats = {
      "1":Duration(),
      "2":Duration(),
      "3":Duration(),
      "4":Duration(),
      "5":Duration(),
      "6":Duration(),
    };
    DateTime now = DateTime.now();
    List<EventLog> allEvents = db.getEvents(DateTimeRange(start:now.subtract(Duration(days: 7)), end: now));
    for(var event in allEvents){
      weeklyStats[event.type] = weeklyStats.update(event.type, (value) =>  value + event.getEventDuration()) ;
    }
    return weeklyStats;
  }
  void start(){
    isPaused = false;
    notifyListeners();

  }
  void stop(){
    isPaused = true;
    finishCurrentEvent();
    currentEdge=0;
    notifyListeners();
  }
  void finishCurrentEvent(){
    if(db.hasEventInProgress()){
      var eventInProgress = db.getEventInProgress();
      var log = EventLog.fromProgress(eventInProgress);
      db.addEvent(log);
    }
  }
   EventInProgress getCurrentTask(){
     return db.getEventInProgress();
   }
}