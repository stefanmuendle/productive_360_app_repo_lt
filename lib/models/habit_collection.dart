// import '../data/dal/db_access.dart' as db_access;
// import 'habit.dart';

// class HabitCollection {
//   final List<Habit> habits = [];

//   void addHabit(Habit habit) {
//     habits.add(habit);
//     db_access.addHabit(habit);
//   }

//   void removeHabit(Habit habit) {
//     habits.remove(habit);
//   }

//   // Get the last [days] records for a habit (default: 5)
//   List<HabitDayRecord> getLastDaysRecords(Habit habit, {int days = 5}) {
//     final now = DateTime.now();
//     List<HabitDayRecord> records = [];
//     for (int i = days - 1; i >= 0; i--) {
//       final date = DateTime(
//         now.year,
//         now.month,
//         now.day,
//       ).subtract(Duration(days: i));
//       final key =
//           "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
//       records.add(habit.records[key] ?? HabitDayRecord(date: date));
//     }
//     return records;
//   }

//   // Get all habits with their last [days] records
//   Map<Habit, List<HabitDayRecord>> getAllHabitsLastDays({int days = 5}) {
//     final Map<Habit, List<HabitDayRecord>> map = {};
//     for (final habit in habits) {
//       map[habit] = getLastDaysRecords(habit, days: days);
//     }
//     return map;
//   }
// }
