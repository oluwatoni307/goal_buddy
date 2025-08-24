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
  final String id;
  final String name;
  final int minutes;
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
        minutes: json['minutes'] as int,
        isCompleted: json['isCompleted'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'minutes': minutes,
        'isCompleted': isCompleted,
      };
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