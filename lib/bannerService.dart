import 'package:get/get.dart';

class BannerService extends GetxService {
  final RxBool isVisible = false.obs;
  final RxString message = ''.obs;
  final RxString _bannerType = 'success'.obs; // success, error, info

  // Show a success banner
  void showSuccess(
    String msg, {
    Duration duration = const Duration(seconds: 2),
  }) {
    _show(msg, 'success', duration);
  }

  // Show an error banner
  void showError(String msg, {Duration duration = const Duration(seconds: 4)}) {
    _show(msg, 'error', duration);
  }

  // Show an info banner
  void showInfo(String msg, {Duration duration = const Duration(seconds: 3)}) {
    _show(msg, 'info', duration);
  }

  // Internal show method
  void _show(String msg, String type, Duration duration) {
    message(msg);
    _bannerType(type);
    isVisible(true);

    // Auto-hide after duration
    Future.delayed(duration, () {
      if (isVisible.value) {
        isVisible(false);
      }
    });
  }

  // Manual dismiss
  void hide() {
    isVisible(false);
  }

  // Get banner color based on type
  String get bannerType => _bannerType.value;

  @override
  void onClose() {
    isVisible.close();
    message.close();
    _bannerType.close();
    super.onClose();
  }
}
