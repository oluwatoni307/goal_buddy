// GENERATED for feature: dashboard
// TODO: implement
import 'package:flutter/material.dart';

import '../dashboard_controller.dart';
import '../dashboard_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: FutureBuilder<Dashboard>(
        future: fetchDashboard(),
        builder: (_, snap) {
          if (!snap.hasData)
            return const Center(child: CircularProgressIndicator());
          final d = snap.data!;
          final dueToday = d.activeTasks.where((t) => t.today).toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(d.aiInsights),
              const Divider(),
              const Text(
                'Due today',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...dueToday.map((t) => ListTile(title: Text(t.name))),
              const Divider(),
              const Text(
                'Goals',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...d.goals.map(
                (g) => ListTile(
                  title: Text(g.goalName ?? 'Unnamed'),
                  subtitle: Text('${g.completionRate?.toStringAsFixed(0)}%'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
