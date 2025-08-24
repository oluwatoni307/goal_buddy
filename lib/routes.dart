// ignore_for_file: unused_import

import 'package:get/get.dart';
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

// ignore: duplicate_ignore
// ignore: unused_import
import 'features/profile/profile_screen.dart';
import 'features/task/pages/task_page1.dart';
import 'features/task/task_controller.dart';
import 'settings/settings_screen.dart';

class Routes {
  static const login    = '/login';
  static const home     = '/home';
  static const profile  = '/profile';
  static const settings = '/settings';
  static const goalStep1   = '/goal/step1';
 static const goalStep2   = '/goal/step2';
static const goalAnalyze = '/goal/analysis';
static const dashboard = '/dashboard';
static const taskComplete = '/tasks/:taskId/complete';

// ----- route names -----
static const goalsList   = '/goals';
static const goalDetail  = '/goals/:id';
static const milestoneDetail = '/milestones/:id';


  static final pages = [
    GetPage(name: login,    page: () => const LoginScreen()),
   GetPage(
      name: home, 
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
      }),  ),  // GetPage(name: profile,  page: () => const ProfileScreen()),
    // GetPage(name: settings, page: () => const SettingsScreen()),
    
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
  GetPage(
  name: goalsList,
  page: () => const GoalsListScreen(),
  binding: BindingsBuilder(() {
    Get.put(GoalDisplayController());
  }),
),
GetPage(
  name: goalDetail,
  page: () => const GoalDetailScreen(),
),
GetPage(
  name: milestoneDetail,
  page: () => const MilestoneDetailScreen(),
),
  ];
}




// ----- GetPages -----


// ----- shared binding -----
class _GoalCreationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<GoalCreationController>()) {
      Get.put(GoalCreationController(), permanent: true);
    }
  }
}