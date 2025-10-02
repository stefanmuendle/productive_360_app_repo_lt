import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart';

class EventsPlannerTreeDaysView extends StatelessWidget {
  const EventsPlannerTreeDaysView({
    super.key,
    required this.controller,
    required this.isDarkMode,
  });

  final EventsController controller;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    var heightPerMinute = 1.0;
    var initialVerticalScrollOffset = heightPerMinute * 7 * 60;

    return EventsPlanner(
      controller: controller,
      daysShowed: 3,
      heightPerMinute: heightPerMinute,
      initialVerticalScrollOffset: initialVerticalScrollOffset,
      daysHeaderParam: DaysHeaderParam(
        daysHeaderVisibility: true,
        dayHeaderTextBuilder: (day) => DateFormat("E d").format(day),
      ),
    );
  }
}
