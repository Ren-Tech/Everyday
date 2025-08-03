import 'package:everyday/models/habit.dart';
import 'package:flutter/material.dart';

class HabitProvider extends ChangeNotifier {
  final List<Habit> _habits = [];

  List<Habit> get habits => List.unmodifiable(_habits);

  void addHabit(Habit habit) {
    _habits.add(habit);
    notifyListeners();
  }

  void updateHabit(String habitId, Habit updatedHabit) {
    final index = _habits.indexWhere((habit) => habit.id == habitId);
    if (index != -1) {
      _habits[index] = updatedHabit;
      notifyListeners();
    }
  }

  void deleteHabit(String habitId) {
    _habits.removeWhere((habit) => habit.id == habitId);
    notifyListeners();
  }

  void incrementHabitCompletion(String habitId, DateTime date) {
    final habit = _habits.firstWhere((h) => h.id == habitId);
    final normalizedDate = DateTime(date.year, date.month, date.day);

    final updatedCompletions = Map<DateTime, int>.from(habit.completions);
    final currentCount = updatedCompletions[normalizedDate] ?? 0;
    updatedCompletions[normalizedDate] = currentCount + 1;

    updateHabit(habitId, habit.copyWith(completions: updatedCompletions));
  }

  void decrementHabitCompletion(String habitId, DateTime date) {
    final habit = _habits.firstWhere((h) => h.id == habitId);
    final normalizedDate = DateTime(date.year, date.month, date.day);

    final updatedCompletions = Map<DateTime, int>.from(habit.completions);
    final currentCount = updatedCompletions[normalizedDate] ?? 0;
    if (currentCount > 0) {
      updatedCompletions[normalizedDate] = currentCount - 1;
      updateHabit(habitId, habit.copyWith(completions: updatedCompletions));
    }
  }

  List<Habit> getHabitsByCategory(Category category) {
    return _habits.where((habit) => habit.category == category).toList();
  }
}
