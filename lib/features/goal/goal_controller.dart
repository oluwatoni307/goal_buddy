// File: lib/features/goal/goal_controller.dart
// FULL GoalDisplayController - user-aware goals list + all helpers

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;
import '/services/api_service.dart';
import 'goal_model.dart';

class GoalDisplayController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  /* ---------- Goals list ---------- */
  final RxList<Goal> activeGoals = <Goal>[].obs;
  final RxList<Goal> completedGoals = <Goal>[].obs;
  final RxBool goalsLoading = false.obs;
  final RxString goalsError = ''.obs;

  /* ---------- Selected goal ---------- */
  final RxString currentGoalId = ''.obs;
  final Rx<Milestones?> goalMilestones = Rx<Milestones?>(null);
  final RxBool milestonesLoading = false.obs;
  final RxString milestonesError = ''.obs;

  /* ---------- Selected milestone ---------- */
  final RxString currentMilestoneId = ''.obs;
  final RxList<Task> milestoneTasks = <Task>[].obs;
  final RxBool tasksLoading = false.obs;
  final RxString tasksError = ''.obs;

  /* ---------- Individual milestone data ---------- */
  final Rx<Milestone?> currentMilestoneData = Rx<Milestone?>(null);
  final RxBool milestoneDataLoading = false.obs;

  /* ---------- Logging Helper ---------- */
  void _log(
    String message, {
    String? endpoint,
    dynamic data,
    bool isError = false,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final prefix = isError ? '❌ ERROR' : '📡 API';
    final endpointInfo = endpoint != null ? ' [$endpoint]' : '';

    print('$prefix$endpointInfo - $timestamp');
    print('  Message: $message');
    if (data != null) print('  Data: $data');
    print('---');

    developer.log(
      message,
      name: 'GoalDisplayController',
      error: isError ? data : null,
    );
  }

  /* ---------- Computed properties ---------- */
  int get totalGoals => activeGoals.length + completedGoals.length;

  double get overallCompletionRate {
    if (totalGoals == 0) return 0.0;
    final totalCompletion =
        activeGoals.fold<double>(0, (sum, goal) => sum + goal.completionRate) +
        completedGoals.fold<double>(
          0,
          (sum, goal) => sum + goal.completionRate,
        );
    return totalCompletion / totalGoals;
  }

  /* ========================================
     NAVIGATION HELPERS - Pure Navigation
     ======================================== */
  void navigateToGoal(String goalId) {
    if (goalId.isEmpty) {
      _log('Cannot navigate to goal - empty ID', isError: true);
      Get.snackbar('Error', 'Invalid goal ID');
      return;
    }
    _log('Navigating to goal: $goalId');
    Get.toNamed('/goals/$goalId');
  }

  void navigateToMilestone(String milestoneId) {
    if (milestoneId.isEmpty) {
      _log('Cannot navigate to milestone - empty ID', isError: true);
      Get.snackbar('Error', 'Invalid milestone ID');
      return;
    }
    _log('Navigating to milestone: $milestoneId');
    Get.toNamed('/milestones/$milestoneId');
  }

  void navigateToTask(String taskId) {
    if (taskId.isEmpty) {
      _log('Cannot navigate to task - empty ID', isError: true);
      Get.snackbar('Error', 'Invalid task ID');
      return;
    }
    _log('Navigating to task: $taskId');
    Get.toNamed('/task/$taskId');
  }

  /* ---------- Lifecycle ---------- */
  @override
  void onInit() {
    super.onInit();
    _log('Controller initialized');
    loadGoals();
  }

  @override
  void onClose() {
    activeGoals.clear();
    completedGoals.clear();
    goalMilestones.value = null;
    milestoneTasks.clear();
    super.onClose();
  }

  /* ========================================
     DATA LOADING METHODS
     ======================================== */

  /// Load all goals for the CURRENT user
  Future<void> loadGoals({bool force = false}) async {
    const endpoint = '/goals';

    if (!force && goalsLoading.value) {
      _log('Goals already loading, skipping duplicate request');
      return;
    }

    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null || uid.isEmpty) {
      goalsError('User not authenticated');
      _log('No user_id available, aborting goals load', isError: true);
      return;
    }

    _log('Loading goals...', endpoint: endpoint, data: 'user_id: $uid');

    try {
      goalsLoading(true);
      goalsError('');

      final resp = await _api.get(endpoint, query: {'user_id': uid});

      _log('Goals response received', endpoint: endpoint);

      if (resp.data == null) throw Exception('Response data is null');

      final raw = (resp.data as List)
          .map((e) => Goal.fromJson(e as Map<String, dynamic>))
          .toList();

      activeGoals.assignAll(raw.where((g) => !g.isCompleted));
      completedGoals.assignAll(raw.where((g) => g.isCompleted));

      _log(
        'Goals loaded',
        data:
            'active: ${activeGoals.length}, completed: ${completedGoals.length}',
      );
    } catch (e, s) {
      goalsError(e.toString());
      _log('Failed to load goals', data: '$e\n$s', isError: true);
    } finally {
      goalsLoading(false);
    }
  }

  Future<void> loadMilestones(String goalId, {bool force = false}) async {
    if (goalId.isEmpty) {
      final errorMsg = 'Goal ID is required to load milestones';
      milestonesError(errorMsg);
      _log(errorMsg, isError: true);
      return;
    }

    if (!force &&
        currentGoalId.value == goalId &&
        goalMilestones.value != null) {
      _log('Skipping milestone load - already loaded for goal: $goalId');
      return;
    }

    if (!force && milestonesLoading.value && currentGoalId.value == goalId) {
      _log('Milestones already loading for this goal, skipping duplicate');
      return;
    }

    final endpoint = '/goals/$goalId/milestones';
    _log('Loading milestones...', endpoint: endpoint, data: 'GoalId: $goalId');

    currentGoalId(goalId);
    goalMilestones.value = null;

    try {
      milestonesLoading(true);
      milestonesError('');

      final resp = await _api.get(endpoint);

      _log('Milestones response received', endpoint: endpoint);

      if (resp.data == null) throw Exception('Response data is null');

      if (currentGoalId.value == goalId) {
        goalMilestones.value = Milestones.fromJson(
          resp.data as Map<String, dynamic>,
        );
        _log(
          'Milestones loaded',
          data: 'Count: ${goalMilestones.value?.milestones.length}',
        );
      }
    } catch (e, s) {
      milestonesError(e.toString());
      _log('Failed to load milestones', data: '$e\n$s', isError: true);
    } finally {
      milestonesLoading(false);
    }
  }

  Future<void> loadTasks(String milestoneId, {bool force = false}) async {
    if (milestoneId.isEmpty) {
      final errorMsg = 'Milestone ID is required to load tasks';
      tasksError(errorMsg);
      _log(errorMsg, isError: true);
      return;
    }

    if (!force &&
        currentMilestoneId.value == milestoneId &&
        milestoneTasks.isNotEmpty) {
      _log('Skipping task load - already loaded for milestone: $milestoneId');
      return;
    }

    if (!force &&
        tasksLoading.value &&
        currentMilestoneId.value == milestoneId) {
      _log('Tasks already loading for this milestone, skipping duplicate');
      return;
    }

    final endpoint = '/milestones/$milestoneId/tasks';
    _log(
      'Loading tasks...',
      endpoint: endpoint,
      data: 'MilestoneId: $milestoneId',
    );

    currentMilestoneId(milestoneId);
    milestoneTasks.clear();

    try {
      tasksLoading(true);
      tasksError('');

      final resp = await _api.get(endpoint);

      _log('Tasks response received', endpoint: endpoint);

      if (resp.data == null) throw Exception('Response data is null');

      if (currentMilestoneId.value == milestoneId) {
        final tasks = (resp.data as List)
            .map((e) => Task.fromJson(e as Map<String, dynamic>))
            .toList();
        milestoneTasks.assignAll(tasks);
        _log('Tasks loaded', data: 'Count: ${milestoneTasks.length}');
      }
    } catch (e, s) {
      tasksError(e.toString());
      _log('Failed to load tasks', data: '$e\n$s', isError: true);
    } finally {
      tasksLoading(false);
    }
  }

  Future<void> loadMilestoneData(
    String milestoneId, {
    bool force = false,
  }) async {
    if (milestoneId.isEmpty) {
      _log('Milestone ID is required', isError: true);
      return;
    }
    if (!force && currentMilestoneData.value?.id == milestoneId) return;

    final endpoint = '/milestones/$milestoneId';
    _log('Loading milestone data...', endpoint: endpoint);

    try {
      milestoneDataLoading(true);
      final resp = await _api.get(endpoint);
      if (resp.data == null) throw Exception('Response data is null');
      currentMilestoneData.value = Milestone.fromJson(
        resp.data as Map<String, dynamic>,
      );
      _log('Milestone data loaded', endpoint: endpoint);
    } catch (e, s) {
      _log('Failed to load milestone data', data: '$e\n$s', isError: true);
    } finally {
      milestoneDataLoading(false);
    }
  }

  /* ---------- Helpers ---------- */
  Goal? getGoalById(String goalId) {
    if (goalId.isEmpty) return null;
    try {
      return activeGoals.firstWhere((g) => g.id == goalId);
    } catch (_) {
      try {
        return completedGoals.firstWhere((g) => g.id == goalId);
      } catch (_) {
        return null;
      }
    }
  }

  Goal? getCurrentGoal() =>
      currentGoalId.value.isEmpty ? null : getGoalById(currentGoalId.value);

  String getCurrentGoalName() => getCurrentGoal()?.name ?? 'Unknown Goal';

  String getCurrentGoalDescription() => getCurrentGoal()?.description ?? '';

  double getCurrentGoalCompletionRate() =>
      getCurrentGoal()?.completionRate ?? 0.0;

  bool isCurrentGoalCompleted() => getCurrentGoal()?.isCompleted ?? false;

  Milestone? getMilestoneById(String id) {
    if (id.isEmpty) return null;
    final list = goalMilestones.value?.milestones ?? [];
    try {
      return list.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  Milestone? getCurrentMilestone() => currentMilestoneId.value.isEmpty
      ? null
      : getMilestoneById(currentMilestoneId.value);

  Future<void> refreshGoals() async => await loadGoals(force: true);

  Future<void> refreshMilestones() async {
    if (currentGoalId.value.isEmpty) return;
    await loadMilestones(currentGoalId.value, force: true);
  }

  Future<void> refreshTasks() async {
    if (currentMilestoneId.value.isEmpty) return;
    await loadTasks(currentMilestoneId.value, force: true);
  }

  void clearGoalSelection() {
    currentGoalId('');
    goalMilestones.value = null;
    milestonesError('');
    clearMilestoneSelection();
  }

  void clearMilestoneSelection() {
    currentMilestoneId('');
    milestoneTasks.clear();
    tasksError('');
  }

  Map<String, int> getMilestoneStats() {
    final list = goalMilestones.value?.milestones ?? [];
    final stats = <String, int>{'pending': 0, 'active': 0, 'completed': 0};
    for (final m in list) {
      stats[m.status.name] = (stats[m.status.name] ?? 0) + 1;
    }
    return stats;
  }

  Map<String, int> getTaskStats() {
    final stats = <String, int>{'pending': 0, 'active': 0, 'completed': 0};
    for (final t in milestoneTasks) {
      stats[t.status.name] = (stats[t.status.name] ?? 0) + 1;
    }
    return stats;
  }
}
