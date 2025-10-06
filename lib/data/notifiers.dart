import 'package:flutter/material.dart';
import 'package:productive_360_app/data/outlook_time_zones.dart';
import 'package:productive_360_app/models/habit_collection.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier<int>(0);
ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(false);

final selectedTimezoneNotifier = ValueNotifier<String>(
  supportedOutlookTimeZones[1],
);

ValueNotifier<bool> isLoggedInNotifier = ValueNotifier<bool>(false);

ValueNotifier<bool> preloadedHabitsNotifier = ValueNotifier<bool>(false);
// ValueNotifier<HabitCollection> habitCollectionNotifier =
//     ValueNotifier<HabitCollection>(HabitCollection());

ValueNotifier<bool> habitsChangedNotifier = ValueNotifier<bool>(false);

ValueNotifier<String> tmp_graph_token_notifier = ValueNotifier<String>("");
