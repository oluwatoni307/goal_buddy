import 'package:get/get.dart';
import 'app_tracker.dart';
import 'home_model.dart';
import '../../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  // Reactive state
  final Rx<HomeDataModel?> homeData = Rx(null);
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading(true);
      error('');

      // Check if first open today and alert backend
      final hasOpened = AppOpenTracker.hasOpenedToday();
      if (!hasOpened) {
        // First open today - just call the endpoint
        await _alertBackendFirstOpen();
      }

      // Then load home data
      final resp = await _api.get('/home');
      homeData(HomeDataModel.fromJson(resp.data));
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// Alert backend that this is the first open today
  Future<void> _alertBackendFirstOpen() async {
    try {
      await _api.post('/app-opened');
      print('Backend alerted: First open today');
    } catch (e) {
      // Don't block the app if this fails
      print('Failed to alert backend: $e');
    }
  }

  Future<void> toggleHabit(String id, bool current) async {
    try {
      await _api.patch('/habits/$id', data: {'isCompleted': !current});
      await loadHomeData();
    } catch (e) {
      Get.snackbar('Error', 'Could not update habit');
    }
  }
}
