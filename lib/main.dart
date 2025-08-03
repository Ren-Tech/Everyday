// main.dart
import 'package:everyday/providers/habit_provider.dart';
import 'package:everyday/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: MaterialApp(
        title: 'Habit Tracker',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C5CE7),
            brightness: Brightness.light,
          ),
          fontFamily: 'Inter',
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C5CE7),
            brightness: Brightness.dark,
          ),
          fontFamily: 'Inter',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

// models/habit.dart


// providers/habit_provider.dart


// screens/home_screen.dart


// widgets/stats_overview.dart


// widgets/habit_card.dart

// widgets/heatmap_widget.dart


// widgets/add_habit_dialog.dart

// widgets/habit_detail_dialog.dart


// pubspec.yaml dependencies:
/*
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
*/
