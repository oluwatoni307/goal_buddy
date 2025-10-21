// features/profile/profile_controller.dart

import 'package:get/get.dart';
import '../../auth/auth_service.dart';
import '../../auth/user_model.dart';
import '../../services/api_service.dart';
import 'profile_model.dart';
// Import your existing services
// import '../../services/supabase_service.dart';
// import '../../services/api_service.dart';
// import '../../models/user_model.dart';

class ProfileController extends GetxController {
  final SupabaseService _supabaseService;
  final ApiService _apiService;

  ProfileController({
    required SupabaseService supabaseService,
    required ApiService apiService,
  }) : _supabaseService = supabaseService,
       _apiService = apiService;

  // State management
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<ProfileStats?> stats = Rx<ProfileStats?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  /// Load user profile and goal statistics
  Future<void> loadProfile() async {
    isLoading.value = true;
    error.value = '';

    try {
      // Get current user from Supabase
      currentUser.value = _supabaseService.getCurrentUser();

      if (currentUser.value == null) {
        error.value = 'No user logged in';
        return;
      }

      // Fetch goal stats from backend
      final response = await _apiService.get(
        '/profile/${currentUser.value!.id}',
      );

      // Parse response
      if (response.data['success'] == true) {
        stats.value = ProfileStats.fromJson(response.data['data']);
      } else {
        error.value = response.data['error'] ?? 'Failed to load stats';
      }
    } catch (e) {
      error.value = 'Error loading profile: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Get display name from email
  String getDisplayName() {
    if (currentUser.value?.email == null) return 'User';

    final email = currentUser.value!.email;
    final username = email.split('@').first;

    // Convert "john.doe" to "John Doe"
    return username
        .split('.')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '',
        )
        .join(' ');
  }

  /// Handle user logout
  Future<void> handleLogout() async {
    try {
      await _supabaseService.logout();
      // Navigate to login screen
      Get.offAllNamed('/login');
    } catch (e) {
      error.value = 'Logout failed: ${e.toString()}';
    }
  }

  /// Refresh profile data
  Future<void> refresh() async {
    await loadProfile();
  }
}
