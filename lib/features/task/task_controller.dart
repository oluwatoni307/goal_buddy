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

    // Validate completion notes first (mandatory)
    if (currentDto.completionDescription.trim().isEmpty) {
      Get.snackbar('Validation', 'Please add completion notes');
      return;
    }

    saving(true);
    try {
      // Create updated DTO with completed status
      final completedDto = TaskCompletionDto(
        id: currentDto.id,
        name: currentDto.name,
        description: currentDto.description,
        completionDescription: currentDto.completionDescription,
        status: 'completed', // Automatically set to completed on save
        objective: currentDto.objective,
        taskType: currentDto.taskType,
        cognitiveLoad: currentDto.cognitiveLoad,
        timeAllocated: currentDto.timeAllocated,
        specificActions: currentDto.specificActions,
        successMetric: currentDto.successMetric,
      );

      final response = await Get.find<ApiService>().patch(
        '/tasks/${completedDto.id}',
        data: completedDto.toJson(),
      );

      // Navigate to progress page
      Get.to(
        () => TaskProgressPage(
          task: completedDto,
          progressData: response.data ?? {},
        ),
      );
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save task: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to save task: $e');
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
}
