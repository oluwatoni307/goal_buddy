// GENERATED for feature: goal
// TODO: implement
import 'package:get/get.dart';
import '/services/api_service.dart';
import 'goal_model.dart';          // slim Goal model

class GoalDisplayController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  /* ---------- Goals list ---------- */
  final RxList<Goal> activeGoals   = <Goal>[].obs;
  final RxList<Goal> completedGoals = <Goal>[].obs;
  final RxBool goalsLoading = false.obs;
  final RxString goalsError = ''.obs;

  /* ---------- Selected goal ---------- */
  final RxString currentGoalId = ''.obs;
  final Rx<Milestones?> goalMilestones = Rx(null);
  final RxBool milestonesLoading = false.obs;
  final RxString milestonesError = ''.obs;

  /* ---------- Selected milestone ---------- */
  final RxString currentMilestoneId = ''.obs;
  final RxList<Task> milestoneTasks = <Task>[].obs;
  final RxBool tasksLoading = false.obs;
  final RxString tasksError = ''.obs;

  /* ---------- Lifecycle ---------- */
  @override
  void onInit() {
    super.onInit();
    loadGoals(); // initial fetch
  }

  /* ---------- Goals list ---------- */
  Future<void> loadGoals() async {
    try {
      goalsLoading(true);
      goalsError('');
      final resp = await _api.get('/goals');
      final raw = (resp.data as List).map((e) => Goal.fromJson(e)).toList();
      activeGoals.assignAll(raw.where((g) => !g.isCompleted));
      completedGoals.assignAll(raw.where((g) => g.isCompleted));
    } catch (e) {
      goalsError(e.toString());
    } finally {
      goalsLoading(false);
    }
  }

  /* ---------- Milestones for a goal ---------- */
  Future<void> loadMilestones(String goalId) async {
    currentGoalId(goalId);
    try {
      milestonesLoading(true);
      milestonesError('');
      final resp = await _api.get('/goals/$goalId/milestones');
      goalMilestones(Milestones.fromJson(resp.data));
    } catch (e) {
      milestonesError(e.toString());
    } finally {
      milestonesLoading(false);
    }
  }

  /* ---------- Tasks for a milestone ---------- */
  Future<void> loadTasks(String milestoneId) async {
    currentMilestoneId(milestoneId);
    try {
      tasksLoading(true);
      tasksError('');
      final resp = await _api.get('/milestones/$milestoneId/tasks');
      milestoneTasks(
          (resp.data as List).map((e) => Task.fromJson(e)).toList());
    } catch (e) {
      tasksError(e.toString());
    } finally {
      tasksLoading(false);
    }
  }

  /* ---------- Utility ---------- */
  Future<void> refreshGoals() async => await loadGoals();
}