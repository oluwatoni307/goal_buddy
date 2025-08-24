// MODERNIZED Dashboard Screen with Material 3 and latest Flutter syntax
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../navBar.dart';
import '../dashboard_controller.dart';
import 'dashboard_page2.dart';
import 'dashboard_page1.dart';

class DashboardScreen extends GetView<AnalyticsController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          toolbarHeight: 80, // Increased height for more spacing
          title: Padding(
            padding: const EdgeInsets.only(top: 16), // Added top padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Track your journey',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 16), // Added top padding to actions
              child: IconButton(
                onPressed: () => controller.refreshAll(),
                icon: Obx(() => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: controller.dailyLoading.value || controller.monthlyLoading.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.refresh_rounded,
                          color: colorScheme.onSurfaceVariant,
                        ),
                )),
                tooltip: 'Refresh data',
              ),
            ),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(52),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(2),
                  labelColor: colorScheme.onPrimary,
                  unselectedLabelColor: colorScheme.onSurfaceVariant,
                  labelStyle: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  splashFactory: NoSplash.splashFactory,
                  tabs: const [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.today, size: 18),
                          SizedBox(width: 8),
                          Text('Daily'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_month, size: 18),
                          SizedBox(width: 8),
                          Text('Monthly'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: NavBar(currentIndex: 1), // for dashboard
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.surfaceContainerLowest,
                colorScheme.surface,
              ],
              stops: const [0.0, 0.3],
            ),
          ),
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: const [
              _TabViewWrapper(child: DailyProgressScreen()),
              _TabViewWrapper(child: MonthlyProgressScreen()),
            ],
          ),
        ),
      ),
    );
  }
}

// Wrapper to add consistent padding and smooth transitions
class _TabViewWrapper extends StatelessWidget {
  final Widget child;
  
  const _TabViewWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}