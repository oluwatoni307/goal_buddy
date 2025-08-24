// GENERATED for feature: goal
// TODO: implement
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../navBar.dart';
import '../goal_model.dart';
import '../goal_controller.dart';

class GoalsListScreen extends GetView<GoalDisplayController> {
  const GoalsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Goals'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        bottomNavigationBar: NavBar(currentIndex: 2), // for home

        body: Obx(() {
          if (controller.goalsLoading.value && controller.activeGoals.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.goalsError.value.isNotEmpty) {
            return Center(
              child: Text(controller.goalsError.value,
                  style: const TextStyle(color: Colors.red)),
            );
          }
          return TabBarView(
            children: [
              _GoalTab(goals: controller.activeGoals),
              _GoalTab(goals: controller.completedGoals),
            ],
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed('/goal/step1'), // reuse creation flow
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

/* ---------- Re-usable tab content ---------- */
class _GoalTab extends GetView<GoalDisplayController> {
  final List<Goal> goals;
  const _GoalTab({required this.goals});

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return const Center(child: Text('No goals here yet'));
    }
    return RefreshIndicator(
      onRefresh: controller.refreshGoals,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: goals.length,
        itemBuilder: (_, i) {
          final g = goals[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(g.name),
              subtitle: LinearProgressIndicator(
                value: g.completionRate,
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
              trailing: Text('${(g.completionRate * 100).toStringAsFixed(0)}%'),
              onTap: () async {
                await controller.loadMilestones(g.id);
                Get.toNamed('/goals/${g.id}'); // route handled below
              },
            ),
          );
        },
      ),
    );
  }
}