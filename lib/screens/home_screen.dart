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
      body: SafeArea(
        bottom: false, // We'll handle bottom padding manually
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar.large(
              backgroundColor: Colors.transparent,
              pinned: true,
              title: const Text(
                'Habits',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.analytics_outlined),
                  onPressed: () => _showStats(context),
                ),
              ],
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: StatsOverview(),
              ),
            ),
            Consumer<HabitProvider>(
              builder: (context, habitProvider, child) {
                if (habitProvider.habits.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom:
                            bottomPadding + kFloatingActionButtonMargin + 80,
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                      .withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.track_changes,
                                  size: screenHeight * 0.1,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'No habits yet!',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                ),
                                child: Text(
                                  'Start building better habits today',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final habit = habitProvider.habits[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: 16,
                          // Add extra padding for the last item to avoid FAB overlap
                          top: index == 0 ? 8 : 0,
                        ),
                        child: HabitCard(habit: habit),
                      );
                    }, childCount: habitProvider.habits.length),
                  ),
                );
              },
            ),
            // Add extra space at the bottom to account for FAB
            SliverToBoxAdapter(
              child: SizedBox(
                height: bottomPadding + 80, // FAB height + margin
              ),
            ),
          ],
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

          icon: const Icon(Icons.add),
          label: const Text('Add Habit'),
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
