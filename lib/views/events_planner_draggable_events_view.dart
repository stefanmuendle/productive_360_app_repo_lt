import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:productive_360_app/extension.dart';

class EventsPlannerDraggableEventsView extends StatelessWidget {
  const EventsPlannerDraggableEventsView({
    super.key,
    required this.controller,
    required this.daysShowed,
    required this.isDarkMode,
    this.onEventTap,
  });

  final EventsController controller;
  final int daysShowed;
  final bool isDarkMode;
  final void Function(Event)? onEventTap;

  @override
  Widget build(BuildContext context) {
    var heightPerMinute = 1.0;
    var initialVerticalScrollOffset = heightPerMinute * 7 * 60;

    return EventsPlanner(
      controller: controller,
      daysShowed: daysShowed,
      heightPerMinute: heightPerMinute,
      initialVerticalScrollOffset: initialVerticalScrollOffset,
      dayParam: DayParam(
        onSlotTap: (columnIndex, exactDateTime, roundDateTime) {},
        dayEventBuilder: (event, height, width, heightPerMinute) {
          return draggableEvent(event, height, width);
        },
      ),
      daysHeaderParam: DaysHeaderParam(
        daysHeaderVisibility: daysShowed != 1,
        dayHeaderTextBuilder: (day) => DateFormat("E d").format(day),
        topLeftCellBuilder: (day) => Center(
          child: Text(
            DateFormat("MMM").format(day),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      fullDayParam: FullDayParam(fullDayEventsBarHeight: 50),
    );
  }

  DefaultDayHeader getDayHeader(
    DateTime day,
    bool isToday,
    BuildContext context,
  ) {
    return DefaultDayHeader(
      dayText: DateFormat("E d").format(day),
      isToday: isToday,
      foregroundColor: isDarkMode
          ? Theme.of(context).colorScheme.primary
          : null,
    );
  }

  DraggableEventWidget draggableEvent(
    Event event,
    double height,
    double width,
  ) {
    return DraggableEventWidget(
      event: event,
      height: height,
      width: width,
      onDragEnd: (columnIndex, exactStart, exactEnd, roundStart, roundEnd) {
        controller.updateCalendarData(
          (calendarData) => calendarData.moveEvent(event, roundStart),
        );
      },
      child: DefaultDayEvent(
        height: height,
        width: width,
        title: event.title,
        description: event.description,
        color: isDarkMode ? event.color.onPastel : event.color,
        textColor: isDarkMode ? event.textColor.pastel : event.textColor,
        onTap: () => onEventTap?.call(event), // <-- Make editable on tap!
      ),
    );
  }
}
