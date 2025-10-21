import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_model.dart';

class OnboardingController extends GetxController {
  final RxInt currentPage = 0.obs;
  late PageController pageController;
  
  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    pageController.addListener(() {
      final page = pageController.page?.round() ?? 0;
      if (currentPage.value != page) {
        currentPage.value = page;
      }
    });
  }
  
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
 
  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      imageAsset: 'lib/images/1.png',
      title: 'Smart Goal Setting',
      body: 'Our AI transforms your big ambitions into clear, achievable milestones and actionable tasks.',
    ),
    OnboardingPageModel(
      imageAsset: 'lib/images/2.png',
      title: 'Effortless Daily Tracking',
      body: 'Easily check off habits, log activities, and watch your real-time progress unfold with intuitive dashboards.',
    ),
    OnboardingPageModel(
      imageAsset: 'lib/images/3.png',
      title: 'Personalized AI Insights',
      body: 'Receive intelligent feedback and behavioral nudges designed to keep you motivated and optimize your path to success.',
    ),
    OnboardingPageModel(
      imageAsset: 'lib/images/4.png',
      title: 'Celebrate Your Wins',
      body: 'Review comprehensive reports, visualize your growth, and celebrate every milestone on your journey to success.',
    ),
  ];

  void next() {
    if (currentPage.value < pages.length - 1) {
      pageController.animateToPage(
        currentPage.value + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }
  
  void skip() => _finish();

  Future<void> _finish() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingSeen', true);
      Get.offAllNamed('/login');
    } catch (e) {
      // Handle error gracefully
      Get.snackbar('Error', 'Something went wrong');
    }
  }
}