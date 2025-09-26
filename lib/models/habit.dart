import 'package:flutter/material.dart';

enum HabitType {
  checkbox, // Simple done/not done
  timeSpent, // Requires entering time spent
}

class HabitDayRecord {
  final DateTime date;
  bool isCompleted;
  Duration timeSpent;

  HabitDayRecord({
    required this.date,
    this.isCompleted = false,
    this.timeSpent = Duration.zero,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'isCompleted': isCompleted,
    'timeSpent': timeSpent.inMinutes,
  };
}

class Habit {
  final String name;
  final IconData icon;
  final HabitType type;
  final Duration durationToComplete; // Target duration to complete the habit

  // Map of date (yyyy-MM-dd) to record for that day
  final Map<String, HabitDayRecord> records = {};

  Habit({
    required this.name,
    required this.icon,
    required this.type,
    required this.durationToComplete,
  });

  // Helper to get today's record (creates if not exists)
  HabitDayRecord getTodayRecord() {
    final todayKey = _dateKey(DateTime.now());
    return records.putIfAbsent(
      todayKey,
      () => HabitDayRecord(date: DateTime.now()),
    );
  }

  // Mark as completed for a specific date (default: today)
  void toggleCompleted({DateTime? date}) {
    final key = _dateKey(date ?? DateTime.now());
    final record = records.putIfAbsent(
      key,
      () => HabitDayRecord(date: date ?? DateTime.now()),
    );
    if (type == HabitType.checkbox) {
      record.isCompleted = !record.isCompleted;
    }
  }

  // Add time for a specific date (default: today)
  void addTime(Duration duration, {DateTime? date}) {
    final key = _dateKey(date ?? DateTime.now());
    final record = records.putIfAbsent(
      key,
      () => HabitDayRecord(date: date ?? DateTime.now()),
    );
    if (type == HabitType.timeSpent) {
      record.timeSpent += duration;
      if (record.timeSpent >= durationToComplete) {
        record.isCompleted = true;
      }
    }
  }

  // Reset record for a specific date (default: today)
  void reset({DateTime? date}) {
    final key = _dateKey(date ?? DateTime.now());
    records[key] = HabitDayRecord(date: date ?? DateTime.now());
  }

  // Helper to get a key for a date
  String _dateKey(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  Map<String, dynamic> toJson() => {
    'name': name,
    'icon': icon.codePoint,
    'iconFontFamily': icon.fontFamily,
    'type': type.index,
    'durationToComplete': durationToComplete.inMinutes,
    'records': records.map((k, v) => MapEntry(k, v.toJson())),
  };
}
