class Dashboard {
  final List<Task> activeTasks;
  final List<Goal> goals;
  final Map<String, dynamic> weeklySummary;
  final Map<String, dynamic> summary;
  final String aiInsights;

  Dashboard.fromJson(Map<String, dynamic> json)
    : activeTasks = ((json['active_tasks'] as List?) ?? [])
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
      goals = ((json['goals'] as List?) ?? [])
          .map((e) => Goal.fromJson(e as Map<String, dynamic>))
          .toList(),
      weeklySummary = json['weekly_summary'] as Map<String, dynamic>? ?? {},
      summary = json['summary'] as Map<String, dynamic>? ?? {},
      aiInsights = json['ai_insights'] as String? ?? '';
}

class Task {
  final String id, name, status;
  final String? day;
  final bool today;
  
  Task.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String? ?? '',
      name = json['name'] as String? ?? '',
      status = json['status'] as String? ?? '',
      day = json['day'] as String?,
      today = json['today'] as bool? ?? false;
}

class Goal {
  final String? goalName;
  final double? completionRate;
  final List<Milestone> milestones;
  
  Goal.fromJson(Map<String, dynamic> json)
    : goalName = json['goal_name'] as String?,
      completionRate = (json['completion_rate'] as num?)?.toDouble(),
      milestones = ((json['milestones'] as List?) ?? [])
          .map((e) => Milestone.fromJson(e as Map<String, dynamic>))
          .toList();
}

class Milestone {
  final String objective;
  final double completionRate;
  
  Milestone.fromJson(Map<String, dynamic> json)
    : objective = json['objective'] as String? ?? '',
      completionRate = ((json['completion_rate'] as num?) ?? 0).toDouble();
}

