import 'package:get/get.dart';
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
      final resp = await _api.get('/home');   // <-- simplified path
      homeData(HomeDataModel.fromJson(resp.data));
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// Toggle habit completion and PATCH to backend
  Future<void> toggleHabit(String id, bool current) async {
    try {
      await _api.patch('/habits/$id', data: {'isCompleted': !current});
      await loadHomeData();
    } catch (e) {
      Get.snackbar('Error', 'Could not update habit');
    }
  }
}