import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kostka/db/event_db.dart';
import 'package:kostka/events/EventInProgress.dart';
import 'package:kostka/events/EventLog.dart';

class EventManager extends ChangeNotifier{
  final EventDB db;

  int currentEdge=0;

  EventManager(this.db);

  void setEdge(int e){
    if(currentEdge!=e) {
      currentEdge=e;
      if(db.hasEventInProgress()){
        var eventInProgress = db.getEventInProgress();
        var log = EventLog.fromProgress(eventInProgress);
        db.addEvent(log);
      }
     // var newEvent = EventInProgress(DateTime.now(), e.toString());
      db.setEventInProgress( e.toString());//??

      notifyListeners();
    }
  }
  List<EventLog> getTodayEvents(){
    var now = DateTime.now();
     return db.getEvents(DateTimeRange(start: now, end: now));
  }

}