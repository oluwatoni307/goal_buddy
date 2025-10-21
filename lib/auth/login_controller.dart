// controllers/auth_controller.dart

import 'package:get/get.dart';
import 'user_model.dart';
import 'auth_service.dart';

class AuthController extends GetxController {
  final supabaseService = SupabaseService();

  final isLoading = false.obs;
  final currentUser = Rxn<User>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if user already logged in
    currentUser.value = supabaseService.getCurrentUser();
  }

  Future<void> login({required String email, required String password}) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await supabaseService.login(
      email: email,
      password: password,
    );

    isLoading.value = false;

    if (response.success && response.user != null) {
      currentUser.value = response.user;
      Get.offNamed('/home');
    } else {
      errorMessage.value = response.error ?? 'Login failed';
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await supabaseService.signUp(
      email: email,
      password: password,
    );

    isLoading.value = false;

    if (response.success && response.user != null) {
      currentUser.value = response.user;
      Get.offNamed('/home');
    } else {
      errorMessage.value = response.error ?? 'Sign up failed';
    }
  }

  Future<void> logout() async {
    await supabaseService.logout();
    currentUser.value = null;
    Get.offNamed('/login');
  }
}
