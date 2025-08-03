import 'package:everyday/models/habit.dart';
import 'package:everyday/providers/habit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  Category _selectedCategory = Category.health;
  GoalType _selectedGoalType = GoalType.daily;
  int _targetCount = 1;
  TimeOfDay? _reminderTime;
  Color _selectedColor = const Color(0xFF6C5CE7);

  final List<Color> _availableColors = [
    const Color(0xFF6C5CE7),
    const Color(0xFF00B894),
    const Color(0xFFE17055),
    const Color(0xFF0984E3),
    const Color(0xFFE84393),
    const Color(0xFFFDCB6E),
    const Color(0xFF6C5CE7),
    const Color(0xFF00CEC9),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Habit'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Habit Name',
              hint: 'e.g., Drink 8 glasses of water',
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description (Optional)',
              hint: 'Why is this habit important to you?',
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Category'),
            const SizedBox(height: 12),
            _buildCategorySelector(),
            const SizedBox(height: 24),
            _buildSectionTitle('Goal'),
            const SizedBox(height: 12),
            _buildGoalSelector(),
            const SizedBox(height: 24),
            _buildSectionTitle('Color'),
            const SizedBox(height: 12),
            _buildColorSelector(),
            const SizedBox(height: 24),
            _buildSectionTitle('Reminder (Optional)'),
            const SizedBox(height: 12),
            _buildReminderSelector(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saveHabit,
                style: FilledButton.styleFrom(
                  backgroundColor: _selectedColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Create Habit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildCategorySelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: Category.values.map((category) {
        final isSelected = _selectedCategory == category;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = category),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? _selectedColor.withOpacity(0.1)
                  : Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(color: _selectedColor) : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getCategoryIcon(category),
                  size: 18,
                  color: isSelected ? _selectedColor : null,
                ),
                const SizedBox(width: 8),
                Text(
                  _getCategoryName(category),
                  style: TextStyle(
                    color: isSelected ? _selectedColor : null,
                    fontWeight: isSelected ? FontWeight.w600 : null,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGoalSelector() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Target',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: _targetCount > 1
                          ? () => setState(() => _targetCount--)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: _selectedColor,
                    ),
                    Expanded(
                      child: Text(
                        '$_targetCount',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _targetCount++),
                      icon: const Icon(Icons.add_circle_outline),
                      color: _selectedColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Frequency',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButton<GoalType>(
                  value: _selectedGoalType,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  items: GoalType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_getGoalTypeName(type)),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedGoalType = value!),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Wrap(
      spacing: 12,
      children: _availableColors.map((color) {
        final isSelected = _selectedColor == color;
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 3,
                    )
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReminderSelector() {
    return GestureDetector(
      onTap: _selectReminderTime,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.notifications_outlined, color: _selectedColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _reminderTime != null
                    ? 'Daily at ${_reminderTime!.format(context)}'
                    : 'Set daily reminder',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            if (_reminderTime != null)
              IconButton(
                onPressed: () => setState(() => _reminderTime = null),
                icon: const Icon(Icons.clear),
              ),
          ],
        ),
      ),
    );
  }

  void _selectReminderTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (time != null) {
      setState(() => _reminderTime = time);
    }
  }

  void _saveHabit() {
    if (_nameController.text.trim().isEmpty) return;

    final habit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      color: _selectedColor,
      category: _selectedCategory,
      goalType: _selectedGoalType,
      targetCount: _targetCount,
      reminderTime: _reminderTime,
    );

    context.read<HabitProvider>().addHabit(habit);
    Navigator.pop(context);
  }

  IconData _getCategoryIcon(Category category) {
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

  String _getCategoryName(Category category) {
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

  String _getGoalTypeName(GoalType type) {
    switch (type) {
      case GoalType.daily:
        return 'Daily';
      case GoalType.weekly:
        return 'Weekly';
      case GoalType.monthly:
        return 'Monthly';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
