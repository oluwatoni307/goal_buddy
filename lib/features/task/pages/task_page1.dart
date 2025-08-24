import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../task_controller.dart';

class TaskCompletionScreen extends GetView<TaskCompletionController> {
  const TaskCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Complete Task',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return _buildLoadingState(colorScheme);
        }

        final dto = controller.dto.value;
        if (dto == null) {
          return _buildErrorState(context);
        }

        return _buildMainContent(context, dto);
      }),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Loading task details...',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No task data available',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again or contact support',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, dynamic dto) {
    final theme = Theme.of(context);
    final _ = theme.colorScheme;
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Hierarchy Card
            _buildTaskHierarchyCard(context, dto),
            
            const SizedBox(height: 24),
            
            // Ritual Information
            _buildRitualCard(context, dto),
            
            const SizedBox(height: 24),
            
            // Completion Notes Section
            _buildNotesSection(context, dto),
            
            const SizedBox(height: 32),
            
            // Action Button
            _buildActionButton(context),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskHierarchyCard(BuildContext context, dynamic dto) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Goal
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.flag_outlined,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Goal',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dto.goalName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Milestone
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.timeline,
                    size: 20,
                    color: colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Milestone',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dto.milestoneName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Task
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.task_alt,
                    size: 20,
                    color: colorScheme.tertiary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Task',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dto.taskTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRitualCard(BuildContext context, dynamic dto) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.self_improvement,
                size: 24,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ritual Practice',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dto.ritual,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context, dynamic dto) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Completion Reflection',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        TextFormField(
          maxLines: 5,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'How did you complete this task? What did you learn or accomplish?',
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHigh,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged: (value) {
            final currentDto = controller.dto.value;
            if (currentDto != null) {
              currentDto.userNotes = value;
              // Trigger reactive update if needed
              controller.dto.refresh();
            }
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SizedBox(
      width: double.infinity,
      child: Obx(() {
        final isSaving = controller.saving.value;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: FilledButton.icon(
            onPressed: isSaving ? null : controller.save,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: isSaving 
                ? colorScheme.surfaceContainerHigh
                : colorScheme.primary,
              foregroundColor: isSaving
                ? colorScheme.onSurface.withOpacity(0.6)
                : colorScheme.onPrimary,
            ),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSaving
                ? SizedBox(
                    key: const ValueKey('loading'),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  )
                : Icon(
                    Icons.check_circle,
                    key: const ValueKey('check'),
                  ),
            ),
            label: Text(
              isSaving ? 'Completing...' : 'Mark as Completed',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }
}