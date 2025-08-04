import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:everyday/models/habit.dart';
import 'package:everyday/widgets/heatmap_widget.dart';

class HabitHeatmapScreen extends StatelessWidget {
  final Habit habit;

  const HabitHeatmapScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width >= 600;

    final completions = habit.completions;
    final completionDates = completions.keys.toList();
    final totalCompletions = _calculateTotalCompletions(completions);
    final firstDate = _getFirstCompletionDate(completionDates);
    final daysTracked = _calculateDaysTracked(firstDate);
    final completionRate = _calculateCompletionRate(
      totalCompletions,
      daysTracked,
    );
    final currentStreak = _calculateCurrentStreak(completionDates);
    final longestStreak = _calculateLongestStreak(completionDates);
    final mostProductiveDay = _calculateMostProductiveDay(completionDates);
    final mostProductiveDayCount = _getMostProductiveDayCount(completionDates);

    return Scaffold(
      appBar: AppBar(title: Text('${habit.name} Activity'), elevation: 0),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWideScreen ? 32 : 16,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateRangeHeader(context, firstDate),
                const SizedBox(height: 24),
                _buildStatisticsGrid(
                  context,
                  isWideScreen: isWideScreen,
                  totalCompletions: totalCompletions,
                  daysTracked: daysTracked,
                  completionRate: completionRate,
                  currentStreak: currentStreak,
                  longestStreak: longestStreak,
                ),
                if (mostProductiveDay.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildDayCard(
                    context,
                    day: mostProductiveDay,
                    count: mostProductiveDayCount,
                    color: habit.color,
                  ),
                ],
                const SizedBox(height: 32),
                _buildHeatmapSection(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateRangeHeader(BuildContext context, DateTime firstDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Overview',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          '${DateFormat('MMM d, yyyy').format(firstDate)} - ${DateFormat('MMM d, yyyy').format(DateTime.now())}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildStatisticsGrid(
    BuildContext context, {
    required bool isWideScreen,
    required int totalCompletions,
    required int daysTracked,
    required double completionRate,
    required int currentStreak,
    required int longestStreak,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Stats',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isWideScreen ? 3 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isWideScreen ? 1.8 : 1.6,
          children: [
            _buildStatCard(
              context,
              title: 'Completed',
              value: '$totalCompletions',
              subtitle: '${habit.targetCount} per day target',
              icon: Icons.check_circle,
              color: habit.color,
            ),
            _buildStatCard(
              context,
              title: 'Consistency',
              value: '${(completionRate * 100).toStringAsFixed(0)}%',
              subtitle: '$daysTracked days tracked',
              icon: Icons.trending_up,
              color: habit.color,
            ),
            _buildStatCard(
              context,
              title: 'Current Streak',
              value: '$currentStreak',
              subtitle: currentStreak == 1 ? 'day' : 'days',
              icon: Icons.local_fire_department,
              color: habit.color,
            ),
            _buildStatCard(
              context,
              title: 'Record Streak',
              value: '$longestStreak',
              subtitle: longestStreak == 1 ? 'day' : 'days',
              icon: Icons.star,
              color: habit.color,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(
    BuildContext context, {
    required String day,
    required int count,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 16, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Best Day',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                day,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '$count completions',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Heatmap',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        HeatmapWidget(habit: habit, compact: false),
        const SizedBox(height: 16),
        _buildHeatmapLegend(context, habit.color),
      ],
    );
  }

  Widget _buildHeatmapLegend(BuildContext context, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Less', style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(width: 8),
        Container(width: 12, height: 12, color: color.withOpacity(0.1)),
        ...List.generate(4, (index) {
          final intensity = (index + 1) / 4;
          return Container(
            width: 12,
            height: 12,
            color: Color.lerp(color.withOpacity(0.1), color, intensity),
          );
        }),
        const SizedBox(width: 8),
        Text('More', style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  int _calculateTotalCompletions(Map<DateTime, int> completions) {
    return completions.values.fold(0, (sum, count) => sum + count);
  }

  DateTime _getFirstCompletionDate(List<DateTime> dates) {
    if (dates.isEmpty) return DateTime.now();
    return dates.reduce((a, b) => a.isBefore(b) ? a : b);
  }

  int _calculateDaysTracked(DateTime firstDate) {
    return DateTime.now().difference(firstDate).inDays + 1;
  }

  double _calculateCompletionRate(int totalCompletions, int daysTracked) {
    if (daysTracked == 0) return 0.0;
    return totalCompletions / (daysTracked * habit.targetCount);
  }

  int _calculateCurrentStreak(List<DateTime> dates) {
    dates.sort((a, b) => b.compareTo(a));
    if (dates.isEmpty) return 0;

    int streak = 0;
    DateTime currentDate = DateTime.now();
    final today = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );

    if (dates.any((d) => d.isAtSameMomentAs(today))) {
      streak = 1;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }

    for (final date in dates) {
      final compareDate = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      );
      if (date.isAtSameMomentAs(compareDate)) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else if (date.isBefore(compareDate)) {
        break;
      }
    }

    return streak;
  }

  int _calculateLongestStreak(List<DateTime> dates) {
    dates.sort();
    if (dates.isEmpty) return 0;

    int longestStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < dates.length; i++) {
      final previousDate = dates[i - 1];
      final currentDate = dates[i];

      if (currentDate.difference(previousDate).inDays == 1) {
        currentStreak++;
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
      } else {
        currentStreak = 1;
      }
    }

    return longestStreak;
  }

  String _calculateMostProductiveDay(List<DateTime> dates) {
    final dayCounts = <int, int>{};
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    for (final date in dates) {
      final weekday = date.weekday;
      dayCounts[weekday] = (dayCounts[weekday] ?? 0) + 1;
    }

    if (dayCounts.isEmpty) return '';
    final mostFrequentDay = dayCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    return dayNames[mostFrequentDay % 7];
  }

  int _getMostProductiveDayCount(List<DateTime> dates) {
    final dayCounts = <int, int>{};
    for (final date in dates) {
      final weekday = date.weekday;
      dayCounts[weekday] = (dayCounts[weekday] ?? 0) + 1;
    }
    if (dayCounts.isEmpty) return 0;
    return dayCounts.entries.reduce((a, b) => a.value > b.value ? a : b).value;
  }
}
