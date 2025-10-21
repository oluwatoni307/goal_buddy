// GENERATED for feature: schedule
// ignore_for_file: unnecessary_null_comparison, unused_element

import 'package:get/get.dart';
import '/features/schedule/schedule_model.dart';
import '/services/api_service.dart';

class ScheduleController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  final Rx<WeeklySchedule?> schedule = Rx(null);
  final RxBool loading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSchedule();
  }

  Future<void> loadSchedule() async {
    try {
      loading.value = true;
      error.value = '';

      final response = await _api.get(
        '/schedule',
      ); // or whatever your endpoint is

      if (response != null) {
        // Normalize the response body so we don't call List/Map getters on a Response object.
        // Some ApiService implementations (e.g., Dio) return a Response object with a `data` field.
        dynamic body;
        try {
          body = (response as dynamic).data ?? response;
        } catch (_) {
          body = response;
        }

        // Now handle the normalized body which should be a List or Map
        if (body is List && body.isNotEmpty) {
          final scheduleData = ScheduleData.fromJson(body[0]);
          schedule.value = scheduleData.scheduleData;
        } else if (body is Map<String, dynamic>) {
          // If your API returns the schedule_data under a key
          if (body.containsKey('schedule_data') &&
              body['schedule_data'] != null) {
            schedule.value = WeeklySchedule.fromJson(body['schedule_data']);
          } else {
            schedule.value = WeeklySchedule.fromJson(body);
          }
        } else {
          error.value = 'No schedule data found';
        }
      } else {
        error.value = 'No schedule data found';
      }
    } catch (e) {
      error.value = 'Failed to load schedule: $e';

      // Optional: Fall back to demo data on error
      // _loadDemoData();
    } finally {
      loading.value = false;
    }
  }

  Future<void> refreshSchedule() async {
    await loadSchedule();
  }

  // Helper method to convert 24-hour time to 12-hour format
  String convertTo12Hour(String timeSlot) {
    try {
      final parts = timeSlot.split('-');
      final startTime = parts[0];
      final endTime = parts[1];

      return '${_format12Hour(startTime)}-${_format12Hour(endTime)}';
    } catch (e) {
      return timeSlot; // Return original if parsing fails
    }
  }

  String _format12Hour(String time24) {
    final parts = time24.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$hour:$minute $period';
  }

  // Optional: Keep demo data as fallback
  void _loadDemoData() {
    schedule(
      const WeeklySchedule(
        monday: [
          TimeSlotEntry(
            day: 'Monday',
            timeSlot: '09:00-09:45',
            flexibility: 'medium',
            milestoneId: 'demo-milestone-1',
            priorityScore: 80,
            allocatedMinutes: 45,
          ),
        ],
        tuesday: [],
        wednesday: [
          TimeSlotEntry(
            day: 'Wednesday',
            timeSlot: '09:00-09:30',
            flexibility: 'medium',
            milestoneId: 'demo-milestone-1',
            priorityScore: 80,
            allocatedMinutes: 30,
          ),
        ],
        thursday: [],
        friday: [],
        saturday: [],
        sunday: [
          TimeSlotEntry(
            day: 'Sunday',
            timeSlot: '10:00-10:30',
            flexibility: 'high',
            milestoneId: 'demo-milestone-1',
            priorityScore: 80,
            allocatedMinutes: 30,
          ),
        ],
      ),
    );
  }
}
