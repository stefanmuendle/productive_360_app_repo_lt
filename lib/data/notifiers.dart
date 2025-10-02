import 'package:flutter/material.dart';
import '../models/habit_collection.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier<int>(0);
ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(false);

ValueNotifier<bool> isLoggedInNotifier = ValueNotifier<bool>(false);

ValueNotifier<bool> preloadedHabitsNotifier = ValueNotifier<bool>(false);
// ValueNotifier<HabitCollection> habitCollectionNotifier =
//     ValueNotifier<HabitCollection>(HabitCollection());

ValueNotifier<bool> habitsChangedNotifier = ValueNotifier<bool>(false);
