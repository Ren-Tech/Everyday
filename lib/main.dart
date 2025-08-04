// main.dart
import 'package:everyday/models/habit.dart';
import 'package:everyday/providers/habit_provider.dart';
import 'package:everyday/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async initialization
  await Hive.initFlutter(); // Initialize Hive
  Hive.registerAdapter(HabitAdapter()); // Register adapters
  Hive.registerAdapter(GoalTypeAdapter());
  Hive.registerAdapter(CategoryAdapter());

  await Hive.openBox<Habit>('habitsBox'); // Open the box

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
