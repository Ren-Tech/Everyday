import 'package:flutter/material.dart';

enum GoalType { daily, weekly, monthly }

enum Category {
  health,
  productivity,
  learning,
  fitness,
  mindfulness,
  social,
  finance,
  other,
}

class Habit {
  final String id;
  final String name;
  final String description;
  final Color color;
  final Category category;
  final GoalType goalType;
  final int targetCount;
  final TimeOfDay? reminderTime;
  final Map<DateTime, int> completions;
  final DateTime createdAt;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.category,
    required this.goalType,
    required this.targetCount,
    this.reminderTime,
    Map<DateTime, int>? completions,
    DateTime? createdAt,
  }) : completions = completions ?? {},
       createdAt = createdAt ?? DateTime.now();

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    Color? color,
    Category? category,
    GoalType? goalType,
    int? targetCount,
    TimeOfDay? reminderTime,
    Map<DateTime, int>? completions,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      category: category ?? this.category,
      goalType: goalType ?? this.goalType,
      targetCount: targetCount ?? this.targetCount,
      reminderTime: reminderTime ?? this.reminderTime,
      completions: completions ?? this.completions,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  int getCompletionCount(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return completions[normalizedDate] ?? 0;
  }

  bool isCompletedOn(DateTime date) {
    return getCompletionCount(date) >= targetCount;
  }

  double getCompletionPercentage(DateTime date) {
    final count = getCompletionCount(date);
    return targetCount > 0 ? (count / targetCount).clamp(0.0, 1.0) : 0.0;
  }

  int getCurrentStreak() {
    int streak = 0;
    DateTime currentDate = DateTime.now();

    while (true) {
      final normalizedDate = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      );
      if (isCompletedOn(normalizedDate)) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  String get categoryName {
    switch (category) {
      case Category.health:
        return 'Health';
      case Category.productivity:
        return 'Productivity';
      case Category.learning:
        return 'Learning';
      case Category.fitness:
        return 'Fitness';
      case Category.mindfulness:
        return 'Mindfulness';
      case Category.social:
        return 'Social';
      case Category.finance:
        return 'Finance';
      case Category.other:
        return 'Other';
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case Category.health:
        return Icons.favorite;
      case Category.productivity:
        return Icons.work;
      case Category.learning:
        return Icons.school;
      case Category.fitness:
        return Icons.fitness_center;
      case Category.mindfulness:
        return Icons.self_improvement;
      case Category.social:
        return Icons.people;
      case Category.finance:
        return Icons.account_balance_wallet;
      case Category.other:
        return Icons.category;
    }
  }

  String get goalTypeText {
    switch (goalType) {
      case GoalType.daily:
        return 'Daily';
      case GoalType.weekly:
        return 'Weekly';
      case GoalType.monthly:
        return 'Monthly';
    }
  }
}
