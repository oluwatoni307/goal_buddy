// GENERATED for feature: dashboard
// TODO: implement
import 'package:flutter/material.dart';
import '../../../navBar.dart';
import '../dashboard_controller.dart';
import '../dashboard_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Dashboard> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = fetchDashboard(); // Called only once
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
            bottomNavigationBar: NavBar(currentIndex: 3),

      body: FutureBuilder<Dashboard>(
        future: _dashboardFuture,
        builder: (context, snap) {
          // Handle different connection states
          if (snap.connectionState == ConnectionState.none) {
            return const Center(
              child: Text('No connection established'),
            );
          }

          // Handle error state
          if (snap.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Error: ${snap.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _dashboardFuture = fetchDashboard();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Handle loading state (waiting or active without data)
          if (snap.connectionState == ConnectionState.waiting || 
              !snap.hasData || 
              snap.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final d = snap.data!;
          final dueToday = d.activeTasks.where((t) => t.today).toList();

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _dashboardFuture = fetchDashboard();
              });
              await _dashboardFuture;
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // AI Insights Card - with null check
                if (d.aiInsights.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.lightbulb_outline),
                              SizedBox(width: 8),
                              Text(
                                'AI Insights',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(d.aiInsights),
                        ],
                      ),
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Due Today Section
                const Text(
                  'Due Today',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                if (dueToday.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No tasks due today',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ...dueToday.map((t) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.check_circle_outline),
                          title: Text(
                            t.name.isNotEmpty ? t.name : 'Unnamed Task'
                          ),
                          subtitle: t.status.isNotEmpty 
                              ? Text(t.status) 
                              : null,
                        ),
                      )),
                
                const SizedBox(height: 16),
                
                // Goals Section
                const Text(
                  'Goals',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                if (d.goals.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No goals set yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ...d.goals.map((g) {
                    final completionRate = g.completionRate ?? 0.0;
                    final goalName = g.goalName?.isNotEmpty == true 
                        ? g.goalName! 
                        : 'Unnamed Goal';
                    
                    return Card(
                      child: ListTile(
                        leading: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            value: completionRate / 100,
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                        title: Text(goalName),
                        subtitle: Text(
                          '${completionRate.toStringAsFixed(0)}% complete',
                        ),
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }
}