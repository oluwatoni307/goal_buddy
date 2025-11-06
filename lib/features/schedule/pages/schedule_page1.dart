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
        title: const Text('Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshSchedule(),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(currentIndex: 2),
      body: Obx(() {
        if (controller.loading.value && controller.schedule.value == null) {
          return const Center(child: CircularProgressIndicator());
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
                TextButton.icon(
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
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _DaySection(day: 'Monday', slots: sched.monday),
              _DaySection(day: 'Tuesday', slots: sched.tuesday),
              _DaySection(day: 'Wednesday', slots: sched.wednesday),
              _DaySection(day: 'Thursday', slots: sched.thursday),
              _DaySection(day: 'Friday', slots: sched.friday),
              _DaySection(day: 'Saturday', slots: sched.saturday),
              _DaySection(day: 'Sunday', slots: sched.sunday),
            ],
          ),
        );
      }),
    );
  }
}

class _DaySection extends StatelessWidget {
  final String day;
  final List<TimeSlotEntry> slots;

  const _DaySection({required this.day, required this.slots});

  @override
  Widget build(BuildContext context) {
    final isToday = _isToday(day);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day header
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
              const SizedBox(width: 12),
              Text(
                slots.isEmpty ? 'Free' : '${slots.length}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Time slots
          if (slots.isEmpty)
            Container(
              height: 1,
              color: theme.colorScheme.outlineVariant.withOpacity(0.3),
            )
          else
            ...slots.map((slot) => _TimeSlotRow(slot: slot)),
        ],
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

class _TimeSlotRow extends StatelessWidget {
  final TimeSlotEntry slot;

  const _TimeSlotRow({required this.slot});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<ScheduleController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: _getPriorityColor(theme, slot.allocatedMinutes),
            width: 3,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time
            SizedBox(
              width: 70,
              child: Text(
                controller.convertTo12Hour(slot.timeSlot),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // TODO: Fetch milestone title using milestoneId
                    slot.Milestone_name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${slot.allocatedMinutes} min',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _FlexibilityDot(flexibility: slot.flexibility),
                      const SizedBox(width: 6),
                      Text(
                        slot.flexibility,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(ThemeData theme, int minutes) {
    if (minutes >= 120) return theme.colorScheme.error;
    if (minutes >= 60) return theme.colorScheme.tertiary;
    if (minutes >= 30) return theme.colorScheme.primary;
    return theme.colorScheme.secondary;
  }
}

class _FlexibilityDot extends StatelessWidget {
  final String flexibility;

  const _FlexibilityDot({required this.flexibility});

  @override
  Widget build(BuildContext context) {
    final color = _getFlexibilityColor(context);

    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Color _getFlexibilityColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (flexibility.toLowerCase()) {
      case 'high':
        return theme.colorScheme.secondary;
      case 'medium':
        return theme.colorScheme.tertiary;
      case 'low':
      default:
        return theme.colorScheme.error;
    }
  }
}
