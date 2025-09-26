import 'package:flutter/material.dart';
import 'package:productive_360_app/models/habit.dart';
import 'package:productive_360_app/models/habit_collection.dart';
import 'package:productive_360_app/views/widgets/habit_dialog.dart';
import '../../data/dal/db_access.dart' as db_access;

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  void _addHabitDialog(BuildContext context) async {
    final Habit? newHabit = await showDialog<Habit>(
      context: context,
      builder: (context) => AddHabitDialog(),
    );
    if (newHabit != null) {
      await db_access.addHabit(newHabit);
    }
  }

  void _toggleDay(Habit habit, DateTime date, BuildContext context) async {
    final key =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    HabitDayRecord record = habit.records[key] ?? HabitDayRecord(date: date);

    if (habit.type == HabitType.checkbox) {
      record.isCompleted = !record.isCompleted;
      habit.records[key] = record;
      await db_access.updateHabit(habit);
    } else if (habit.type == HabitType.timeSpent) {
      final minutes = await showDialog<int>(
        context: context,
        builder: (context) {
          int? enteredMinutes;
          return AlertDialog(
            title: Text('Enter minutes spent'),
            content: TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Minutes'),
              onChanged: (value) {
                enteredMinutes = int.tryParse(value);
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(enteredMinutes ?? 0);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      if (minutes != null && minutes > 0) {
        record.timeSpent = Duration(minutes: minutes);
        record.isCompleted = record.timeSpent >= habit.durationToComplete;
        habit.records[key] = record;
        await db_access.updateHabit(habit);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF23243B) : Colors.white;
    final bgColor = isDark ? const Color(0xFF18192A) : const Color(0xFFF8F9FF);
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final iconColor = isDark
        ? const Color(0xFF8C9EFF)
        : const Color(0xFF4F5DFF);
    final textColor = isDark ? Colors.white : const Color(0xFF2B2D42);
    final dateActiveColor = isDark
        ? const Color(0xFF4F5DFF)
        : const Color(0xFF4F5DFF);
    final dateInactiveColor = isDark
        ? const Color(0xFF23243B)
        : const Color(0xFFF0F1F7);

    return StreamBuilder<List<Habit>>(
      stream: db_access.habitsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final habits = snapshot.data!;
        return Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Current Habits',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: textColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: iconColor),
                      onPressed: () => _addHabitDialog(context),
                      tooltip: 'Add Habit',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: habits.isEmpty
                      ? Center(
                          child: Text(
                            'No habits yet. Add one!',
                            style: TextStyle(color: textColor),
                          ),
                        )
                      : ListView.separated(
                          itemCount: habits.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: 24, color: borderColor),
                          itemBuilder: (context, index) {
                            final habit = habits[index];
                            final last5 = HabitCollection().getLastDaysRecords(
                              habit,
                              days: 5,
                            );
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            habit.icon,
                                            color: iconColor,
                                            size: 28,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              habit.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: textColor,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            tooltip: 'Delete Habit',
                                            onPressed: () async {
                                              await db_access.deleteHabit(
                                                habit,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: last5.map((record) {
                                          final isToday = DateUtils.isSameDay(
                                            record.date,
                                            DateTime.now(),
                                          );
                                          return GestureDetector(
                                            onTap: () => _toggleDay(
                                              habit,
                                              record.date,
                                              context,
                                            ),
                                            child: Container(
                                              width: 38,
                                              height: 38,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: record.isCompleted
                                                    ? dateActiveColor
                                                    : dateInactiveColor,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: isToday
                                                    ? Border.all(
                                                        color: dateActiveColor,
                                                        width: 2,
                                                      )
                                                    : null,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${record.date.day}',
                                                  style: TextStyle(
                                                    color: record.isCompleted
                                                        ? Colors.white
                                                        : dateActiveColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
