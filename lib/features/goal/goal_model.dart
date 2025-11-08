// UPDATED Goal Model with Reference-Based Approach
// GENERATED for feature: goal
// Data deduplication implemented
// FIXED: Corrected parsing issues for milestone and task data
// UPDATED: Added proper allocated_minutes conversion

class Goal {
  final String id;
  final String name;
  final String description;
  final double completionRate; // 0.0 - 1.0 from backend
  final bool isCompleted;

  Goal({
    required this.id,
    required this.name,
    required this.description,
    required this.completionRate,
    required this.isCompleted,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json['id'].toString(),
    name: json['goal_name'] ?? json['description'] ?? 'Untitled Goal',
    description: json['goal_description'] ?? json['description'] ?? '',
    completionRate: (json['completion_rate'] ?? 0.0).toDouble(),
    isCompleted: json['status']?.toString().toLowerCase() == 'completed',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'goal_id': id,
    'name': name,
    'goal_name': name,
    'description': description,
    'goal_description': description,
    'completion_rate': completionRate,
    'is_completed': isCompleted,
  };
}

// ---------- Timeslot Allocation ----------

class TimeslotAllocation {
  final String day;
  final String timeslot;
  final int allocatedMinutes;

  TimeslotAllocation({
    required this.day,
    required this.timeslot,
    required this.allocatedMinutes,
  });

  factory TimeslotAllocation.fromJson(Map<String, dynamic> json) {
    int minutes = 0;

    // Handle allocated_minutes conversion
    if (json['allocated_minutes'] != null) {
      if (json['allocated_minutes'] is int) {
        minutes = json['allocated_minutes'] as int;
      } else if (json['allocated_minutes'] is String) {
        minutes = _parseAllocatedMinutes(json['allocated_minutes'] as String);
      }
    }

    return TimeslotAllocation(
      day: json['day'] ?? '',
      timeslot: json['timeslot'] ?? '',
      allocatedMinutes: minutes,
    );
  }

  static int _parseAllocatedMinutes(String str) {
    try {
      // Use regex to extract time range pattern (HH:MM-HH:MM)
      final timeRangeRegex = RegExp(
        r'(\d{1,2}):(\d{2})\s*-\s*(\d{1,2}):(\d{2})',
      );
      final match = timeRangeRegex.firstMatch(str);

      if (match != null) {
        // Extract hours and minutes from the regex groups
        final startHour = int.parse(match.group(1)!);
        final startMin = int.parse(match.group(2)!);
        final endHour = int.parse(match.group(3)!);
        final endMin = int.parse(match.group(4)!);

        // Calculate total minutes
        final startTotalMin = startHour * 60 + startMin;
        final endTotalMin = endHour * 60 + endMin;

        return endTotalMin - startTotalMin;
      }

      // If no time range found, try parsing as integer
      return int.tryParse(str.trim()) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Map<String, dynamic> toJson() => {
    'day': day,
    'timeslot': timeslot,
    'allocated_minutes': allocatedMinutes,
  };
}

// ---------- Milestone ----------

enum StatusState { pending, active, completed }

class Milestone {
  final String id;
  final String objective;
  final String successCriteria;
  final DateTime targetDate;
  final String enables;
  final StatusState status;
  final List<TimeslotAllocation>? assignedTimeslot;
  final int? rank;
  final double completionRate;

  Milestone({
    required this.id,
    required this.objective,
    required this.successCriteria,
    required this.targetDate,
    required this.enables,
    this.status = StatusState.pending,
    this.assignedTimeslot,
    this.rank,
    this.completionRate = 0.0,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['milestone_id']?.toString() ?? json['id']?.toString() ?? '',
      objective: json['objective'] ?? '',
      successCriteria: json['success_criteria'] ?? '',
      targetDate: json['target_date'] != null
          ? DateTime.tryParse(json['target_date']) ?? DateTime.now()
          : DateTime.now(),
      enables: json['enables'] ?? '',
      status: StatusState.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => StatusState.pending,
      ),
      assignedTimeslot: json['assigned_timeslot'] != null
          ? (json['assigned_timeslot'] as List)
                .map((e) => TimeslotAllocation.fromJson(e))
                .toList()
          : null,
      rank: json['rank'] as int?,
      completionRate: (json['completion_rate'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'milestone_id': id,
    'objective': objective,
    'success_criteria': successCriteria,
    'target_date': targetDate.toIso8601String(),
    'enables': enables,
    'status': status.name,
    'assigned_timeslot': assignedTimeslot?.map((e) => e.toJson()).toList(),
    'rank': rank,
    'completion_rate': completionRate,
  };
}

// ---------- Cleaned Milestone list wrapper ----------

class Milestones {
  final String goalId; // Reference only
  final List<Milestone> milestones; // The actual milestone data

  Milestones({required this.goalId, required this.milestones});

  factory Milestones.fromJson(Map<String, dynamic> json) => Milestones(
    goalId: json['goal_id'].toString(),
    milestones: (json['milestones'] as List)
        .map((e) => Milestone.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'goal_id': goalId,
    'milestones': milestones.map((e) => e.toJson()).toList(),
  };
}

// ---------- Task ----------

enum TaskType { encoding, consolidation, retrieval, application, assessment }

enum TaskStatus { pending, active, completed, missed }

class WeekDetails {
  final int total;
  final int missed;
  final int completed;
  final int weekNumber;

  WeekDetails({
    required this.total,
    required this.missed,
    required this.completed,
    required this.weekNumber,
  });

  factory WeekDetails.fromJson(Map<String, dynamic> json) {
    return WeekDetails(
      total: _parseInt(json['total']) ?? 0,
      missed: _parseInt(json['missed']) ?? 0,
      completed: _parseInt(json['completed']) ?? 0,
      weekNumber: _parseInt(json['week_number']) ?? 0,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'missed': missed,
    'completed': completed,
    'week_number': weekNumber,
  };
}

class Task {
  final String id;
  final String userId;
  final String milestoneId;
  final String name;
  final String description;
  final int? rank;
  final String? day;
  final int? allocatedMinutes;
  final TaskStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final WeekDetails? weekDetails;
  final dynamic completion; // Can be null or some completion data

  Task({
    required this.id,
    required this.userId,
    required this.milestoneId,
    required this.name,
    required this.description,
    this.rank,
    this.day,
    this.allocatedMinutes,
    this.status = TaskStatus.pending,
    this.createdAt,
    this.updatedAt,
    this.weekDetails,
    this.completion,
  });

  // Backward compatibility: alias 'name' as 'title'
  String get title => name;

  // Helper methods to extract structured data from description
  TaskType? get taskType {
    if (description.isEmpty) return null;
    try {
      final match = RegExp(r'\*\*Task Type:\*\* (\w+)').firstMatch(description);
      if (match != null && match.group(1) != null) {
        return TaskType.values.byName(match.group(1)!.toLowerCase());
      }
    } catch (e) {
      // Return null if parsing fails
    }
    return null;
  }

  String? get cognitiveLoad {
    if (description.isEmpty) return null;
    final match = RegExp(
      r'\*\*Cognitive Load:\*\* (\w+)',
    ).firstMatch(description);
    return match?.group(1);
  }

  String? get timeAllocated {
    if (description.isEmpty) return null;
    final match = RegExp(
      r'\*\*Time Allocated:\*\* (.+)',
    ).firstMatch(description);
    return match?.group(1);
  }

  String? get objective {
    if (description.isEmpty) return null;
    final match = RegExp(
      r'\*\*Objective:\*\* (.+?)(?:\n|$)',
    ).firstMatch(description);
    return match?.group(1);
  }

  List<String> get specificActions {
    if (description.isEmpty) return [];
    final actions = <String>[];
    try {
      final actionsSection = RegExp(
        r'\*\*Specific Actions:\*\*\n((?:- .+\n?)+)',
        multiLine: true,
      ).firstMatch(description);

      if (actionsSection != null) {
        final actionText = actionsSection.group(1) ?? '';
        final actionLines = actionText
            .split('\n')
            .where((line) => line.trim().startsWith('- '))
            .map((line) => line.trim().substring(2))
            .toList();
        actions.addAll(actionLines);
      }
    } catch (e) {
      // Return empty list if parsing fails
    }
    return actions;
  }

  String? get successMetric {
    if (description.isEmpty) return null;
    final match = RegExp(
      r'\*\*Success Metric:\*\* (.+?)(?:\n|$)',
    ).firstMatch(description);
    return match?.group(1);
  }

  // Helper method to convert time range string to minutes
  static int _parseAllocatedMinutes(String str) {
    try {
      // Use regex to extract time range pattern (HH:MM-HH:MM)
      final timeRangeRegex = RegExp(
        r'(\d{1,2}):(\d{2})\s*-\s*(\d{1,2}):(\d{2})',
      );
      final match = timeRangeRegex.firstMatch(str);

      if (match != null) {
        // Extract hours and minutes from the regex groups
        final startHour = int.parse(match.group(1)!);
        final startMin = int.parse(match.group(2)!);
        final endHour = int.parse(match.group(3)!);
        final endMin = int.parse(match.group(4)!);

        // Calculate total minutes
        final startTotalMin = startHour * 60 + startMin;
        final endTotalMin = endHour * 60 + endMin;

        return endTotalMin - startTotalMin;
      }

      // If no time range found, try parsing as integer
      return int.tryParse(str.trim()) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    try {
      // Parse each field with defensive null handling
      final id = json['id']?.toString() ?? '';
      final userId = json['user_id']?.toString() ?? '';
      final milestoneId = json['milestone_id']?.toString() ?? '';
      final name = json['name']?.toString() ?? 'Untitled Task';
      final description = json['description']?.toString() ?? '';
      final rank = json['rank'] as int?;
      final day = json['day'] as String?;

      // Handle allocated_minutes conversion
      int? allocatedMinutes;
      if (json['allocated_minutes'] != null) {
        if (json['allocated_minutes'] is int) {
          allocatedMinutes = json['allocated_minutes'] as int;
        } else if (json['allocated_minutes'] is String) {
          allocatedMinutes = _parseAllocatedMinutes(
            json['allocated_minutes'] as String,
          );
        }
      }

      final status = json['status'] != null
          ? _parseTaskStatus(json['status'].toString())
          : TaskStatus.pending;

      final createdAt = _parseDateTime(json['created_at']);
      final updatedAt = _parseDateTime(json['updated_at']);

      final weekDetails =
          json['week_details'] != null && json['week_details'] is Map
          ? WeekDetails.fromJson(json['week_details'] as Map<String, dynamic>)
          : null;

      final completion = json['completion'];

      return Task(
        id: id,
        userId: userId,
        milestoneId: milestoneId,
        name: name,
        description: description,
        rank: rank,
        day: day,
        allocatedMinutes: allocatedMinutes,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
        weekDetails: weekDetails,
        completion: completion,
      );
    } catch (e, stackTrace) {
      // Log the error with the problematic JSON for debugging
      print('ERROR parsing Task from JSON: $e');
      print('Problematic JSON: $json');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Helper method to parse task status safely
  static TaskStatus _parseTaskStatus(String statusStr) {
    final normalizedStatus = statusStr.toLowerCase().trim();
    return TaskStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == normalizedStatus,
      orElse: () => TaskStatus.pending,
    );
  }

  // Helper method to parse various datetime formats
  static DateTime? _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return null;

    try {
      final dateStr = dateValue.toString();
      // Handle format: "2025-10-13 23:58:29.627398+00"
      // Convert to ISO 8601 format by replacing space with 'T'
      final isoFormat = dateStr.replaceFirst(' ', 'T');
      return DateTime.parse(isoFormat);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'milestone_id': milestoneId,
    'name': name,
    'description': description,
    'rank': rank,
    'day': day,
    'allocated_minutes': allocatedMinutes,
    'status': status.name,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'week_details': weekDetails?.toJson(),
    'completion': completion,
  };
}

// ---------- Task list wrapper ----------

class Tasks {
  final String milestoneId; // Reference only
  final List<Task> tasks; // The actual task data

  Tasks({required this.milestoneId, required this.tasks});

  factory Tasks.fromJson(Map<String, dynamic> json) => Tasks(
    milestoneId: json['milestone_id'].toString(),
    tasks: (json['tasks'] as List).map((e) => Task.fromJson(e)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'milestone_id': milestoneId,
    'tasks': tasks.map((e) => e.toJson()).toList(),
  };
}
