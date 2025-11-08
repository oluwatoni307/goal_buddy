import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // add this
import 'app_tracker.dart';
import 'home_model.dart';
import '../../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  /* ---------- reactive state ---------- */
  final Rx<HomeDataModel?> homeData = Rx(null);
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  /* ---------- helpers ---------- */
  String? get _userId =>
      Supabase.instance.client.auth.currentUser?.id; // ← current user

  /* ---------- life-cycle ---------- */
  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  /* ---------- API ---------- */
  Future<void> loadHomeData() async {
    final uid = _userId;
    if (uid == null) {
      error('Not logged in');
      isLoading(false);
      return;
    }

    try {
      isLoading(true);
      error('');

      AppOpenTracker.hasOpenedToday(); // keeps your old logic

      final resp = await _api.get(
        '/home',
        query: {'user_id': uid},
      ); // ← query param
      homeData(HomeDataModel.fromJson(resp.data));
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }

  /* ---------- UI helpers ---------- */
  Future<void> toggleHabit(String id, bool current) async {
    try {
      await _api.patch('/habits/$id', data: {'isCompleted': !current});
      await loadHomeData(); // refresh list
    } catch (e) {
      Get.snackbar('Error', 'Could not update habit');
    }
  }
}
