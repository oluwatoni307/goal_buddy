class Dashboard {
  final List<Task> activeTasks;
  final List<Goal> goals;
  final String aiInsights;

  Dashboard.fromJson(Map<String, dynamic> json)
    : activeTasks = (json['active_tasks'] as List)
          .map((e) => Task.fromJson(e))
          .toList(),
      goals = (json['goals'] as List).map((e) => Goal.fromJson(e)).toList(),
      aiInsights = json['ai_insights'] as String;
}

class Task {
  final String id, name, status;
  final String? day;
  final bool today;
  Task.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      status = json['status'],
      day = json['day'],
      today = json['today'] ?? false;
}

class Goal {
  final String? goalName;
  final double? completionRate;
  final List<Milestone> milestones;
  Goal.fromJson(Map<String, dynamic> json)
    : goalName = json['goal_name'],
      completionRate = json['completion_rate']?.toDouble(),
      milestones = (json['milestones'] as List? ?? [])
          .map((e) => Milestone.fromJson(e))
          .toList();
}

class Milestone {
  final String objective;
  final double completionRate;
  Milestone.fromJson(Map<String, dynamic> json)
    : objective = json['objective'],
      completionRate = (json['completion_rate'] ?? 0).toDouble();
}
