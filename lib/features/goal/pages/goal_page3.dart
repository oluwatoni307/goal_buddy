// GENERATED for feature: goal
// TODO: implement
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../goal_controller.dart';
import '../goal_model.dart';

class MilestoneDetailScreen extends GetView<GoalDisplayController> {
  const MilestoneDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final milestoneId = Get.parameters['id'] ?? '';

    // Ensure tasks are loaded
    if (controller.currentMilestoneId.value != milestoneId) {
      controller.loadTasks(milestoneId);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Milestone Details')),
      body: Obx(() {
        if (controller.tasksLoading.value && controller.milestoneTasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.tasksError.value.isNotEmpty) {
          return Center(
            child: Text(controller.tasksError.value,
                style: const TextStyle(color: Colors.red)),
          );
        }

        final tasks = controller.milestoneTasks;
        final active   = tasks.where((t) => t.status == TaskStatus.active).toList();
        final upcoming = tasks.where((t) => t.status == TaskStatus.pending).toList();
        final completed = tasks.where((t) => t.status == TaskStatus.completed).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Milestone header
            Text(
              controller.goalMilestones.value?.milestones
                      .firstWhereOrNull((m) => m.objective == milestoneId)
                      ?.objective ??
                  'Milestone',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            // (add more header fields here if needed)

            // Active task
            if (active.isNotEmpty) ...[
              const Text('Active Task', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...active.map((t) => _TaskCard(task: t)),
              const SizedBox(height: 16),
            ],

            // Upcoming tasks
            if (upcoming.isNotEmpty) ...[
              const Text('Upcoming', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...upcoming.map((t) => _TaskCard(task: t)),
              const SizedBox(height: 16),
            ],

            // Completed tasks
            if (completed.isNotEmpty) ...[
              const Text('Completed', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...completed.map((t) => _TaskCard(task: t)),
            ],
          ],
        );
      }),
    );
  }
}

/* ---------- Task card ---------- */
class _TaskCard extends StatelessWidget {
  final Task task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          task.status == TaskStatus.completed
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          color: task.status == TaskStatus.active
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
        title: Text(task.title),
        subtitle: Text('${task.timeAllocated} • ${task.cognitiveLoad} load'),
        trailing: Text(task.taskType.name),
        onTap: () {
          // TODO: open task detail or mark complete
        },
      ),
    );
  }
}