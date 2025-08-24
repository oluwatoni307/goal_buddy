import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../services/api_service.dart';
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
      final response = await Get.find<ApiService>().get('/tasks/$taskId/completion');
      
      // Add null check here
      if (response.data == null) {
        throw Exception('No task data received');
      }
      
      dto.value = TaskCompletionDto.fromJson(response.data);
    } on DioException catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to load task: ${e.response?.data ?? e.message}');
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
    
    if (currentDto.userNotes.trim().isEmpty) {
      Get.snackbar('Required', 'Add completion notes');
      return;
    }
    
    saving(true);
    try {
      await Get.find<ApiService>().patch(
        '/tasks/${currentDto.taskId}',
        data: currentDto.toJson(),
      );
      Get.back(result: true);
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data ?? e.message);
    } finally {
      saving(false);
    }
  }
}