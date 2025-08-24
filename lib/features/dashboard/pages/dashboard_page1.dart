// MODERNIZED Daily Progress Screen with Material 3 and latest Flutter syntax
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dashboard_controller.dart';

class DailyProgressScreen extends GetView<AnalyticsController> {
  const DailyProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.refreshAll,
        child: Obx(() {
          if (controller.dailyLoading.value && controller.daily.value == null) {
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
                    'Loading your progress...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }
          
          if (controller.dailyError.value.isNotEmpty) {
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
                        'Oops! Something went wrong',
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.dailyError.value,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => controller.refreshAll(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          
          final d = controller.daily.value!;
          return CustomScrollView(
            slivers: [
              // Hero section with main stats
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
                          Text(
                            'Today\'s Progress',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Keep up the great work!',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: _ModernStatsCard(
                                  title: 'Tasks',
                                  value: '${(d.habitCompletionRate * 100).toStringAsFixed(0)}%',
                                  progress: d.habitCompletionRate,
                                  icon: Icons.task_alt,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _ModernStatsCard(
                                  title: 'Goals',
                                  value: '${(d.goalCompletionRate * 100).toStringAsFixed(0)}%',
                                  progress: d.goalCompletionRate,
                                  icon: Icons.flag,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Weekly trend section
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Weekly Task Trend',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _ModernWeeklyChart(data: d.last7DaysHabit),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Goals breakdown section
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.analytics,
                                color: colorScheme.tertiary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Goal Breakdown',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...d.goalsBreakdown.map(
                            (goal) => _ModernGoalTile(
                              name: goal.name,
                              rate: goal.completionRate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/* ---------- Modern Reusable Widgets ---------- */

class _ModernStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final double progress;
  final IconData icon;
  final Color color;

  const _ModernStatsCard({
    required this.title,
    required this.value,
    required this.progress,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModernWeeklyChart extends StatelessWidget {
  final Map<String, double> data;
  const _ModernWeeklyChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final maxValue = data.values.isEmpty ? 1.0 : data.values.reduce((a, b) => a > b ? a : b);
    
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.entries.map((entry) {
          final heightRatio = maxValue > 0 ? entry.value / maxValue : 0.0;
          final barHeight = (70 * heightRatio).clamp(4.0, 70.0);
          
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    width: double.infinity,
                    height: barHeight,
                    constraints: const BoxConstraints(maxWidth: 24),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.8),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                        bottom: Radius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.key.substring(0, 1),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${(entry.value * 100).toInt()}%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ModernGoalTile extends StatelessWidget {
  final String name;
  final double rate;
  const _ModernGoalTile({required this.name, required this.rate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getProgressColor(rate, colorScheme).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(rate * 100).toStringAsFixed(0)}%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getProgressColor(rate, colorScheme),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: rate,
            backgroundColor: colorScheme.outline.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              _getProgressColor(rate, colorScheme),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double rate, ColorScheme colorScheme) {
    if (rate >= 0.8) return colorScheme.primary;
    if (rate >= 0.5) return colorScheme.onSurfaceVariant;
    return colorScheme.error;
  }
}