import 'package:everyday/providers/habit_provider.dart';
import 'package:everyday/screens/add_habit_screen.dart';
import 'package:everyday/widgets/habit_card.dart';
import 'package:everyday/widgets/stats_overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Habits',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, size: 22),
            onPressed: () => _showStats(context),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Consumer<HabitProvider>(
          builder: (context, habitProvider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const StatsOverview(),
                  // Removed the gap below StatsOverview
                  if (habitProvider.habits.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom:
                            bottomPadding + kFloatingActionButtonMargin + 80,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.track_changes,
                                size: screenHeight * 0.08,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No habits yet!',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              child: Text(
                                'Start building better habits today',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.6),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        for (var i = 0; i < habitProvider.habits.length; i++)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 12,
                              top: i == 0
                                  ? 0
                                  : 0, // removed top spacing for first item
                            ),
                            child: HabitCard(habit: habitProvider.habits[i]),
                          ),
                      ],
                    ),
                  SizedBox(height: bottomPadding + 70),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddHabitScreen()),
            );
          },
          icon: const Icon(Icons.add, size: 20),
          label: const Text('Add Habit', style: TextStyle(fontSize: 14)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  void _showStats(BuildContext context) {
    // TODO: Implement stats screen
  }
}
