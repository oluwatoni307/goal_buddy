import 'package:flutter/material.dart';

/// Root DTO returned by GET /api/home
class HomeDataModel {
  final List<HabitModel> todayHabits;
  final ProgressModel progress;
  final InsightModel insight;

  const HomeDataModel({
    required this.todayHabits,
    required this.progress,
    required this.insight,
  });

  /// JSON ⇄ Dart
  factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
    todayHabits: (json['todayHabits'] as List)
        .map((e) => HabitModel.fromJson(e))
        .toList(),
    progress: ProgressModel.fromJson(json['progress']),
    insight: InsightModel.fromJson(json['insight']),
  );

  Map<String, dynamic> toJson() => {
    'todayHabits': todayHabits.map((e) => e.toJson()).toList(),
    'progress': progress.toJson(),
    'insight': insight.toJson(),
  };
}

/// --- Sub-models ---

class HabitModel {
  static const String defaultTimeRange = "09:00-09:30";

  final String id;
  final String name;
  final String minutes; // Stores time range like "09:00-09:45"
  final bool isCompleted;

  const HabitModel({
    required this.id,
    required this.name,
    required this.minutes,
    this.isCompleted = false,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) => HabitModel(
    id: json['id'] as String,
    name: json['name'] as String,
    minutes: (json['minutes'] as String?) ?? defaultTimeRange,
    isCompleted: json['isCompleted'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'minutes': minutes,
    'isCompleted': isCompleted,
  };

  /// Get the start time as TimeOfDay
  TimeOfDay get startTime {
    final parts = minutes.split('-');
    if (parts.isEmpty) return TimeOfDay.now();

    final timeStr = parts[0].trim();
    final timeParts = timeStr.split(':');

    return TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
  }

  /// Get the end time as TimeOfDay
  TimeOfDay get endTime {
    final parts = minutes.split('-');
    if (parts.length < 2) return TimeOfDay.now();

    final timeStr = parts[1].trim();
    final timeParts = timeStr.split(':');

    return TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
  }

  /// Get start time as DateTime (for comparisons with current time)
  DateTime get startDateTime {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    );
  }

  /// Get end time as DateTime (for comparisons with current time)
  DateTime get endDateTime {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
  }

  /// Get duration in minutes
  int get durationInMinutes {
    return endDateTime.difference(startDateTime).inMinutes;
  }

  /// Check if the habit is currently active (current time is between start and end)
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDateTime) && now.isBefore(endDateTime);
  }

  /// Check if the habit is upcoming (hasn't started yet)
  bool get isUpcoming {
    return DateTime.now().isBefore(startDateTime);
  }

  /// Check if the habit is overdue (past end time and not completed)
  bool get isOverdue {
    return DateTime.now().isAfter(endDateTime) && !isCompleted;
  }

  /// Get formatted time range for display (e.g., "9:00 AM - 9:45 AM")
  /// This uses 24-hour format. Use formatTimeRange(context) for localized format.
  String get formattedTimeRange {
    return '${_formatTime(startTime)} - ${_formatTime(endTime)}';
  }

  /// Format TimeOfDay with context for localized format (requires BuildContext)
  String formatTimeRange(BuildContext context) {
    return '${startTime.format(context)} - ${endTime.format(context)}';
  }

  /// Helper to format TimeOfDay without context
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Get time remaining until start (for upcoming habits)
  Duration get timeUntilStart {
    return startDateTime.difference(DateTime.now());
  }

  /// Get time remaining until end (for active habits)
  Duration get timeUntilEnd {
    return endDateTime.difference(DateTime.now());
  }
}

class ProgressModel {
  final int dailyDone;
  final int dailyTotal;
  final int weeklyDone;
  final int weeklyTotal;

  const ProgressModel({
    required this.dailyDone,
    required this.dailyTotal,
    required this.weeklyDone,
    required this.weeklyTotal,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) => ProgressModel(
    dailyDone: json['dailyDone'] as int,
    dailyTotal: json['dailyTotal'] as int,
    weeklyDone: json['weeklyDone'] as int,
    weeklyTotal: json['weeklyTotal'] as int,
  );

  Map<String, dynamic> toJson() => {
    'dailyDone': dailyDone,
    'dailyTotal': dailyTotal,
    'weeklyDone': weeklyDone,
    'weeklyTotal': weeklyTotal,
  };
}

class InsightModel {
  final String text;

  const InsightModel(this.text);

  factory InsightModel.fromJson(Map<String, dynamic> json) =>
      InsightModel(json['text'] as String);

  Map<String, dynamic> toJson() => {'text': text};
}
