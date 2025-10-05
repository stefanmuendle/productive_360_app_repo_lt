import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:productive_360_app/app_bar.dart';
import 'package:productive_360_app/data.dart';
import 'package:productive_360_app/data/dal/ms_graph_service.dart';
import 'package:productive_360_app/enumerations.dart';
import 'package:productive_360_app/views/events_list_all_parameters_view.dart';
import 'package:productive_360_app/views/events_months_view.dart';
import 'package:productive_360_app/views/events_planner_draggable_events_view.dart';
import 'package:productive_360_app/views/events_planner_one_day_view.dart';
import 'package:productive_360_app/views/events_planner_three_days_view.dart';
import 'package:productive_360_app/data/notifiers.dart';
import 'package:productive_360_app/views/pages/settings_page.dart';
import 'package:productive_360_app/views/widgets/event_dialog.dart'; // <-- Import your notifiers

enum CalendarViewMode { threeDay, week, month }

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  EventsController eventsController = EventsController();
  var calendarMode = CalendarView.day3Draggable;

  @override
  void initState() {
    super.initState();
    eventsController.updateCalendarData((calendarData) {
      calendarData.addEvents(events);
      calendarData.addEvents(fullDayEvents);
    });
  }

  Future<void> _showAddOrEditEventDialog({Event? event}) async {
    await showDialog(
      context: context,
      builder: (context) => EventDialogWidget(
        initialEvent: event,
        onSave: (newEvent) {
          if (event == null) {
            eventsController.updateCalendarData(
              (cd) => cd.addEvents([newEvent]),
            );
          } else {
            eventsController.updateCalendarData((cd) {
              cd.updateEvent(oldEvent: event, newEvent: newEvent);
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, darkMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            primaryColor: Colors.blue,
            appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
            colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.light,
              seedColor: Colors.blue,
              primary: Colors.blue,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            appBarTheme: AppBarTheme(backgroundColor: Color(0xff2F2F2F)),
            colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: Colors.blueAccent,
            ),
          ),
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          home: Scaffold(
            appBar: CustomAppBar(
              eventsController: eventsController,
              onChangeCalendarView: (calendarMode) =>
                  setState(() => this.calendarMode = calendarMode),
              onChangeDarkMode: (darkMode) =>
                  isDarkModeNotifier.value = darkMode, // <-- update notifier
            ),
            body: Column(
              children: [
                Expanded(
                  child: CalendarViewWidget(
                    calendarMode: calendarMode,
                    controller: eventsController,
                    darkMode: darkMode,
                    onEventTap: (event) =>
                        _showAddOrEditEventDialog(event: event),
                  ),
                ),

                IconButton(
                  onPressed: () async {
                    final currentDate = eventsController.focusedDay;
                    final start = DateTime(
                      currentDate.year,
                      currentDate.month,
                      currentDate.day,
                    );

                    final end = start.add(
                      Duration(
                        days: calendarMode == CalendarView.day3Draggable
                            ? 3
                            : calendarMode == CalendarView.day7
                            ? 7
                            : 1,
                      ),
                    );

                    if (tmp_graph_token_notifier.value.isEmpty) {
                      // Show MS Login Dialog
                      showDialog(
                        context: context,
                        builder: (context) => const SettingsPage(),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'You must login first to sync with Microsoft.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    //_showAddOrEditEventDialog();

                    MsGraphService msGraphService = MsGraphService();

                    final List<Event> newEvents = await MsGraphService()
                        .fetchEventsInRange(start, end);

                    for (var _newEvent in newEvents) {
                      eventsController.updateCalendarData((cd) {
                        cd.updateEvent(
                          oldEvent: _newEvent,
                          newEvent: _newEvent,
                        );
                      });
                    }

                    // final Event _newEvent;
                    // final event = Event(
                    //   startTime: DateTime(2025, 10, 04, 18, 0),
                    //   endTime: DateTime(2025, 10, 04, 19, 0),
                    //   title: "huhu outlook event",
                    //   description: "testing adding event to outlook",
                    //   color: Colors.purple,
                    // );

                    // _newEvent = event;

                    // if (_newEvent == null) {
                    //   eventsController.updateCalendarData(
                    //     (cd) => cd.addEvents([_newEvent]),
                    //   );
                    // } else {
                    //   eventsController.updateCalendarData((cd) {
                    //     cd.updateEvent(
                    //       oldEvent: _newEvent,
                    //       newEvent: _newEvent,
                    //     );
                    //   });
                    // }

                    // Show Snackbar instead of print
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Fetched ${newEvents.length} events from Outlook.",
                        ),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddOrEditEventDialog(),
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}

// Update CalendarViewWidget to accept onEventTap
class CalendarViewWidget extends StatelessWidget {
  const CalendarViewWidget({
    super.key,
    required this.calendarMode,
    required this.controller,
    required this.darkMode,
    this.onEventTap,
  });

  final CalendarView calendarMode;
  final EventsController controller;
  final bool darkMode;
  final void Function(Event)? onEventTap;

  @override
  Widget build(BuildContext context) {
    return switch (calendarMode) {
      CalendarView.agenda => EventsListView(controller: controller),
      CalendarView.day => EventsPlannerOneDayView(
        key: UniqueKey(),
        controller: controller,
        isDarkMode: darkMode,
      ),
      CalendarView.day3Draggable => EventsPlannerDraggableEventsView(
        key: UniqueKey(),
        controller: controller,
        daysShowed: 3,
        isDarkMode: darkMode,
        onEventTap: onEventTap,
      ),
      CalendarView.day7 => EventsPlannerDraggableEventsView(
        key: UniqueKey(),
        controller: controller,
        daysShowed: 7,
        isDarkMode: darkMode,
        onEventTap: onEventTap,
      ),
      CalendarView.month => EventsMonthsView(controller: controller),
    };
  }
}
