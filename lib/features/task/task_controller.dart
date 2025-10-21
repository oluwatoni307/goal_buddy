import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../services/api_service.dart';
import 'pages/task_page3.dart';
import 'task_model.dart';

class TaskCompletionController extends GetxController {
  final Rx<TaskCompletionDto?> dto = Rx<TaskCompletionDto?>(null);
  final RxBool saving = false.obs;
  final RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final taskId = Get.parameters['taskId'];

    if (taskId == null) {
      Get.back();
      Get.snackbar('Error', 'Missing task ID');
      return;
    }

    // Load task data from server using taskId
    loadTaskData(taskId);
  }

  Future<void> loadTaskData(String taskId) async {
    try {
      loading(true);
      final response = await Get.find<ApiService>().get(
        '/tasks/$taskId/completion',
      );

      if (response.data == null) {
        throw Exception('No task data received');
      }

      dto.value = TaskCompletionDto.fromJson(response.data);
    } on DioException catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Failed to load task: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to load task: $e');
    } finally {
      loading(false);
    }
  }

  Future<void> save() async {
    final currentDto = dto.value;
    if (currentDto == null) {
      Get.snackbar('Error', 'Task data not loaded');
      return;
    }

    if (!_isValidForSubmission(currentDto)) {
      return;
    }

    saving(true);
    try {
      final response = await Get.find<ApiService>().patch(
        '/tasks/${currentDto.id}',
        data: currentDto.toJson(),
      );

      // Navigate to progress page with the response data
      Get.to(
        () => TaskProgressPage(
          task: currentDto,
          progressData: response.data ?? {},
        ),
      );
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save task: ${e.response?.data ?? e.message}',
      );
    } finally {
      saving(false);
    }
  }

  // Helper method to mark task as completed
  void markComplete() {
    final currentDto = dto.value;
    if (currentDto != null) {
      dto.value = TaskCompletionDto(
        id: currentDto.id,
        name: currentDto.name,
        description: currentDto.description,
        completionDescription: currentDto.completionDescription,
        status: 'completed',
        objective: currentDto.objective,
        taskType: currentDto.taskType,
        cognitiveLoad: currentDto.cognitiveLoad,
        timeAllocated: currentDto.timeAllocated,
        specificActions: currentDto.specificActions,
        successMetric: currentDto.successMetric,
      );
    }
  }

  // Helper method to update completion notes
  void updateNotes(String notes) {
    final currentDto = dto.value;
    if (currentDto != null) {
      dto.value = TaskCompletionDto(
        id: currentDto.id,
        name: currentDto.name,
        description: currentDto.description,
        completionDescription: notes,
        status: currentDto.status,
        objective: currentDto.objective,
        taskType: currentDto.taskType,
        cognitiveLoad: currentDto.cognitiveLoad,
        timeAllocated: currentDto.timeAllocated,
        specificActions: currentDto.specificActions,
        successMetric: currentDto.successMetric,
      );
    }
  }

  // Validate DTO before submission
  bool _isValidForSubmission(TaskCompletionDto dto) {
    if (dto.status != 'completed') {
      Get.snackbar(
        'Validation',
        'Please mark the task as completed before saving',
      );
      return false;
    }
    if (dto.completionDescription.trim().isEmpty) {
      Get.snackbar('Validation', 'Please add completion notes');
      return false;
    }
    return true;
  }
}
