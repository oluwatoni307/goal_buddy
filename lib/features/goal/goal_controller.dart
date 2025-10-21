// UPDATED GoalDisplayController with Navigation Helpers + Smart Loading
// GENERATED for feature: goal
// Added navigation methods for consistent controller-first pattern

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

  /* ---------- Individual milestone data (for detail screen) ---------- */
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

    // Also log to dart:developer for better debugging
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

  /* ---------- Smart Loading Checks ---------- */

  /// Check if milestones need to be loaded for a goal
  bool shouldLoadMilestones(String goalId) {
    if (goalId.isEmpty) {
      _log('Cannot check milestones - empty goal ID', isError: true);
      return false;
    }

    // Load if different goal OR no data loaded yet
    final needsLoad =
        currentGoalId.value != goalId || goalMilestones.value == null;

    if (!needsLoad) {
      _log('Milestones already loaded for goal: $goalId');
    }

    return needsLoad;
  }

  /// Check if tasks need to be loaded for a milestone
  bool shouldLoadTasks(String milestoneId) {
    if (milestoneId.isEmpty) {
      _log('Cannot check tasks - empty milestone ID', isError: true);
      return false;
    }

    // Load if different milestone OR no tasks loaded yet
    final needsLoad =
        currentMilestoneId.value != milestoneId || milestoneTasks.isEmpty;

    if (!needsLoad) {
      _log('Tasks already loaded for milestone: $milestoneId');
    }

    return needsLoad;
  }

  /* ---------- Navigation Helpers (Controller-First Pattern) ---------- */

  /// Navigate to goal detail screen with smart loading
  void navigateToGoal(String goalId) {
    if (goalId.isEmpty) {
      _log('Cannot navigate to goal - empty ID', isError: true);
      return;
    }

    _log('Navigating to goal: $goalId');

    // Set controller state FIRST (synchronous)
    currentGoalId(goalId);

    // Navigate immediately (non-blocking)
    Get.toNamed('/goals/$goalId');

    // Load milestones in background if needed
    if (shouldLoadMilestones(goalId)) {
      Future.microtask(() => loadMilestones(goalId));
    }
  }

  /// Navigate to milestone detail screen with smart loading
  void navigateToMilestone(String milestoneId) {
    if (milestoneId.isEmpty) {
      _log('Cannot navigate to milestone - empty ID', isError: true);
      return;
    }

    _log('Navigating to milestone: $milestoneId');

    // Set controller state FIRST (synchronous)
    currentMilestoneId(milestoneId);

    // Navigate immediately (non-blocking) - CORRECTED ROUTE
    Get.toNamed('/milestones/$milestoneId');

    // Load tasks in background if needed
    if (shouldLoadTasks(milestoneId)) {
      Future.microtask(() => loadTasks(milestoneId));
    }
  }

  /// Navigate to task detail screen
  void navigateToTask(String taskId) {
    if (taskId.isEmpty) {
      _log('Cannot navigate to task - empty ID', isError: true);
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
    loadGoals(); // initial fetch
  }

  /* ---------- Goals list ---------- */
  Future<void> loadGoals({bool force = false}) async {
    final endpoint = '/goals';

    // Skip if already loading
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
        data:
            'Status: ${resp.statusCode}, Response type: ${resp.data.runtimeType}',
      );

      // Safe null check for response data
      if (resp.data == null) {
        throw Exception('Response data is null');
      }

      _log('Raw response data', endpoint: endpoint, data: resp.data);

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

  /* ---------- Milestones for a goal ---------- */
  Future<void> loadMilestones(String goalId, {bool force = false}) async {
    // VALIDATION: Check if goalId is empty or null
    if (goalId.isEmpty) {
      final errorMsg = 'Goal ID is required to load milestones';
      milestonesError(errorMsg);
      _log(errorMsg, isError: true);
      return;
    }

    // Skip if already loaded (unless forced)
    if (!force && !shouldLoadMilestones(goalId)) {
      _log('Skipping milestone load - already loaded for goal: $goalId');
      return;
    }

    // Skip if already loading the same goal
    if (!force && milestonesLoading.value && currentGoalId.value == goalId) {
      _log(
        'Milestones already loading for this goal, skipping duplicate request',
      );
      return;
    }

    final endpoint = '/goals/$goalId/milestones';
    _log(
      'Loading milestones...',
      endpoint: endpoint,
      data: 'GoalId: $goalId${force ? ' (FORCED)' : ''}',
    );

    currentGoalId(goalId);

    try {
      milestonesLoading(true);
      milestonesError('');

      final resp = await _api.get(endpoint);

      _log(
        'Milestones response received',
        endpoint: endpoint,
        data:
            'Status: ${resp.statusCode}, Response type: ${resp.data.runtimeType}',
      );

      // Safe null check for response data
      if (resp.data == null) {
        throw Exception('Response data is null');
      }

      _log('Raw milestones data', endpoint: endpoint, data: resp.data);

      goalMilestones.value = Milestones.fromJson(
        resp.data as Map<String, dynamic>,
      );

      final count = goalMilestones.value?.milestones.length ?? 0;
      _log(
        'Milestones loaded successfully',
        endpoint: endpoint,
        data: 'Count: $count',
      );
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

  /* ---------- Tasks for a milestone ---------- */
  Future<void> loadTasks(String milestoneId, {bool force = false}) async {
    // VALIDATION: Check if milestoneId is empty or null
    if (milestoneId.isEmpty) {
      final errorMsg = 'Milestone ID is required to load tasks';
      tasksError(errorMsg);
      _log(errorMsg, isError: true);
      return;
    }

    // Skip if already loaded (unless forced)
    if (!force && !shouldLoadTasks(milestoneId)) {
      _log('Skipping task load - already loaded for milestone: $milestoneId');
      return;
    }

    // Skip if already loading the same milestone
    if (!force &&
        tasksLoading.value &&
        currentMilestoneId.value == milestoneId) {
      _log(
        'Tasks already loading for this milestone, skipping duplicate request',
      );
      return;
    }

    final endpoint = '/milestones/$milestoneId/tasks';
    _log(
      'Loading tasks...',
      endpoint: endpoint,
      data: 'MilestoneId: $milestoneId${force ? ' (FORCED)' : ''}',
    );

    currentMilestoneId(milestoneId);

    try {
      tasksLoading(true);
      tasksError('');

      final resp = await _api.get(endpoint);

      _log(
        'Tasks response received',
        endpoint: endpoint,
        data:
            'Status: ${resp.statusCode}, Response type: ${resp.data.runtimeType}',
      );

      // Safe null check for response data
      if (resp.data == null) {
        throw Exception('Response data is null');
      }

      _log('Raw tasks data', endpoint: endpoint, data: resp.data);

      final List<dynamic> dataList = resp.data is List ? resp.data as List : [];
      final tasks = dataList
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();

      milestoneTasks.assignAll(tasks);

      _log(
        'Tasks loaded successfully',
        endpoint: endpoint,
        data: 'Count: ${milestoneTasks.length}',
      );
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

  /* ---------- Load individual milestone data ---------- */
  Future<void> loadMilestoneData(
    String milestoneId, {
    bool force = false,
  }) async {
    if (milestoneId.isEmpty) {
      final errorMsg = 'Milestone ID is required';
      _log(errorMsg, isError: true);
      return;
    }

    // Skip if already loaded (unless forced)
    if (!force && currentMilestoneData.value?.id == milestoneId) {
      _log('Milestone data already loaded: $milestoneId');
      return;
    }

    final endpoint = '/milestones/$milestoneId';
    _log(
      'Loading milestone data...',
      endpoint: endpoint,
      data: 'MilestoneId: $milestoneId${force ? ' (FORCED)' : ''}',
    );

    try {
      milestoneDataLoading(true);

      final resp = await _api.get(endpoint);

      _log(
        'Milestone data response received',
        endpoint: endpoint,
        data:
            'Status: ${resp.statusCode}, Response type: ${resp.data.runtimeType}',
      );

      if (resp.data == null) {
        throw Exception('Response data is null');
      }

      _log('Raw milestone data', endpoint: endpoint, data: resp.data);

      currentMilestoneData.value = Milestone.fromJson(
        resp.data as Map<String, dynamic>,
      );

      _log(
        'Milestone data loaded successfully',
        endpoint: endpoint,
        data: 'Milestone: ${currentMilestoneData.value?.objective}',
      );
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

  /* ---------- Data Coordination Helpers ---------- */

  /// Find goal by ID from both active and completed lists
  Goal? getGoalById(String goalId) {
    if (goalId.isEmpty) {
      _log('Cannot get goal - empty ID provided', isError: true);
      return null;
    }

    try {
      return activeGoals.firstWhere((goal) => goal.id == goalId);
    } catch (e) {
      try {
        return completedGoals.firstWhere((goal) => goal.id == goalId);
      } catch (e) {
        _log('Goal not found with ID: $goalId', isError: true);
        return null;
      }
    }
  }

  /// Get currently selected goal details
  Goal? getCurrentGoal() {
    if (currentGoalId.value.isEmpty) {
      return null;
    }
    return getGoalById(currentGoalId.value);
  }

  /// Get goal name for current milestones view
  String getCurrentGoalName() {
    final goal = getCurrentGoal();
    return goal?.name ?? 'Unknown Goal';
  }

  /// Get goal description for current milestones view
  String getCurrentGoalDescription() {
    final goal = getCurrentGoal();
    return goal?.description ?? '';
  }

  /// Get goal completion rate for current milestones view
  double getCurrentGoalCompletionRate() {
    final goal = getCurrentGoal();
    return goal?.completionRate ?? 0.0;
  }

  /// Check if current goal is completed
  bool isCurrentGoalCompleted() {
    final goal = getCurrentGoal();
    return goal?.isCompleted ?? false;
  }

  /// Get milestone by ID from current milestones
  Milestone? getMilestoneById(String milestoneId) {
    if (milestoneId.isEmpty) {
      _log('Cannot get milestone - empty ID provided', isError: true);
      return null;
    }

    final milestones = goalMilestones.value;
    if (milestones == null) {
      _log('No milestones loaded', isError: true);
      return null;
    }

    try {
      return milestones.milestones.firstWhere(
        (milestone) => milestone.id == milestoneId,
      );
    } catch (e) {
      _log('Milestone not found with ID: $milestoneId', isError: true);
      return null;
    }
  }

  /// Get currently selected milestone details
  Milestone? getCurrentMilestone() {
    if (currentMilestoneId.value.isEmpty) {
      return null;
    }
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

    _log(
      'Refreshing milestones... (FORCED)',
      data: 'GoalId: ${currentGoalId.value}',
    );
    await loadMilestones(currentGoalId.value, force: true);
  }

  Future<void> refreshTasks() async {
    if (currentMilestoneId.value.isEmpty) {
      _log('Cannot refresh tasks - no milestone selected', isError: true);
      return;
    }

    _log(
      'Refreshing tasks... (FORCED)',
      data: 'MilestoneId: ${currentMilestoneId.value}',
    );
    await loadTasks(currentMilestoneId.value, force: true);
  }

  Future<void> refreshAll() async {
    _log('Refreshing all data... (FORCED)');
    await loadGoals(force: true);
    if (currentGoalId.value.isNotEmpty) {
      await loadMilestones(currentGoalId.value, force: true);
    }
    if (currentMilestoneId.value.isNotEmpty) {
      await loadTasks(currentMilestoneId.value, force: true);
    }
    _log('All data refreshed');
  }

  /* ---------- Navigation Helpers ---------- */

  /// Clear milestone selection when navigating away
  void clearMilestoneSelection() {
    _log('Clearing milestone selection');
    currentMilestoneId('');
    milestoneTasks.clear();
    tasksError('');
  }

  /// Clear goal selection when navigating away
  void clearGoalSelection() {
    _log('Clearing goal selection');
    currentGoalId('');
    goalMilestones.value = null;
    milestonesError('');
    clearMilestoneSelection();
  }

  /* ---------- Status Management ---------- */

  /// Get milestone completion statistics for current goal
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

  /// Get task completion statistics for current milestone
  Map<String, int> getTaskStats() {
    final stats = <String, int>{'pending': 0, 'active': 0, 'completed': 0};
    for (final task in milestoneTasks) {
      final statusName = task.status.name;
      stats[statusName] = (stats[statusName] ?? 0) + 1;
    }
    return stats;
  }
}
