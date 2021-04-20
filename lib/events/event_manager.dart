import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kostka/db/event_db.dart';
import 'package:kostka/events/EventInProgress.dart';
import 'package:kostka/events/EventLog.dart';

class EventManager extends ChangeNotifier{
  final EventDB db;
  bool isPaused = true;

  int currentEdge=0;

  String getTaskName(int edge){
    switch(edge){

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
        return Colors.black;
    }
  }


  EventManager(this.db){
    isPaused=!db.hasEventInProgress();
  }

  void updateEdge(int e){

    if(hasCurrentEvent()) finishCurrentEvent();
    currentEdge=e;
    // var newEvent = EventInProgress(DateTime.now(), e.toString());
    db.setEventInProgress(e.toString());//??
    notifyListeners();
    print('MANAGER UPDATED $e');

  }

  StreamSubscription? edgeStreamSubscription;
  void setEdgeStream(Stream<int> stream)async{
    await edgeStreamSubscription?.cancel();
    edgeStreamSubscription = stream.listen((edge) {
      if(isPaused){
        return;
      }
      print('MANAGER RECEIVED $edge');
      if(currentEdge!=edge) {
        updateEdge(edge);
      }

    });

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
    currentEdge=0;
    notifyListeners();

  }
  void stop(){
    isPaused = true;
    finishCurrentEvent();
    //currentEdge=0;
    notifyListeners();
  }
  void finishCurrentEvent(){
    if(db.hasEventInProgress()){
      var eventInProgress = db.getEventInProgress();
      var log = EventLog.fromProgress(eventInProgress);
      db.addEvent(log);
      db.clearEventInProgress();
    }
  }
  bool hasCurrentEvent(){
    return db.hasEventInProgress();
  }
   EventInProgress getCurrentEvent(){
     return db.getEventInProgress();
   }

   @override
  void dispose() {
    edgeStreamSubscription?.cancel();
    super.dispose();
  }
}