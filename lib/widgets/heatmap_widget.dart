import 'package:everyday/models/habit.dart';
import 'package:flutter/material.dart';

class HeatmapWidget extends StatefulWidget {
  final Habit habit;
  final bool compact;

  const HeatmapWidget({super.key, required this.habit, this.compact = false});

  @override
  State<HeatmapWidget> createState() => _HeatmapWidgetState();
}

class _HeatmapWidgetState extends State<HeatmapWidget> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _heatmapKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final weeks = widget.compact ? 12 : 53;

    // For full year display, start from beginning of current year
    // For compact display, show last 12 weeks
    late DateTime startDate;
    late DateTime endDate;

    if (widget.compact) {
      endDate = today;
      startDate = today.subtract(Duration(days: weeks * 7));
    } else {
      // Display whole year - from January 1st to current date
      startDate = DateTime(today.year, 1, 1);
      endDate = today; // Only show up to today, not future dates
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.compact) _buildSyncedMonthLabels(startDate, endDate),
        Row(
          children: [
            if (!widget.compact) _buildWeekdayLabels(),
            Expanded(child: _buildHeatmap(startDate, endDate)),
          ],
        ),
        if (!widget.compact) ...[
          const SizedBox(height: 16),
          _buildLegend(context),
        ],
      ],
    );
  }

  Widget _buildSyncedMonthLabels(DateTime startDate, DateTime endDate) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, bottom: 8),
      child: SizedBox(
        height: 20,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) =>
              false, // Don't consume the notification
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: _buildMonthLabelsRow(startDate, endDate),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthLabelsRow(DateTime startDate, DateTime endDate) {
    final months = <Widget>[];

    // Calculate weeks and build month labels that align with heatmap
    DateTime current = _getStartOfWeek(startDate);
    int weekIndex = 0;

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      final weekStart = current;
      final weekEnd = current.add(const Duration(days: 6));

      // Check if this week starts a new month
      final isNewMonth =
          weekIndex == 0 ||
          (weekStart.month !=
              weekStart.subtract(const Duration(days: 7)).month);

      if (isNewMonth) {
        // Find the dominant month in this week
        int monthToShow = weekStart.month;
        if (weekStart.day > 15 && weekEnd.month != weekStart.month) {
          monthToShow = weekEnd.month;
        }

        months.add(
          SizedBox(
            width: 14.0, // Same as week width in heatmap
            child: weekIndex == 0
                ? Text(
                    _getMonthName(monthToShow),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.visible,
                  )
                : Container(),
          ),
        );
      } else {
        months.add(const SizedBox(width: 14.0));
      }

      current = current.add(const Duration(days: 7));
      weekIndex++;

      // Safety check
      if (weekIndex > 60) break;
    }

    // Add month labels at appropriate positions
    final labelWidgets = <Widget>[];
    DateTime labelCurrent = _getStartOfWeek(startDate);
    int currentMonth = labelCurrent.month;
    double currentPosition = 0;

    while (labelCurrent.isBefore(endDate) ||
        labelCurrent.isAtSameMomentAs(endDate)) {
      if (labelCurrent.month != currentMonth ||
          labelCurrent.isAtSameMomentAs(_getStartOfWeek(startDate))) {
        labelWidgets.add(
          Positioned(
            left: currentPosition,
            child: Text(
              _getMonthName(labelCurrent.month),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        );
        currentMonth = labelCurrent.month;
      }

      labelCurrent = labelCurrent.add(const Duration(days: 7));
      currentPosition += 14.0;

      if (labelWidgets.length > 12) break;
    }

    return SizedBox(
      width: currentPosition,
      height: 20,
      child: Stack(children: labelWidgets),
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
                textAlign: TextAlign.end,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildHeatmap(DateTime startDate, DateTime endDate) {
    final weeks = <Widget>[];

    // Start from the beginning of the week that contains startDate
    DateTime current = _getStartOfWeek(startDate);

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      // Only add weeks that have at least one day in our range
      final weekEnd = current.add(const Duration(days: 6));
      if (weekEnd.isAfter(startDate) || weekEnd.isAtSameMomentAs(startDate)) {
        weeks.add(_buildWeek(current, startDate, endDate));
      }

      current = current.add(const Duration(days: 7));

      // Safety check to prevent infinite loop
      if (weeks.length > 60) break;
    }

    return SingleChildScrollView(
      key: _heatmapKey,
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(children: weeks),
    );
  }

  Widget _buildWeek(
    DateTime weekStart,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final days = <Widget>[];
    final today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));

      // Only show days that are:
      // 1. Within our date range
      // 2. Not in the future (beyond today)
      if (date.isAfter(rangeEnd) ||
          date.isBefore(rangeStart) ||
          date.isAfter(today)) {
        days.add(_buildEmptyDay());
      } else {
        days.add(_buildDay(date));
      }
    }

    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Column(children: days),
    );
  }

  Widget _buildDay(DateTime date) {
    final completionPercentage = widget.habit.getCompletionPercentage(date);
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

  Widget _buildEmptyDay() {
    return Container(width: 10, height: 10, margin: const EdgeInsets.all(1));
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

    final baseColor = widget.habit.color;
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
