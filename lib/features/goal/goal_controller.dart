// FIXED GoalDisplayController - No Race Conditions
// File: lib/features/goal/goal_controller.dart
// Navigation is pure, screens handle loading in initState()

import 'package:get/get.dart';
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
    if (data != null) {
      print('  Data: $data');
    }
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
     Screens handle their own loading
     ======================================== */

  /// Navigate to goal detail screen
  void navigateToGoal(String goalId) {
    if (goalId.isEmpty) {
      _log('Cannot navigate to goal - empty ID', isError: true);
      Get.snackbar('Error', 'Invalid goal ID');
      return;
    }

    _log('Navigating to goal: $goalId');
    Get.toNamed('/goals/$goalId');
  }

  /// Navigate to milestone detail screen
  void navigateToMilestone(String milestoneId) {
    if (milestoneId.isEmpty) {
      _log('Cannot navigate to milestone - empty ID', isError: true);
      Get.snackbar('Error', 'Invalid milestone ID');
      return;
    }

    _log('Navigating to milestone: $milestoneId');
    Get.toNamed('/milestones/$milestoneId');
  }

  /// Navigate to task detail screen
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
    // Clean up to prevent memory leaks
    activeGoals.clear();
    completedGoals.clear();
    goalMilestones.value = null;
    milestoneTasks.clear();
    super.onClose();
  }

  /* ========================================
     DATA LOADING METHODS
     Pure functions - no navigation logic
     Built-in caching to prevent duplicate loads
     ======================================== */

  /// Load all goals
  Future<void> loadGoals({bool force = false}) async {
    final endpoint = '/goals';

    if (!force && goalsLoading.value) {
      _log('Goals already loading, skipping duplicate request');
      return;
    }

    _log(
      'Loading goals...',
      endpoint: endpoint,
      data: force ? 'FORCED' : 'Normal',
    );

    try {
      goalsLoading(true);
      goalsError('');

      final resp = await _api.get(endpoint);

      _log(
        'Goals response received',
        endpoint: endpoint,
        data: 'Status: ${resp.statusCode}',
      );

      if (resp.data == null) {
        throw Exception('Response data is null');
      }

      final List<dynamic> dataList = resp.data is List ? resp.data as List : [];
      final raw = dataList
          .map((e) => Goal.fromJson(e as Map<String, dynamic>))
          .toList();

      activeGoals.assignAll(raw.where((g) => !g.isCompleted));
      completedGoals.assignAll(raw.where((g) => g.isCompleted));

      _log(
        'Goals loaded successfully',
        endpoint: endpoint,
        data:
            'Active: ${activeGoals.length}, Completed: ${completedGoals.length}',
      );
    } catch (e, stackTrace) {
      final errorMsg = e.toString();
      goalsError(errorMsg);
      _log(
        'Failed to load goals',
        endpoint: endpoint,
        data: '$errorMsg\n$stackTrace',
        isError: true,
      );
    } finally {
      goalsLoading(false);
    }
  }

  /// Load milestones for a goal
  /// Includes built-in caching - won't reload if already loaded for this goal
  Future<void> loadMilestones(String goalId, {bool force = false}) async {
    if (goalId.isEmpty) {
      final errorMsg = 'Goal ID is required to load milestones';
      milestonesError(errorMsg);
      _log(errorMsg, isError: true);
      return;
    }

    // ✅ Check if already loaded for THIS specific goal
    if (!force &&
        currentGoalId.value == goalId &&
        goalMilestones.value != null) {
      _log('Skipping milestone load - already loaded for goal: $goalId');
      return;
    }

    // Prevent duplicate concurrent requests for the same goal
    if (!force && milestonesLoading.value && currentGoalId.value == goalId) {
      _log('Milestones already loading for this goal, skipping duplicate');
      return;
    }

    final endpoint = '/goals/$goalId/milestones';
    _log('Loading milestones...', endpoint: endpoint, data: 'GoalId: $goalId');

    // ✅ Set BEFORE making API call to prevent race conditions
    currentGoalId(goalId);
    goalMilestones.value = null; // Clear stale data immediately

    try {
      milestonesLoading(true);
      milestonesError('');

      final resp = await _api.get(endpoint);

      _log('Milestones response received', endpoint: endpoint);

      if (resp.data == null) {
        throw Exception('Response data is null');
      }

      // ✅ Only update if we're still viewing this goal
      if (currentGoalId.value == goalId) {
        goalMilestones.value = Milestones.fromJson(
          resp.data as Map<String, dynamic>,
        );

        final count = goalMilestones.value?.milestones.length ?? 0;
        _log(
          'Milestones loaded successfully',
          endpoint: endpoint,
          data: 'Count: $count',
        );
      } else {
        _log(
          'Discarding milestone response - goal changed',
          endpoint: endpoint,
        );
      }
    } catch (e, stackTrace) {
      final errorMsg = e.toString();
      milestonesError(errorMsg);
      _log(
        'Failed to load milestones',
        endpoint: endpoint,
        data: '$errorMsg\n$stackTrace',
        isError: true,
      );
    } finally {
      milestonesLoading(false);
    }
  }

  /// Load tasks for a milestone
  /// Includes built-in caching - won't reload if already loaded for this milestone
  Future<void> loadTasks(String milestoneId, {bool force = false}) async {
    if (milestoneId.isEmpty) {
      final errorMsg = 'Milestone ID is required to load tasks';
      tasksError(errorMsg);
      _log(errorMsg, isError: true);
      return;
    }

    // ✅ Check if already loaded for THIS specific milestone
    if (!force &&
        currentMilestoneId.value == milestoneId &&
        milestoneTasks.isNotEmpty) {
      _log('Skipping task load - already loaded for milestone: $milestoneId');
      return;
    }

    // Prevent duplicate concurrent requests
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

    // ✅ Set BEFORE making API call to prevent race conditions
    currentMilestoneId(milestoneId);
    milestoneTasks.clear(); // Clear stale data immediately

    try {
      tasksLoading(true);
      tasksError('');

      final resp = await _api.get(endpoint);

      _log('Tasks response received', endpoint: endpoint);

      if (resp.data == null) {
        throw Exception('Response data is null');
      }

      // ✅ Only update if we're still viewing this milestone
      if (currentMilestoneId.value == milestoneId) {
        final List<dynamic> dataList = resp.data is List
            ? resp.data as List
            : [];
        final tasks = dataList
            .map((e) => Task.fromJson(e as Map<String, dynamic>))
            .toList();

        milestoneTasks.assignAll(tasks);

        _log(
          'Tasks loaded successfully',
          endpoint: endpoint,
          data: 'Count: ${milestoneTasks.length}',
        );
      } else {
        _log(
          'Discarding task response - milestone changed',
          endpoint: endpoint,
        );
      }
    } catch (e, stackTrace) {
      final errorMsg = e.toString();
      tasksError(errorMsg);
      _log(
        'Failed to load tasks',
        endpoint: endpoint,
        data: '$errorMsg\n$stackTrace',
        isError: true,
      );
    } finally {
      tasksLoading(false);
    }
  }

  /// Load individual milestone data
  Future<void> loadMilestoneData(
    String milestoneId, {
    bool force = false,
  }) async {
    if (milestoneId.isEmpty) {
      final errorMsg = 'Milestone ID is required';
      _log(errorMsg, isError: true);
      return;
    }

    if (!force && currentMilestoneData.value?.id == milestoneId) {
      _log('Milestone data already loaded: $milestoneId');
      return;
    }

    final endpoint = '/milestones/$milestoneId';
    _log('Loading milestone data...', endpoint: endpoint);

    try {
      milestoneDataLoading(true);

      final resp = await _api.get(endpoint);

      if (resp.data == null) {
        throw Exception('Response data is null');
      }

      currentMilestoneData.value = Milestone.fromJson(
        resp.data as Map<String, dynamic>,
      );

      _log('Milestone data loaded successfully', endpoint: endpoint);
    } catch (e, stackTrace) {
      final errorMsg = e.toString();
      _log(
        'Failed to load milestone data',
        endpoint: endpoint,
        data: '$errorMsg\n$stackTrace',
        isError: true,
      );
    } finally {
      milestoneDataLoading(false);
    }
  }

  /* ---------- Data Helper Methods ---------- */

  Goal? getGoalById(String goalId) {
    if (goalId.isEmpty) return null;
    try {
      return activeGoals.firstWhere((goal) => goal.id == goalId);
    } catch (e) {
      try {
        return completedGoals.firstWhere((goal) => goal.id == goalId);
      } catch (e) {
        return null;
      }
    }
  }

  Goal? getCurrentGoal() {
    if (currentGoalId.value.isEmpty) return null;
    return getGoalById(currentGoalId.value);
  }

  String getCurrentGoalName() {
    final goal = getCurrentGoal();
    if (goal == null) {
      _log('Warning: Current goal is null', isError: true);
    }
    return goal?.name ?? 'Unknown Goal';
  }

  String getCurrentGoalDescription() {
    return getCurrentGoal()?.description ?? '';
  }

  double getCurrentGoalCompletionRate() {
    return getCurrentGoal()?.completionRate ?? 0.0;
  }

  bool isCurrentGoalCompleted() {
    return getCurrentGoal()?.isCompleted ?? false;
  }

  Milestone? getMilestoneById(String milestoneId) {
    if (milestoneId.isEmpty) return null;
    final milestones = goalMilestones.value;
    if (milestones == null) return null;

    try {
      return milestones.milestones.firstWhere((m) => m.id == milestoneId);
    } catch (e) {
      return null;
    }
  }

  Milestone? getCurrentMilestone() {
    if (currentMilestoneId.value.isEmpty) return null;
    return getMilestoneById(currentMilestoneId.value);
  }

  /* ---------- Refresh Methods ---------- */

  Future<void> refreshGoals() async {
    _log('Refreshing goals... (FORCED)');
    await loadGoals(force: true);
  }

  Future<void> refreshMilestones() async {
    if (currentGoalId.value.isEmpty) {
      _log('Cannot refresh milestones - no goal selected', isError: true);
      return;
    }
    _log('Refreshing milestones... (FORCED)');
    await loadMilestones(currentGoalId.value, force: true);
  }

  Future<void> refreshTasks() async {
    if (currentMilestoneId.value.isEmpty) {
      _log('Cannot refresh tasks - no milestone selected', isError: true);
      return;
    }
    _log('Refreshing tasks... (FORCED)');
    await loadTasks(currentMilestoneId.value, force: true);
  }

  /* ---------- Clear Methods ---------- */

  void clearMilestoneSelection() {
    _log('Clearing milestone selection');
    currentMilestoneId('');
    milestoneTasks.clear();
    tasksError('');
  }

  void clearGoalSelection() {
    _log('Clearing goal selection');
    currentGoalId('');
    goalMilestones.value = null;
    milestonesError('');
    clearMilestoneSelection();
  }

  /* ---------- Statistics ---------- */

  Map<String, int> getMilestoneStats() {
    final milestones = goalMilestones.value;
    if (milestones == null) {
      return {'pending': 0, 'active': 0, 'completed': 0};
    }

    final stats = <String, int>{'pending': 0, 'active': 0, 'completed': 0};
    for (final milestone in milestones.milestones) {
      final statusName = milestone.status.name;
      stats[statusName] = (stats[statusName] ?? 0) + 1;
    }
    return stats;
  }

  Map<String, int> getTaskStats() {
    final stats = <String, int>{'pending': 0, 'active': 0, 'completed': 0};
    for (final task in milestoneTasks) {
      final statusName = task.status.name;
      stats[statusName] = (stats[statusName] ?? 0) + 1;
    }
    return stats;
  }
}
