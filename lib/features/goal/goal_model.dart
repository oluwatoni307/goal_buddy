// UPDATED Goal Model with Milestone ID field
// GENERATED for feature: goal
// TODO: implement

class Goal {
  final String id;
  final String name;
  final double completionRate;   // 0.0 - 1.0 from backend
  final bool isCompleted;

  Goal({
    required this.id,
    required this.name,
    required this.completionRate,
    required this.isCompleted,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
        id: json['goal_id'].toString(),
        name: json['goal_name'] ?? json['description'] ?? 'Untitled Goal',
        completionRate: _extractCompletionRate(json['goal_analysis']),
        isCompleted: json['status']?.toString().toLowerCase() == 'completed',
      );

  static double _extractCompletionRate(String? goalAnalysis) {
    if (goalAnalysis == null) return 0.0;
    
    // Extract success_probability from goal_analysis string
    final regex = RegExp(r"success_probability='(\w+)'");
    final match = regex.firstMatch(goalAnalysis);
    
    if (match != null) {
      switch (match.group(1)?.toLowerCase()) {
        case 'high': return 0.8;
        case 'medium': return 0.5;
        case 'low': return 0.2;
        default: return 0.0;
      }
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'completion_rate': completionRate,
        'is_completed': isCompleted,
      };
}


// ---------- Milestone ----------

enum StatusState { pending, active, completed }

class Milestone {
  final String id;  // Added ID field
  final String objective;
  final String successCriteria;
  final DateTime targetDate;
  final String enables;
  final StatusState status;
  final String? assignedTimeslot;

  Milestone({
    required this.id,  // Added ID parameter
    required this.objective,
    required this.successCriteria,
    required this.targetDate,
    required this.enables,
    this.status = StatusState.pending,
    this.assignedTimeslot,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
        id: json['milestone_id']?.toString() ?? json['id']?.toString() ?? '', // Added ID parsing
        objective: json['objective'],
        successCriteria: json['success_criteria'],
        targetDate: DateTime.parse(json['targetDate']),
        enables: json['enables'],
        status: StatusState.values.byName(json['status'] ?? 'pending'),
        assignedTimeslot: json['assigned_timeslot'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,  // Added ID to JSON
        'milestone_id': id,  // Also include milestone_id for API compatibility
        'objective': objective,
        'success_criteria': successCriteria,
        'targetDate': targetDate.toIso8601String(),
        'enables': enables,
        'status': status.name,
        'assigned_timeslot': assignedTimeslot,
      };
}

// ---------- Milestone list wrapper ----------
class Milestones {
  final String goalId;
  final String goalName;
  final String goalDescription;
  final String context;
  final List<Milestone> milestones;

  Milestones({
    required this.goalId,
    required this.goalName,
    required this.goalDescription,
    required this.context,
    required this.milestones,
  });

  factory Milestones.fromJson(Map<String, dynamic> json) => Milestones(
        goalId: json['goal_id'].toString(),
        goalName: json['goal_name'],
        goalDescription: json['goal_description'],
        context: json['context'],
        milestones: (json['milestones'] as List)
            .map((e) => Milestone.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'goal_id': goalId,
        'goal_name': goalName,
        'goal_description': goalDescription,
        'context': context,
        'milestones': milestones.map((e) => e.toJson()).toList(),
      };
}

// ---------- Task ----------
enum TaskType { encoding, consolidation, retrieval, application, assessment }
enum TaskStatus { pending, active, completed }

class Task {
  final String taskId;
  final TaskType taskType;
  final String title;
  final String objective;
  final List<String> specificActions;
  final String timeAllocated;
  final String cognitiveLoad;
  final String successMetric;
  final String description;
  final int rating;
  final TaskStatus status;

  Task({
    required this.taskId,
    required this.taskType,
    required this.title,
    required this.objective,
    required this.specificActions,
    required this.timeAllocated,
    required this.cognitiveLoad,
    required this.successMetric,
    required this.description,
    required this.rating,
    this.status = TaskStatus.pending,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        taskId: json['task_id'],
        taskType: TaskType.values.byName(json['task_type']),
        title: json['title'],
        objective: json['objective'],
        specificActions:
            List<String>.from(json['specific_actions'] as List),
        timeAllocated: json['time_allocated'],
        cognitiveLoad: json['cognitive_load'],
        successMetric: json['success_metric'],
        description: json['description'],
        rating: json['rating'] as int,
        status: TaskStatus.values.byName(json['status'] ?? 'pending'),
      );

  Map<String, dynamic> toJson() => {
        'task_id': taskId,
        'task_type': taskType.name,
        'title': title,
        'objective': objective,
        'specific_actions': specificActions,
        'time_allocated': timeAllocated,
        'cognitive_load': cognitiveLoad,
        'success_metric': successMetric,
        'description': description,
        'rating': rating,
        'status': status.name,
      };
}