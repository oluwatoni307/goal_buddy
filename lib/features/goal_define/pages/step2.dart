// GENERATED for feature: goal_define
// TODO: implement
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/routes.dart';
import '../goal_define_controller.dart';

class GoalStep2Screen extends StatefulWidget {
  const GoalStep2Screen({super.key});

  @override
  State<GoalStep2Screen> createState() => _GoalStep2ScreenState();
}

class _GoalStep2ScreenState extends State<GoalStep2Screen> {
  late final GoalCreationController controller;
  late final TextEditingController contextCtrl;

  @override
  void initState() {
    super.initState();
    controller = Get.find<GoalCreationController>();
    contextCtrl = TextEditingController(
      text: controller.input.value?.context ?? '',
    );
  }

  @override
  void dispose() {
    contextCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add details'),
        leading: BackButton(onPressed: () => Get.back()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date picker
            const Text('Target date', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Obx(() {
              final date = controller.input.value?.date;
              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async {
                  final initialDate = (date != null && date.isAfter(today))
                      ? date
                      : today.add(const Duration(days: 7));

                  final picked = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: today,
                    lastDate: today.add(const Duration(days: 365)),
                  );
                  if (picked != null) controller.setDate(picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: 8),
                      Text(date == null
                          ? 'Pick a date'
                          : '${date.day}/${date.month}/${date.year}'),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),

            // Importance slider
            const Text('Importance', style: TextStyle(fontSize: 16)),
            Obx(() {
              final importance = (controller.input.value?.importance ?? 5).clamp(1, 10);
              return Slider(
                value: importance.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: importance.toString(),
                onChanged: (v) => controller.setImportance(v.toInt()),
              );
            }),
            const SizedBox(height: 24),

            // Context textarea
            const Text('Context & skills you already have',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: contextCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'e.g. I have 2 hrs free daily and basic Flutter knowledge',
                border: OutlineInputBorder(),
              ),
              onChanged: controller.setContext,
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final date = controller.input.value?.date;
                  if (date == null) {
                    Get.snackbar('Required', 'Please pick a target date');
                    return;
                  }
                  
                  try {
                    await controller.analyzeGoal();
                    Get.toNamed(Routes.goalAnalyze);
                  } catch (e) {
                    Get.snackbar('Error', 'Failed to analyze goal. Please try again.');
                  }
                },
                child: Obx(
                  () => controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Analyze'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}