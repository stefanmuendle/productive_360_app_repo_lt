import 'package:flutter/material.dart';

enum CalendarView {
  agenda("List", Icons.list),
  day("One Day", Icons.calendar_view_day_outlined),
  day3Draggable("Three days - Draggable events", Icons.view_column),
  month("Month", Icons.calendar_month),
  day7("Seven days (web or tablet)", Icons.calendar_view_week);

  const CalendarView(this.text, this.icon);

  final String text;
  final IconData icon;
}
