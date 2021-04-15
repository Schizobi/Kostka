import 'package:flutter/material.dart';
import 'package:kostka/events/EventInProgress.dart';
import 'package:kostka/events/EventLog.dart';

abstract class EventDB{

  List<EventLog> getEvents(DateTimeRange range);
   EventInProgress getEventInProgress();
   bool hasEventInProgress();
   void setEventInProgress(String type);
   void addEvent(EventLog event);
   //todo edit event / delete event
}