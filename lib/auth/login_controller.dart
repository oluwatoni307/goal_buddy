// auth/login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes.dart';
import 'auth_service.dart';
import 'user_model.dart';

class AuthController extends GetxController {
  final supabaseService = SupabaseService();

  final isLoading = false.obs;
  final currentUser = Rxn<User>();
  final errorMessage = ''.obs;
  final isCheckingAuth = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  // Check authentication status and navigate accordingly
  Future<void> _checkAuthStatus() async {
    isCheckingAuth.value = true;

    // Small delay to show splash screen (optional, adjust as needed)
    await Future.delayed(const Duration(milliseconds: 800));

    final user = supabaseService.getCurrentUser();

    if (user != null) {
      currentUser.value = user;
      // User is logged in, go directly to home
      Get.offAllNamed(Routes.home);
    } else {
      // User is not logged in, show onboarding
      Get.offAllNamed(Routes.onboarding);
    }

    isCheckingAuth.value = false;
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
      Get.offAllNamed(Routes.home);
    } else {
      errorMessage.value = response.error ?? 'Login failed';
      Get.snackbar(
        'Login Failed',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
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
      Get.offAllNamed(Routes.home);
    } else {
      errorMessage.value = response.error ?? 'Sign up failed';
      Get.snackbar(
        'Sign Up Failed',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    await supabaseService.logout();
    currentUser.value = null;
    isLoading.value = false;
    Get.offAllNamed(Routes.login);
  }

  // Manual refresh of auth status (useful for debugging or pull-to-refresh)
  Future<void> refreshAuthStatus() async {
    await _checkAuthStatus();
  }

  // Check if user is authenticated (helper method)
  bool get isAuthenticated => currentUser.value != null;
}
