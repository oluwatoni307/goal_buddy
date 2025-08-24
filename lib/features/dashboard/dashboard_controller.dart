// GENERATED for feature: dashboard
// TODO: implement
import 'package:get/get.dart';
import '/services/api_service.dart';
import 'dashboard_model.dart';

class AnalyticsController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  // Reactive state
  final Rx<DailyAnalytics?> daily   = Rx(null);
  final Rx<MonthlyAnalytics?> monthly = Rx(null);
  final RxBool dailyLoading   = false.obs;
  final RxBool monthlyLoading = false.obs;
  final RxString dailyError   = ''.obs;
  final RxString monthlyError = ''.obs;

  /* ---------- Public fetchers ---------- */
  Future<void> loadDaily() async {
    try {
      dailyLoading(true);
      dailyError('');
      final resp = await _api.get('/analytics/daily');
      daily(DailyAnalytics.fromJson(resp.data));
    } catch (e) {
      dailyError(e.toString());
    } finally {
      dailyLoading(false);
    }
  }

  Future<void> loadMonthly() async {
    try {
      monthlyLoading(true);
      monthlyError('');
      final resp = await _api.get('/analytics/monthly');
      monthly(MonthlyAnalytics.fromJson(resp.data));
    } catch (e) {
      monthlyError(e.toString());
    } finally {
      monthlyLoading(false);
    }
  }

  /* ---------- Pull-to-refresh ---------- */
  Future<void> refreshAll() async {
    await Future.wait([loadDaily(), loadMonthly()]);
  }

  /* ---------- Lifecycle ---------- */
  @override
  void onInit() {
    super.onInit();
    loadDaily();
    loadMonthly();
  }
}