import 'package:everyday/models/habit.dart';
import 'package:flutter/material.dart';

class HeatmapWidget extends StatelessWidget {
  final Habit habit;
  final bool compact;

  const HeatmapWidget({super.key, required this.habit, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final weeks = compact ? 12 : 53;
    final endDate = today;
    final startDate = today.subtract(Duration(days: weeks * 7));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!compact) _buildMonthLabels(startDate, endDate),
        Row(
          children: [
            if (!compact) _buildWeekdayLabels(),
            Expanded(child: _buildHeatmap(startDate, endDate)),
          ],
        ),
        if (!compact) ...[const SizedBox(height: 16), _buildLegend(context)],
      ],
    );
  }

  Widget _buildMonthLabels(DateTime startDate, DateTime endDate) {
    final months = <Widget>[];
    DateTime current = DateTime(startDate.year, startDate.month, 1);

    while (current.isBefore(endDate)) {
      final daysInView = _getDaysInMonth(current, startDate, endDate);
      if (daysInView > 0) {
        months.add(
          SizedBox(
            width: (daysInView / 7) * 12.0,
            child: Text(
              _getMonthName(current.month),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        );
      }
      current = DateTime(current.year, current.month + 1, 1);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 30, bottom: 8),
      child: Row(children: months),
    );
  }

  Widget _buildWeekdayLabels() {
    const weekdays = ['', 'Mon', '', 'Wed', '', 'Fri', ''];
    return Column(
      children: weekdays
          .map(
            (day) => SizedBox(
              height: 12,
              width: 30,
              child: Text(
                day,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildHeatmap(DateTime startDate, DateTime endDate) {
    final weeks = <Widget>[];
    DateTime current = _getStartOfWeek(startDate);

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      weeks.add(_buildWeek(current));
      current = current.add(const Duration(days: 7));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: weeks),
    );
  }

  Widget _buildWeek(DateTime weekStart) {
    final days = <Widget>[];

    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      days.add(_buildDay(date));
    }

    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Column(children: days),
    );
  }

  Widget _buildDay(DateTime date) {
    final completionPercentage = habit.getCompletionPercentage(date);
    final color = _getColorForCompletion(completionPercentage);
    final isToday = _isSameDay(date, DateTime.now());

    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        border: isToday ? Border.all(color: Colors.black, width: 1) : null,
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      children: [
        const Text('Less', style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(width: 8),
        ...List.generate(5, (index) {
          final intensity = index / 4;
          return Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: _getColorForCompletion(intensity),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
        const SizedBox(width: 8),
        const Text('More', style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Color _getColorForCompletion(double completion) {
    if (completion == 0) return const Color(0xFFEBEDF0);

    final baseColor = habit.color;
    if (completion >= 1.0) return baseColor;

    // GitHub-style intensity levels
    if (completion > 0.75) return baseColor;
    if (completion > 0.5) return baseColor.withOpacity(0.7);
    if (completion > 0.25) return baseColor.withOpacity(0.4);
    return baseColor.withOpacity(0.2);
  }

  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  int _getDaysInMonth(DateTime month, DateTime startDate, DateTime endDate) {
    final monthStart = DateTime(month.year, month.month, 1);
    final monthEnd = DateTime(month.year, month.month + 1, 0);

    final visibleStart = monthStart.isBefore(startDate)
        ? startDate
        : monthStart;
    final visibleEnd = monthEnd.isAfter(endDate) ? endDate : monthEnd;

    return visibleEnd.difference(visibleStart).inDays + 1;
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
