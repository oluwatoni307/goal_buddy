// UPDATED Goal Detail Screen with Controller-First Navigation
// MODERNIZED with Material 3 and latest Flutter syntax
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../goal_controller.dart';
import '../goal_model.dart';

class GoalDetailScreen extends GetView<GoalDisplayController> {
  const GoalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final goalId = Get.parameters['id'] ?? '';

    // Trigger smart loading if needed (non-blocking)
    if (controller.shouldLoadMilestones(goalId)) {
      Future.microtask(() => controller.loadMilestones(goalId));
    }

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
          'Goal Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        final milestones = controller.goalMilestones.value;

        // Loading state
        if (controller.milestonesLoading.value && milestones == null) {
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
                  'Loading goal details...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        // Error state
        if (controller.milestonesError.value.isNotEmpty) {
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
                      'Unable to load goal details',
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.milestonesError.value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => controller.loadMilestones(goalId),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // No data state
        if (milestones == null) {
          return const Center(child: SizedBox.shrink());
        }

        // Partition milestones
        final active = milestones.milestones
            .where((m) => m.status == StatusState.active)
            .toList();
        final upcoming = milestones.milestones
            .where((m) => m.status == StatusState.pending)
            .toList();
        final completed = milestones.milestones
            .where((m) => m.status == StatusState.completed)
            .toList();

        final totalMilestones = milestones.milestones.length;
        final completedCount = completed.length;
        final progress = totalMilestones > 0
            ? completedCount / totalMilestones
            : 0.0;

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
              // Goal Hero Section
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 0,
                    color: colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  controller.getCurrentGoalName(),
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${(progress * 100).toInt()}%',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            controller.getCurrentGoalDescription(),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onPrimaryContainer.withOpacity(
                                0.8,
                              ),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Progress',
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: colorScheme.onPrimaryContainer,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  Text(
                                    '$completedCount of $totalMilestones milestones',
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: colorScheme.onPrimaryContainer
                                              .withOpacity(0.8),
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: colorScheme.onPrimaryContainer
                                    .withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.primary,
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

              // Active Milestones Section
              if (active.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: _SectionHeader(
                      title: 'Active',
                      subtitle:
                          '${active.length} milestone${active.length != 1 ? 's' : ''}',
                      icon: Icons.play_circle_filled,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _ModernMilestoneTile(
                        milestone: active[index],
                        status: MilestoneStatus.active,
                        animationDelay: Duration(milliseconds: index * 100),
                      ),
                      childCount: active.length,
                    ),
                  ),
                ),
              ],

              // Upcoming Milestones Section
              if (upcoming.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: _SectionHeader(
                      title: 'Upcoming',
                      subtitle:
                          '${upcoming.length} milestone${upcoming.length != 1 ? 's' : ''}',
                      icon: Icons.schedule,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _ModernMilestoneTile(
                        milestone: upcoming[index],
                        status: MilestoneStatus.upcoming,
                        animationDelay: Duration(
                          milliseconds: (active.length + index) * 100,
                        ),
                      ),
                      childCount: upcoming.length,
                    ),
                  ),
                ),
              ],

              // Completed Milestones Section
              if (completed.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: _SectionHeader(
                      title: 'Completed',
                      subtitle:
                          '${completed.length} milestone${completed.length != 1 ? 's' : ''}',
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _ModernMilestoneTile(
                        milestone: completed[index],
                        status: MilestoneStatus.completed,
                        animationDelay: Duration(
                          milliseconds:
                              (active.length + upcoming.length + index) * 100,
                        ),
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
}

/* ---------- Modern Reusable Widgets ---------- */

enum MilestoneStatus { active, upcoming, completed }

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

class _ModernMilestoneTile extends GetView<GoalDisplayController> {
  final Milestone milestone;
  final MilestoneStatus status;
  final Duration animationDelay;

  const _ModernMilestoneTile({
    required this.milestone,
    required this.status,
    required this.animationDelay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
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
              controller.navigateToMilestone(milestone.id);
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Status Icon
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
                  const SizedBox(width: 16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          milestone.objective,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: status == MilestoneStatus.completed
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.onSurface,
                            decoration: status == MilestoneStatus.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(milestone.targetDate),
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Navigation Arrow
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getCardColor(ColorScheme colorScheme) {
    switch (status) {
      case MilestoneStatus.active:
        return colorScheme.primaryContainer.withOpacity(0.3);
      case MilestoneStatus.completed:
        return colorScheme.surfaceContainerLow;
      case MilestoneStatus.upcoming:
        return colorScheme.surface;
    }
  }

  Color _getBorderColor(ColorScheme colorScheme) {
    switch (status) {
      case MilestoneStatus.active:
        return colorScheme.primary.withOpacity(0.2);
      case MilestoneStatus.completed:
        return Colors.green.withOpacity(0.2);
      case MilestoneStatus.upcoming:
        return colorScheme.outline.withOpacity(0.1);
    }
  }

  Color _getStatusColor(ColorScheme colorScheme) {
    switch (status) {
      case MilestoneStatus.active:
        return colorScheme.primary;
      case MilestoneStatus.completed:
        return Colors.green;
      case MilestoneStatus.upcoming:
        return colorScheme.onSurfaceVariant;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case MilestoneStatus.active:
        return Icons.play_circle_filled;
      case MilestoneStatus.completed:
        return Icons.check_circle;
      case MilestoneStatus.upcoming:
        return Icons.schedule;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (status == MilestoneStatus.completed) {
      return 'Completed ${date.toString().substring(0, 10)}';
    }

    if (difference < 0) {
      return 'Overdue ${(-difference)} days';
    } else if (difference == 0) {
      return 'Due today';
    } else if (difference == 1) {
      return 'Due tomorrow';
    } else if (difference <= 7) {
      return 'Due in $difference days';
    } else {
      return 'Due ${date.toString().substring(0, 10)}';
    }
  }
}
