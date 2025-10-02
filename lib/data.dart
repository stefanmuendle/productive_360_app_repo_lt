import 'dart:math';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:productive_360_app/extension.dart';

DateTime get _now => DateTime.now();

List<Event> events = [
  Event(
    title: "Team Meeting",
    description: "Weekly team sync-up.",
    startTime: DateTime(_now.year, _now.month, _now.day, 10, 0), // Today 10:00
    endTime: DateTime(_now.year, _now.month, _now.day, 11, 0), // Today 11:00
    color: Colors.blue.pastel,
    textColor: Colors.blue.onPastel,
  ),
  Event(
    title: "Project Review",
    description: "Review project milestones.",
    startTime: DateTime(_now.year, _now.month, _now.day, 14, 0), // Today 14:00
    endTime: DateTime(_now.year, _now.month, _now.day, 15, 0), // Today 15:00
    color: Colors.green.pastel,
    textColor: Colors.green.onPastel,
  ),
  Event(
    title: "Client Call",
    description: "Call with important client.",
    startTime: DateTime(_now.year, _now.month, _now.day, 16, 0), // Today 16:00
    endTime: DateTime(_now.year, _now.month, _now.day, 17, 0), // Today 17:00
    color: Colors.red.pastel,
    textColor: Colors.red.onPastel,
  ),
];

// You can leave multiColumnEvents, fullDayEvents, etc. empty or adjust as needed for your tests:
List<Event> multiColumnEvents = [];
List<Event> fullDayEvents = [];
List<Event> reservationsEvents = [];
