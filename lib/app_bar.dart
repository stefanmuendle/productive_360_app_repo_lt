import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/src/controller/events_controller.dart';
import 'package:intl/intl.dart';

import 'enumerations.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.eventsController,
    this.onChangeDarkMode,
    this.onChangeCalendarView,
  });

  final EventsController eventsController;
  final void Function(bool darkMode)? onChangeDarkMode;
  final void Function(CalendarView calendarMode)? onChangeCalendarView;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(40);
}

class _CustomAppBarState extends State<CustomAppBar> {
  var calendarMode = CalendarView.day3Draggable;
  var darkMode = false;
  late DateTime focusedDay;

  @override
  void initState() {
    super.initState();
    focusedDay = widget.eventsController.focusedDay;

    widget.eventsController.onFocusedDayChange = (day) {
      setState(() {
        focusedDay = day;
      });
    };
  }

  String _getRangeText() {
    // Determine how many days are visible
    final int days = switch (calendarMode) {
      CalendarView.day3Draggable => 3,
      CalendarView.day7 => 7,
      _ => 1,
    };

    final start = DateTime(focusedDay.year, focusedDay.month, focusedDay.day);
    final end = start.add(Duration(days: days - 1));

    final startText = DateFormat("EEE, d MMM").format(start);
    final endText = DateFormat("d MMM").format(end);

    if (days == 1) {
      return startText; // just one day
    }
    return "$startText - $endText";
  }

  @override
  Widget build(BuildContext context) {
    var color = darkMode
        ? Colors.white
        : Theme.of(context).colorScheme.onPrimary;

    return AppBar(
      titleSpacing: 0,
      title: LayoutBuilder(
        builder: (context, constraints) {
          // Only show the range if there is enough space
          final showRange = constraints.maxWidth > 220; // adjust threshold

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat("MMM yyyy").format(focusedDay),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: color),
              ),
              if (showRange)
                Text(
                  _getRangeText(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color.withOpacity(0.8),
                  ),
                ),
            ],
          );
        },
      ),
      scrolledUnderElevation: 0.0,
      toolbarOpacity: 1,
      elevation: 0,
      centerTitle: false,
      actions: [
        PopupMenuButton(
          icon: Icon(calendarMode.icon),
          iconColor: color,
          onSelected: (value) => setState(() {
            calendarMode = value;
            widget.onChangeCalendarView?.call(value);
          }),
          itemBuilder: (BuildContext context) {
            return CalendarView.values.map((mode) {
              return PopupMenuItem(
                value: mode,
                child: ListTile(
                  leading: Icon(mode.icon),
                  title: Text(mode.text),
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}
