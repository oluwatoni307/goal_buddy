// MODERNIZED Monthly Progress Screen with Material 3 and latest Flutter syntax
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dashboard_controller.dart';

class MonthlyProgressScreen extends GetView<AnalyticsController> {
  const MonthlyProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.refreshAll,
        child: Obx(() {
          if (controller.monthlyLoading.value && controller.monthly.value == null) {
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
                    'Loading monthly overview...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }
          
          if (controller.monthlyError.value.isNotEmpty) {
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
                        'Unable to load monthly data',
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.monthlyError.value,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => controller.refreshAll(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          
          final m = controller.monthly.value!;
          return CustomScrollView(
            slivers: [
              // Monthly summary header
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 0,
                    color: colorScheme.surfaceContainerLow,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Overview',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your progress this month',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // KPI metrics cards
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ModernKpiCard(
                          title: 'Tasks\nCompleted',
                          value: m.habitsAchieved.toString(),
                          icon: Icons.task_alt,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ModernKpiCard(
                          title: 'Goals\nAchieved',
                          value: m.goalsAchieved.toString(),
                          icon: Icons.flag,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ModernKpiCard(
                          title: 'Active\nDays',
                          value: m.daysActive.toString(),
                          icon: Icons.calendar_today,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Task completion weekly chart
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
                                Icons.bar_chart,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Task Completion by Week',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _ModernWeeklyChart(
                            values: m.weeklyHabitCompletion,
                            labels: const ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
                            isPercentage: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Goals achievement weekly chart
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
                                'Goals Achieved per Week',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _ModernWeeklyChart(
                            values: m.weeklyGoalsAchieved.map((e) => e.toDouble()).toList(),
                            labels: const ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
                            isPercentage: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // AI insights section
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
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.lightbulb_outline,
                                  size: 20,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Monthly Insights',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.outline.withOpacity(0.1),
                              ),
                            ),
                            child: Text(
                              m.insight,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.5,
                                color: colorScheme.onSurface,
                              ),
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

class _ModernKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ModernKpiCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernWeeklyChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final bool isPercentage;

  const _ModernWeeklyChart({
    required this.values,
    required this.labels,
    this.isPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final maxValue = values.isEmpty ? 1.0 : values.reduce((a, b) => a > b ? a : b);
    
    return Container(
      height: 140,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: List.generate(values.length, (index) {
          final value = values[index];
          final heightRatio = maxValue > 0 ? value / maxValue : 0.0;
          final barHeight = (80 * heightRatio).clamp(4.0, 80.0);
          
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Value label on top
                  Text(
                    isPercentage 
                        ? '${(value * 100).toInt()}%'
                        : value.toInt().toString(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Animated bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutCubic,
                    width: double.infinity,
                    height: barHeight,
                    constraints: const BoxConstraints(maxWidth: 32),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.8),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                        bottom: Radius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Week label
                  Text(
                    labels[index],
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}