// ignore_for_file: unused_import

import 'package:get/get.dart';
import 'package:goal_buddy/features/onboarding/pages/onboarding_page1.dart';
import 'package:goal_buddy/splash.dart';
import 'auth/auth_service.dart';
import 'auth/login_screen.dart';
import 'features/dashboard/pages/dashboard_page3.dart';
import 'features/goal/goal_controller.dart';
import 'features/goal/pages/goal_page1.dart';
import 'features/goal/pages/goal_page2.dart';
import 'features/goal/pages/goal_page3.dart';
import 'features/goal_define/goal_define_controller.dart';
import 'features/goal_define/pages/analysis.dart';
import 'features/goal_define/pages/step1.dart';
import 'features/goal_define/pages/step2.dart';
import 'features/home/home_controller.dart';
import 'features/home/home_screen.dart';
import 'features/dashboard/pages/dashboard_page1.dart';
import 'features/dashboard/dashboard_controller.dart';

import 'features/onboarding/onboarding_controller.dart';
import 'features/profile/profile_controller.dart';
import 'features/profile/profile_screen.dart';
import 'features/schedule/pages/schedule_page1.dart';
import 'features/schedule/schedule_controller.dart';
import 'features/task/pages/task_page1.dart';
import 'features/task/task_controller.dart';
import 'services/api_service.dart';
import 'settings/settings_screen.dart';

class Routes {
  static const login = '/login';
  static const home = '/home';
  static const profile = '/profile';
  static const settings = '/settings';
  static const goalStep1 = '/goal/step1';
  static const goalStep2 = '/goal/step2';
  static const goalAnalyze = '/goal/analysis';
  static const dashboard = '/dashboard';
  static const taskComplete = '/tasks/:taskId/complete';
  static const onboarding = '/onboarding';
  static const weeklySchedule = '/schedule';
  static const splash = '/splash';

  // ----- route names -----
  static const goalsList = '/goals';
  static const goalDetail = '/goals/:id';
  static const milestoneDetail = '/milestones/:id';

  static final pages = [
    GetPage(name: login, page: () => const AuthScreen()),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
      }),
    ),
    GetPage(name: splash, page: () => const SplashScreen()),

    GetPage(
      name: weeklySchedule,
      page: () => const WeeklyScheduleScreen(),
      binding: BindingsBuilder(() {
        Get.put(ScheduleController());
      }),
    ),
    GetPage(
      name: goalStep1,
      page: () => const GoalStep1Screen(),
      binding: _GoalCreationBinding(),
    ),
    GetPage(
      name: taskComplete,
      page: () => const TaskCompletionScreen(),
      binding: BindingsBuilder(() {
        Get.put(TaskCompletionController());
      }),
    ),
    GetPage(
      name: goalStep2,
      page: () => const GoalStep2Screen(),
      binding: _GoalCreationBinding(),
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
      binding: BindingsBuilder(() {
        Get.put(OnboardingController());
      }),
    ),
    GetPage(
      name: dashboard,
      page: () => const DashboardScreen(),
      binding: BindingsBuilder(() {
        Get.put(AnalyticsController());
      }),
    ),
    GetPage(
      name: goalAnalyze,
      page: () => const GoalAnalysisScreen(),
      binding: _GoalCreationBinding(),
    ),

    // ===== GOAL DISPLAY ROUTES WITH SHARED CONTROLLER =====
    GetPage(
      name: goalsList,
      page: () => const GoalsListScreen(),
      binding: _GoalDisplayBinding(),
    ),
    GetPage(
      name: goalDetail,
      page: () => const GoalDetailScreen(),
      binding: _GoalDisplayBinding(), // ✅ ADDED BINDING
    ),
    GetPage(
      name: milestoneDetail,
      page: () => const MilestoneDetailScreen(),
      binding: _GoalDisplayBinding(), // ✅ ADDED BINDING
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: BindingsBuilder(() {
        // Register services if not already registered
        if (!Get.isRegistered<SupabaseService>()) {
          Get.put(SupabaseService());
        }
        if (!Get.isRegistered<ApiService>()) {
          Get.put(ApiService());
        }

        // Now register controller with dependencies
        Get.put(
          ProfileController(
            supabaseService: Get.find<SupabaseService>(),
            apiService: Get.find<ApiService>(),
          ),
        );
      }),
    ),
  ];
}

// ----- shared binding for goal creation -----
class _GoalCreationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<GoalCreationController>()) {
      Get.put(GoalCreationController(), permanent: true);
    }
  }
}

// ----- shared binding for goal display -----
class _GoalDisplayBinding extends Bindings {
  @override
  void dependencies() {
    // Use lazyPut so it's created only when needed, but reused across screens
    if (!Get.isRegistered<GoalDisplayController>()) {
      Get.lazyPut<GoalDisplayController>(() => GoalDisplayController());
    }
  }
}
