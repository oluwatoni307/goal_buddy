import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../goal_define_controller.dart';

class GoalAnalysisScreen extends GetView<GoalCreationController> {
  const GoalAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger analysis if not already done
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.analysis.value == null && !controller.isAnalyzing.value) {
        controller.analyzeGoal();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Analysis'),
        leading: BackButton(onPressed: () => Get.back()),
        actions: [
          // Debug button (remove in production)
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () => controller.debugPrintState(),
          ),
        ],
      ),
      body: Obx(() {
        // Show error if there's one
        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.error.value,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () => Get.back(),
                        child: const Text('Go Back'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: controller.isAnalyzing.value
                            ? null
                            : () => controller.reAnalyze(),
                        child: controller.isAnalyzing.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Retry'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        // Show loading while analyzing
        if (controller.isAnalyzing.value || controller.analysis.value == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Analyzing your goal...'),
                SizedBox(height: 8),
                Text(
                  'This may take a few seconds',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final out = controller.analysis.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Goal statement
              Text(
                'Goal',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                controller.input.value?.statement ?? 'No goal statement',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Divider(height: 32),

              // Classification
              _InfoRow('Classification', out.goalClassification),
              _InfoRow('Type', out.goalType),
              _InfoRow(
                'Complexity',
                '${out.complexity} (${out.complexityRating.toStringAsFixed(1)})',
              ),
              _InfoRow('Success probability', out.successProbability),
              _InfoRow('Recommended approach', out.recommendedApproach),
              const Divider(height: 32),

              // Quick attribute list
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Chip('Motivation', out.motivation),
                  _Chip('Skill level', out.skillLevel),
                  _Chip('Dependencies', out.dependencies),
                  _Chip('Measurability', out.measurability),
                  _Chip('Decomposability', out.decomposability),
                  _Chip('Urgency', out.urgency),
                  _Chip('Autonomy', out.autonomy),
                  _Chip('Readiness', out.readiness),
                  _Chip('Identity alignment', out.identityAlignment),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Obx(() {
            final hasAnalysis = controller.analysis.value != null;
            final isLoading =
                controller.isSaving.value || controller.isAnalyzing.value;

            return Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading ? null : () => Get.back(),
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (hasAnalysis && !isLoading)
                        ? () => _handleSaveGoal()
                        : null,
                    child: controller.isSaving.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Save'),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<void> _handleSaveGoal() async {
    final success = await controller.saveGoal();
    if (!success && controller.error.value.isNotEmpty) {
      Get.snackbar(
        'Error',
        controller.error.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}

/// Helper widgets
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}

class _Chip extends StatelessWidget {
  final String label;
  final String value;
  const _Chip(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
      visualDensity: VisualDensity.compact,
    );
  }
}
