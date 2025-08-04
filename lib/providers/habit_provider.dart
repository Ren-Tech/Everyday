import 'package:everyday/models/habit.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HabitProvider extends ChangeNotifier {
  Box<Habit>? _habitsBox;

  HabitProvider() {
    _init();
  }

  Future<void> _init() async {
    _habitsBox = await Hive.openBox<Habit>('habits');
    notifyListeners();
  }

  List<Habit> get habits => _habitsBox?.values.toList() ?? [];

  void addHabit(Habit habit) {
    _habitsBox?.add(habit);
    notifyListeners();
  }

  void updateHabit(String habitId, Habit updatedHabit) {
    final habit = _habitsBox?.values.firstWhere((h) => h.id == habitId);
    if (habit == null) return;

    final index = _habitsBox!.values.toList().indexOf(habit);
    if (index != -1) {
      _habitsBox!.putAt(index, updatedHabit);
      notifyListeners();
    }
  }

  void deleteHabit(String habitId) {
    final habit = _habitsBox?.values.firstWhere((h) => h.id == habitId);
    habit?.delete();
    notifyListeners();
  }

  void incrementHabitCompletion(String habitId, DateTime date) {
    final habit = _habitsBox?.values.firstWhere((h) => h.id == habitId);
    if (habit == null) return;

    final normalizedDate = DateTime(date.year, date.month, date.day);
    final updatedCompletions = Map<DateTime, int>.from(habit.completions);
    final currentCount = updatedCompletions[normalizedDate] ?? 0;
    updatedCompletions[normalizedDate] = currentCount + 1;

    updateHabit(habitId, habit.copyWith(completions: updatedCompletions));
  }

  void decrementHabitCompletion(String habitId, DateTime date) {
    final habit = _habitsBox?.values.firstWhere((h) => h.id == habitId);
    if (habit == null) return;

    final normalizedDate = DateTime(date.year, date.month, date.day);
    final updatedCompletions = Map<DateTime, int>.from(habit.completions);
    final currentCount = updatedCompletions[normalizedDate] ?? 0;
    if (currentCount > 0) {
      updatedCompletions[normalizedDate] = currentCount - 1;
      updateHabit(habitId, habit.copyWith(completions: updatedCompletions));
    }
  }

  List<Habit> getHabitsByCategory(Category category) {
    return _habitsBox?.values
            .where((habit) => habit.category == category)
            .toList() ??
        [];
  }
}
