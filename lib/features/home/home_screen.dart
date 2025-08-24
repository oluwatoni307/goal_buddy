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
        title: Center(child: const Text('Today is a great day to smash goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed(Routes.goalStep1),
          ),
        
        ],
      ),
      bottomNavigationBar: NavBar(currentIndex: 0), // for home

      body: Obx(
        () {
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
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Today Habits
             
                ...data.todayHabits.map(
                  (h) => HabitCard(
                    habit: h,
                    onLogPress: () => Get.toNamed('/tasks/${h.id}/complete'),
                  ),
                ),
                const SizedBox(height: 24),

                // Progress
                Text('Progress', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                ProgressBars(progress: data.progress),
                const SizedBox(height: 24),

                // AI Insight
                Text('AI Insight', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                InsightCard(insight: data.insight),
              ],
            ),
          );
        },
      ),
    );
  }
}


class HabitCard extends StatefulWidget {
  final HabitModel habit;
  final VoidCallback onLogPress;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onLogPress,
  });

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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
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
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDuration(widget.habit.minutes),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(60, 32),
                ),
                child: Text(
                  widget.habit.isCompleted ? 'Logged' : 'Log',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getHabitIcon(String habitName) {
    final name = habitName.toLowerCase();
    if (name.contains('meditat')) return Icons.self_improvement;
    if (name.contains('read')) return Icons.menu_book;
    if (name.contains('exerc') || name.contains('workout')) return Icons.fitness_center;
    if (name.contains('water')) return Icons.water_drop;
    if (name.contains('sleep')) return Icons.bedtime;
    if (name.contains('walk')) return Icons.directions_walk;
    return Icons.check_circle_outline;
  }

  String _formatDuration(int minutes) {
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '${hours} hour${hours > 1 ? 's' : ''}';
      }
      return '${hours}h ${remainingMinutes}m';
    }
    return '${minutes} min';
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
        const SizedBox(height: 8),
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
        Text('$label  $done/$total'),
        const SizedBox(height: 4),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          insight.text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}