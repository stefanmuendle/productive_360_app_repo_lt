import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatelessWidget {
  final EventsController controller;
  final int daysShowed;
  final void Function(DateTime)? onPageChanged;
  final void Function(Event)? onEventTap;

  const CalendarWidget({
    super.key,
    required this.controller,
    required this.daysShowed,
    this.onPageChanged,
    this.onEventTap,
  });

  void moveEvent(
    Event oldEvent,
    DateTime roundStartDateTime,
    DateTime roundEndDateTime,
  ) {
    controller.updateCalendarData((calendarData) {
      calendarData.updateEvent(
        oldEvent: oldEvent,
        newEvent: oldEvent.copyWith(
          startTime: roundStartDateTime,
          endTime: roundEndDateTime,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return EventsPlanner(
      controller: controller,
      initialDate: DateTime.now(),
      maxNextDays: 365,
      maxPreviousDays: 365,
      heightPerMinute: 1.0,
      initialVerticalScrollOffset: 1.0 * 7 * 60,
      daySeparationWidth: 3,
      daysShowed: daysShowed,
      onDayChange: onPageChanged,
      onVerticalScrollChange: (offset) {},
      automaticAdjustHorizontalScrollToDay: true,
      onAutomaticAdjustHorizontalScroll: (day) {},
      horizontalScrollPhysics: const BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.fast,
      ),
      dayEventsArranger: SideEventArranger(paddingLeft: 0, paddingRight: 0),
      dayParam: DayParam(
        dayEventBuilder: (event, height, width, heightPerMinute) {
          return GestureDetector(
            onTap: () => onEventTap?.call(event),
            child: DefaultDayEvent(
              height: height,
              width: width,
              title: event.title,
              description: event.description,
              color: event.color,
            ),
          );
        },
      ),
      daysHeaderParam: DaysHeaderParam(
        daysHeaderHeight: 40.0,
        daysHeaderColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.grey,
        dayHeaderBuilder: (day, isToday) {
          final dayNum = DateFormat('d').format(day);
          final dayShort = DateFormat('EEE').format(day);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(dayShort, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(dayNum, style: TextStyle(fontSize: 12)),
            ],
          );
        },
      ),

      fullDayParam: FullDayParam(
        fullDayEventsBarVisibility: true,
        fullDayEventsBarLeftWidget: Builder(
          builder: (context) {
            final now = DateTime.now();
            final dayNum = DateFormat('d').format(now);
            final dayShort = DateFormat('EEE').format(now);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayNum,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(dayShort, style: const TextStyle(fontSize: 12)),
              ],
            );
          },
        ),
        fullDayEventsBarHeight: 40,
        fullDayEventsBarDecoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
      ),
    );
  }
}
