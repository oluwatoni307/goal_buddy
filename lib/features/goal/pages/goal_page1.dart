// MODERNIZED Goals List Screen with Material 3 and Controller-First Navigation
// GENERATED for feature: goal
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../navBar.dart';
import '../goal_model.dart';
import '../goal_controller.dart';

class GoalsListScreen extends GetView<GoalDisplayController> {
  const GoalsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Goals',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(() {
                final total = controller.totalGoals;
                if (total == 0) return const SizedBox.shrink();
                return Text(
                  '$total ${total == 1 ? 'goal' : 'goals'}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                );
              }),
            ],
          ),
          bottom: TabBar(
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
            indicatorWeight: 3,
            labelStyle: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Active'),
                    const SizedBox(width: 8),
                    Obx(() {
                      final count = controller.activeGoals.length;
                      if (count == 0) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Completed'),
                    const SizedBox(width: 8),
                    Obx(() {
                      final count = controller.completedGoals.length;
                      if (count == 0) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavBar(currentIndex: 1),
        body: Obx(() {
          // Loading state
          if (controller.goalsLoading.value &&
              controller.activeGoals.isEmpty &&
              controller.completedGoals.isEmpty) {
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
                    'Loading your goals...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          // Error state
          if (controller.goalsError.value.isNotEmpty) {
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
                        'Unable to load goals',
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.goalsError.value,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: controller.refreshGoals,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Tab content
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.surfaceContainerLowest,
                  colorScheme.surface,
                ],
                stops: const [0.0, 0.3],
              ),
            ),
            child: TabBarView(
              children: [
                _GoalTab(goals: controller.activeGoals, isActive: true),
                _GoalTab(goals: controller.completedGoals, isActive: false),
              ],
            ),
          );
        }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.toNamed('/goal/step1'),
          icon: const Icon(Icons.add_rounded),
          label: const Text('New Goal'),
          elevation: 2,
        ),
      ),
    );
  }
}

/* ---------- Modern Goal Tab ---------- */

class _GoalTab extends GetView<GoalDisplayController> {
  final List<Goal> goals;
  final bool isActive;

  const _GoalTab({required this.goals, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Empty state
    if (goals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.flag_outlined : Icons.emoji_events_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              isActive ? 'No active goals' : 'No completed goals',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              isActive
                  ? 'Create your first goal to get started'
                  : 'Completed goals will appear here',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (isActive) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Get.toNamed('/goal/step1'),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create Goal'),
              ),
            ],
          ],
        ),
      );
    }

    // Goals list
    return RefreshIndicator(
      onRefresh: controller.refreshGoals,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          return _ModernGoalCard(
            goal: goal,
            isCompleted: !isActive,
            animationDelay: Duration(milliseconds: index * 100),
          );
        },
      ),
    );
  }
}

/* ---------- Modern Goal Card ---------- */

class _ModernGoalCard extends GetView<GoalDisplayController> {
  final Goal goal;
  final bool isCompleted;
  final Duration animationDelay;

  const _ModernGoalCard({
    required this.goal,
    required this.isCompleted,
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
        margin: const EdgeInsets.only(bottom: 16),
        child: Card(
          elevation: 0,
          color: isCompleted
              ? colorScheme.surfaceContainerLow
              : colorScheme.primaryContainer.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isCompleted
                  ? Colors.green.withOpacity(0.2)
                  : colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => controller.navigateToGoal(goal.id),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              (isCompleted ? Colors.green : colorScheme.primary)
                                  .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isCompleted ? Icons.emoji_events : Icons.flag_rounded,
                          size: 24,
                          color: isCompleted
                              ? Colors.green
                              : colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goal.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isCompleted
                                    ? colorScheme.onSurfaceVariant
                                    : colorScheme.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  isCompleted
                                      ? Icons.check_circle_rounded
                                      : Icons.pending_actions_rounded,
                                  size: 14,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isCompleted ? 'Completed' : 'In Progress',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Description
                  if (goal.description.isNotEmpty) ...[
                    Text(
                      goal.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Progress section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getProgressColor(
                                  goal.completionRate,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${(goal.completionRate * 100).toInt()}%',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: _getProgressColor(goal.completionRate),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: goal.completionRate,
                            minHeight: 8,
                            backgroundColor: colorScheme.onSurface.withOpacity(
                              0.1,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getProgressColor(goal.completionRate),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) return Colors.green;
    if (progress >= 0.5) return Colors.orange;
    return Colors.blue;
  }
}
