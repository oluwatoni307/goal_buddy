// GENERATED for feature: schedule
// ignore_for_file: unnecessary_null_comparison, unused_element

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid == null || uid.isEmpty) {
        error.value = 'User not authenticated';
        return;
      }

      final response = await _api.get('/schedule', query: {'user_id': uid});

      dynamic body;
      try {
        body = (response as dynamic).data ?? response;
      } catch (_) {
        body = response;
      }

      if (body is List && body.isNotEmpty) {
        final scheduleData = ScheduleData.fromJson(body[0]);
        schedule.value = scheduleData.scheduleData;
      } else if (body is Map<String, dynamic>) {
        if (body.containsKey('schedule_data') &&
            body['schedule_data'] != null) {
          schedule.value = WeeklySchedule.fromJson(body['schedule_data']);
        } else {
          schedule.value = WeeklySchedule.fromJson(body);
        }
      } else {
        error.value = 'No schedule data found';
      }
    } catch (e) {
      error.value = 'Failed to load schedule: $e';
      // _loadDemoData(); // optional fallback
    } finally {
      loading.value = false;
    }
  }

  Future<void> refreshSchedule() async => await loadSchedule();

  // -------------------------------------------------
  // Helper: convert 24-hour "HH:mm-HH:mm" → "H:mm AM-H:mm PM"
  // -------------------------------------------------
  String convertTo12Hour(String timeSlot) {
    try {
      final parts = timeSlot.split('-');
      return '${_format12Hour(parts[0])}-${_format12Hour(parts[1])}';
    } catch (_) {
      return timeSlot;
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

  // -------------------------------------------------
  // Optional demo data (fallback if API fails)
  // -------------------------------------------------
  void _loadDemoData() {
    schedule(
      const WeeklySchedule(
        monday: [
          TimeSlotEntry(
            day: 'Monday',
            timeSlot: '09:00-09:45',
            flexibility: 'medium',
            Milestone_name: 'demo-milestone-1',
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
            Milestone_name: 'demo-milestone-1',
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
            Milestone_name: 'demo-milestone-1',
            priorityScore: 80,
            allocatedMinutes: 30,
          ),
        ],
      ),
    );
  }
}
