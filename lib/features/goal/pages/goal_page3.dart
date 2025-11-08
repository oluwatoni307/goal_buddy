// UPDATED Milestone Detail Screen with Non-Blocking Smart Loading
// MODERNIZED with Material 3 and Controller-First Navigation
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../goal_controller.dart';
import '../goal_model.dart';

class MilestoneDetailScreen extends GetView<GoalDisplayController> {
  const MilestoneDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final milestoneId = Get.parameters['id'] ?? '';

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
        ),
        title: Text(
          'Milestone Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        // ✅ Load milestone data independently (non-blocking)
        if (controller.currentMilestoneData.value?.id != milestoneId) {
          Future.microtask(() => controller.loadTasks(milestoneId));
        }

        // ✅ Load tasks (non-blocking) — ensure tasks are loaded if not already
        if (!controller.tasksLoading.value &&
            controller.milestoneTasks.isEmpty) {
          Future.microtask(() => controller.loadTasks(milestoneId));
        }

        final milestone = controller.currentMilestoneData.value;

        // Loading state for milestone data
        if (controller.milestoneDataLoading.value && milestone == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 3,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading milestone details...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }
        // Loading state
        if (controller.tasksLoading.value &&
            controller.milestoneTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 3,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading tasks...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        // Error state
        if (controller.tasksError.value.isNotEmpty) {
          return Center(
            child: Card(
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Unable to load tasks',
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.tasksError.value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => controller.loadTasks(milestoneId),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final tasks = controller.milestoneTasks;

        // Empty state
        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_outlined,
                  size: 64,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text('No tasks found', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Tasks will appear here once created',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        // Partition tasks by status
        final active = tasks
            .where((t) => t.status == TaskStatus.active)
            .toList();
        final upcoming = tasks
            .where((t) => t.status == TaskStatus.pending)
            .toList();
        final completed = tasks
            .where((t) => t.status == TaskStatus.completed)
            .toList();
        final missed = tasks
            .where((t) => t.status == TaskStatus.missed)
            .toList();

        // Calculate progress
        final totalTasks = tasks.length;
        final completedCount = completed.length;
        final progress = totalTasks > 0 ? completedCount / totalTasks : 0.0;

        // Use milestone data (already fetched above)
        final milestoneName = milestone?.objective ?? 'Milestone';
        final milestoneDate = milestone?.targetDate;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [colorScheme.surfaceContainerLowest, colorScheme.surface],
              stops: const [0.0, 0.3],
            ),
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Milestone Hero Section
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 0,
                    color: colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  milestoneName,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSecondaryContainer,
                                      ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${(progress * 100).toInt()}%',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: colorScheme.onSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (milestoneDate != null) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: colorScheme.onSecondaryContainer
                                      .withOpacity(0.8),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatMilestoneDate(milestoneDate),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSecondaryContainer
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Task Progress',
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color:
                                              colorScheme.onSecondaryContainer,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  Text(
                                    '$completedCount of $totalTasks completed',
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: colorScheme
                                              .onSecondaryContainer
                                              .withOpacity(0.8),
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: colorScheme
                                    .onSecondaryContainer
                                    .withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.secondary,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Active Task Section
              if (active.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: _SectionHeader(
                      title: 'Active Task',
                      subtitle: '${active.length} in progress',
                      icon: Icons.play_circle_filled,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _ModernTaskCard(
                        task: active[index],
                        status: TaskCardStatus.active,
                      ),
                      childCount: active.length,
                    ),
                  ),
                ),
              ],

              // Upcoming Tasks Section
              if (upcoming.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: _SectionHeader(
                      title: 'Upcoming',
                      subtitle:
                          '${upcoming.length} task${upcoming.length != 1 ? 's' : ''}',
                      icon: Icons.schedule,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _ModernTaskCard(
                        task: upcoming[index],
                        status: TaskCardStatus.upcoming,
                      ),
                      childCount: upcoming.length,
                    ),
                  ),
                ),
              ],

              // Missed Tasks Section
              if (missed.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: _SectionHeader(
                      title: 'Missed',
                      subtitle:
                          '${missed.length} task${missed.length != 1 ? 's' : ''}',
                      icon: Icons.warning_rounded,
                      color: Colors.orange,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _ModernTaskCard(
                        task: missed[index],
                        status: TaskCardStatus.missed,
                      ),
                      childCount: missed.length,
                    ),
                  ),
                ),
              ],

              // Completed Tasks Section
              if (completed.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: _SectionHeader(
                      title: 'Completed',
                      subtitle:
                          '${completed.length} task${completed.length != 1 ? 's' : ''}',
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _ModernTaskCard(
                        task: completed[index],
                        status: TaskCardStatus.completed,
                      ),
                      childCount: completed.length,
                    ),
                  ),
                ),
              ],

              // Bottom spacing
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      }),
    );
  }

  String _formatMilestoneDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) {
      return 'Target was ${date.toString().substring(0, 10)}';
    } else if (difference == 0) {
      return 'Target: Today';
    } else if (difference <= 7) {
      return 'Target: in $difference days';
    } else {
      return 'Target: ${date.toString().substring(0, 10)}';
    }
  }
}

/* ---------- Modern Reusable Widgets ---------- */

enum TaskCardStatus { active, upcoming, missed, completed }

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModernTaskCard extends GetView<GoalDisplayController> {
  final Task task;
  final TaskCardStatus status;

  const _ModernTaskCard({required this.task, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        color: _getCardColor(colorScheme),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _getBorderColor(colorScheme), width: 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // ✅ USE CONTROLLER NAVIGATION METHOD
            final taskId = task.id;
            if (taskId.isNotEmpty) {
              controller.navigateToTask(taskId);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with icon and title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getStatusColor(colorScheme).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getStatusIcon(),
                        size: 20,
                        color: _getStatusColor(colorScheme),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        task.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: status == TaskCardStatus.completed
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface,
                          decoration: status == TaskCardStatus.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Task metadata
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Task type chip
                    if (task.taskType != null)
                      _InfoChip(
                        icon: Icons.category_outlined,
                        label: task.taskType!.name.toUpperCase(),
                        color: colorScheme.tertiary,
                      ),

                    // Time allocated chip
                    _InfoChip(
                      icon: Icons.timer_outlined,
                      label: task.timeAllocated ?? 'Time TBD',
                      color: colorScheme.primary,
                    ),

                    // Cognitive load chip
                    if (task.cognitiveLoad != null)
                      _InfoChip(
                        icon: Icons.psychology_outlined,
                        label: '${task.cognitiveLoad} load',
                        color: _getCognitiveLoadColor(task.cognitiveLoad!),
                      ),

                    // Day chip
                    if (task.day != null)
                      _InfoChip(
                        icon: Icons.calendar_today,
                        label: task.day!,
                        color: colorScheme.secondary,
                      ),

                    // Week chip
                    if (task.weekDetails != null)
                      _InfoChip(
                        icon: Icons.event_note,
                        label: 'Week ${task.weekDetails!.weekNumber}',
                        color: colorScheme.onSurfaceVariant,
                      ),
                  ],
                ),

                // Description preview if available
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    task.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCardColor(ColorScheme colorScheme) {
    switch (status) {
      case TaskCardStatus.active:
        return colorScheme.primaryContainer.withOpacity(0.3);
      case TaskCardStatus.completed:
        return colorScheme.surfaceContainerLow;
      case TaskCardStatus.missed:
        return Colors.orange.withOpacity(0.1);
      case TaskCardStatus.upcoming:
        return colorScheme.surface;
    }
  }

  Color _getBorderColor(ColorScheme colorScheme) {
    switch (status) {
      case TaskCardStatus.active:
        return colorScheme.primary.withOpacity(0.2);
      case TaskCardStatus.completed:
        return Colors.green.withOpacity(0.2);
      case TaskCardStatus.missed:
        return Colors.orange.withOpacity(0.3);
      case TaskCardStatus.upcoming:
        return colorScheme.outline.withOpacity(0.1);
    }
  }

  Color _getStatusColor(ColorScheme colorScheme) {
    switch (status) {
      case TaskCardStatus.active:
        return colorScheme.primary;
      case TaskCardStatus.completed:
        return Colors.green;
      case TaskCardStatus.missed:
        return Colors.orange;
      case TaskCardStatus.upcoming:
        return colorScheme.onSurfaceVariant;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case TaskCardStatus.active:
        return Icons.play_circle_filled;
      case TaskCardStatus.completed:
        return Icons.check_circle;
      case TaskCardStatus.missed:
        return Icons.warning_rounded;
      case TaskCardStatus.upcoming:
        return Icons.schedule;
    }
  }

  Color _getCognitiveLoadColor(String load) {
    switch (load.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
