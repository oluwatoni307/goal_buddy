import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../navBar.dart';
import '../schedule_controller.dart';
import '../schedule_model.dart';

class WeeklyScheduleScreen extends GetView<ScheduleController> {
  const WeeklyScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshSchedule(),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(currentIndex: 2), // for home

      body: Obx(() {
        if (controller.loading.value && controller.schedule.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Loading schedule...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.error.value,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => controller.refreshSchedule(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final sched = controller.schedule.value;
        if (sched == null) {
          return const Center(child: Text('No schedule available'));
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshSchedule(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _DayCard(day: 'Monday', slots: sched.monday),
                _DayCard(day: 'Tuesday', slots: sched.tuesday),
                _DayCard(day: 'Wednesday', slots: sched.wednesday),
                _DayCard(day: 'Thursday', slots: sched.thursday),
                _DayCard(day: 'Friday', slots: sched.friday),
                _DayCard(day: 'Saturday', slots: sched.saturday),
                _DayCard(day: 'Sunday', slots: sched.sunday),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _DayCard extends StatelessWidget {
  final String day;
  final List<TimeSlotEntry> slots;

  const _DayCard({required this.day, required this.slots});

  @override
  Widget build(BuildContext context) {
    final isToday = _isToday(day);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isToday
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isToday
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      day.substring(0, 1),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: isToday
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            day,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isToday
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          if (isToday) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Today',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        slots.isEmpty
                            ? 'No activities scheduled'
                            : '${slots.length} ${slots.length == 1 ? 'activity' : 'activities'}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (slots.isNotEmpty) ...[
              const SizedBox(height: 16),
              Divider(color: theme.colorScheme.outlineVariant),
              const SizedBox(height: 12),
              ...slots.map((slot) => _TimeSlotItem(slot: slot)),
            ] else ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.event_available,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Free day - no scheduled activities',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isToday(String dayName) {
    final today = DateTime.now().weekday;
    final dayMap = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };
    return dayMap[dayName] == today;
  }
}

class _TimeSlotItem extends StatelessWidget {
  final TimeSlotEntry slot;

  const _TimeSlotItem({required this.slot});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<ScheduleController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              color: _getPriorityColor(context, slot.allocatedMinutes),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        // TODO: You'll need to fetch milestone title using milestoneId
                        'Milestone ${slot.milestoneId.substring(0, 8)}...',
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _FlexibilityBadge(flexibility: slot.flexibility),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          controller.convertTo12Hour(slot.timeSlot),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${slot.allocatedMinutes} min',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(BuildContext context, int minutes) {
    final theme = Theme.of(context);
    if (minutes >= 120) return theme.colorScheme.error;
    if (minutes >= 60) return const Color(0xFFFF9500); // warning color
    if (minutes >= 30) return theme.colorScheme.primary;
    return const Color(0xFF146C2E); // success color
  }
}

class _FlexibilityBadge extends StatelessWidget {
  final String flexibility;

  const _FlexibilityBadge({required this.flexibility});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final config = _getFlexibilityConfig(flexibility);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: config.color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 12, color: config.color),
          const SizedBox(width: 4),
          Text(
            flexibility.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: config.color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  ({Color color, IconData icon}) _getFlexibilityConfig(String flex) {
    switch (flex.toLowerCase()) {
      case 'high':
        return (
          color: const Color(0xFF146C2E), // Green
          icon: Icons.swap_horiz,
        );
      case 'medium':
        return (
          color: const Color(0xFFFF9500), // Orange
          icon: Icons.drag_indicator,
        );
      case 'low':
      default:
        return (
          color: const Color(0xFFDC3545), // Red
          icon: Icons.push_pin,
        );
    }
  }
}
