import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../navBar.dart';
import 'home_controller.dart';
import '../../routes.dart';
import 'home_model.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // This disables the automatic back button

        title: Center(
          child: const Text(
            'Smash Goals Today',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed(Routes.goalStep1),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(currentIndex: 0),
      body: Obx(() {
        if (controller.isLoading.value && controller.homeData.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.error.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        final data = controller.homeData.value!;

        // Empty state handling
        if (data.todayHabits.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'You have crush your goals for today!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Come back tomorrow or add new goals to keep the momentum going.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed(Routes.goalStep1),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Goal'),
                  ),
                ],
              ),
            ),
          );
        }

        // Sort habits: Active/Overdue first, then upcoming by time, completed last
        final sortedHabits = _sortHabitsByPriority(data.todayHabits);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today Habits
              ...sortedHabits.map(
                (h) => HabitCard(
                  habit: h,
                  onLogPress: () => Get.toNamed('/tasks/${h.id}/complete'),
                ),
              ),
              const SizedBox(height: 32),

              // Progress
              Text(
                'Progress',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ProgressBars(progress: data.progress),
              const SizedBox(height: 32),

              // AI Insight
              Text(
                'AI Insight',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              InsightCard(insight: data.insight),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }

  List<HabitModel> _sortHabitsByPriority(List<HabitModel> habits) {
    final sorted = List<HabitModel>.from(habits);
    sorted.sort((a, b) {
      // Completed habits go last
      if (a.isCompleted && !b.isCompleted) return 1;
      if (!a.isCompleted && b.isCompleted) return -1;

      // Among incomplete: Active/Overdue first
      if (a.isActive && !b.isActive) return -1;
      if (!a.isActive && b.isActive) return 1;

      if (a.isOverdue && !b.isOverdue) return -1;
      if (!a.isOverdue && b.isOverdue) return 1;

      // Sort upcoming by start time
      return a.startDateTime.compareTo(b.startDateTime);
    });
    return sorted;
  }
}

class HabitCard extends StatefulWidget {
  final HabitModel habit;
  final VoidCallback onLogPress;

  const HabitCard({super.key, required this.habit, required this.onLogPress});

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon with background
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  _getHabitIcon(widget.habit.name),
                  size: 20,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),

              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.habit.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Status dot
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getStatusColor(context),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.habit.formattedTimeRange,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    // Show countdown/status text when relevant
                    if (_getStatusText() != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _getStatusText()!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Log Button
              ElevatedButton(
                onPressed: widget.onLogPress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.habit.isCompleted
                      ? theme.colorScheme.primary.withOpacity(0.1)
                      : theme.colorScheme.primary,
                  foregroundColor: widget.habit.isCompleted
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(60, 32),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.habit.isCompleted)
                      const Icon(Icons.check, size: 16)
                    else
                      const SizedBox.shrink(),
                    if (widget.habit.isCompleted)
                      const SizedBox(width: 4)
                    else
                      const SizedBox.shrink(),
                    Text(
                      widget.habit.isCompleted ? 'Logged' : 'Log',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.habit.isCompleted) {
      return theme.colorScheme.onSurface.withOpacity(0.3);
    }

    if (widget.habit.isActive) {
      return Colors.green.withOpacity(0.7);
    }

    if (widget.habit.isOverdue) {
      return Colors.amber.shade700.withOpacity(0.7);
    }

    // Upcoming
    return theme.colorScheme.onSurface.withOpacity(0.4);
  }

  String? _getStatusText() {
    if (widget.habit.isCompleted) {
      return null; // No need to show status for completed habits
    }

    if (widget.habit.isActive) {
      final remaining = widget.habit.timeUntilEnd.inMinutes;
      if (remaining > 0) {
        return '$remaining min remaining';
      }
    }

    if (widget.habit.isOverdue) {
      final overdue = DateTime.now()
          .difference(widget.habit.endDateTime)
          .inMinutes;
      return 'Overdue by $overdue min';
    }

    if (widget.habit.isUpcoming) {
      final until = widget.habit.timeUntilStart.inMinutes;
      if (until <= 30) {
        return 'Starts in $until min';
      }
    }

    return null; // Don't show text for habits starting later
  }

  IconData _getHabitIcon(String habitName) {
    final name = habitName.toLowerCase();
    if (name.contains('meditat')) return Icons.self_improvement;
    if (name.contains('read')) return Icons.menu_book;
    if (name.contains('exerc') || name.contains('workout'))
      return Icons.fitness_center;
    if (name.contains('water')) return Icons.water_drop;
    if (name.contains('sleep')) return Icons.bedtime;
    if (name.contains('walk')) return Icons.directions_walk;
    return Icons.check_circle_outline;
  }
}

class ProgressBars extends StatelessWidget {
  final ProgressModel progress;

  const ProgressBars({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SingleBar(
          label: 'Daily Habits',
          done: progress.dailyDone,
          total: progress.dailyTotal,
        ),
        const SizedBox(height: 12),
        _SingleBar(
          label: 'Weekly Goals',
          done: progress.weeklyDone,
          total: progress.weeklyTotal,
        ),
      ],
    );
  }
}

class _SingleBar extends StatelessWidget {
  final String label;
  final int done;
  final int total;

  const _SingleBar({
    required this.label,
    required this.done,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final value = total == 0 ? 0.0 : done / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              '$done/$total',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

class InsightCard extends StatelessWidget {
  final InsightModel insight;

  const InsightCard({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.primary.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                insight.text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
