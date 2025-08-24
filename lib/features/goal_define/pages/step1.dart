// GENERATED for feature: goal_define
// TODO: implement
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/routes.dart';
import '../goal_define_controller.dart';

class GoalStep1Screen extends GetView<GoalCreationController> {
  const GoalStep1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final textCtrl = TextEditingController(
      text: controller.input.value?.statement ?? '',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Describe your goal')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'In one sentence, what do you want to achieve?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textCtrl,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'e.g. Finish reading the Flutter book',
                border: OutlineInputBorder(),
              ),
              onChanged: controller.setStatement,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (textCtrl.text.trim().isEmpty) {
                    Get.snackbar('Required', 'Please describe your goal');
                    return;
                  }
                  Get.toNamed(Routes.goalStep2);
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}