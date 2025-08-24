// GENERATED for feature: dashboard
// TODO: implement
class DailyAnalytics {
  final double habitCompletionRate;          // 0-1
  final double goalCompletionRate;           // 0-1
  final Map<String, double> last7DaysHabit;  // "Mon": 0.8, …
  final List<GoalBreakdown> goalsBreakdown;  // slim list

  DailyAnalytics({
    required this.habitCompletionRate,
    required this.goalCompletionRate,
    required this.last7DaysHabit,
    required this.goalsBreakdown,
  });

  factory DailyAnalytics.fromJson(Map<String, dynamic> json) => DailyAnalytics(
        habitCompletionRate: (json['habit_completion_rate'] as num).toDouble(),
        goalCompletionRate: (json['goal_completion_rate'] as num).toDouble(),
        last7DaysHabit: Map<String, double>.from(
            (json['last_7_days_habit'] as Map).map((k, v) => MapEntry(k, (v as num).toDouble()))),
        goalsBreakdown: (json['goals_breakdown'] as List)
            .map((e) => GoalBreakdown.fromJson(e))
            .toList(),
      );
}

class GoalBreakdown {
  final String name;
  final double completionRate;

  GoalBreakdown({required this.name, required this.completionRate});

  factory GoalBreakdown.fromJson(Map<String, dynamic> json) => GoalBreakdown(
        name: json['name'],
        completionRate: (json['completion_rate'] as num).toDouble(),
      );
}

class MonthlyAnalytics {
  final int habitsAchieved;
  final int goalsAchieved;
  final int daysActive;
  final List<double> weeklyHabitCompletion; // 4 items
  final List<int> weeklyGoalsAchieved;      // 4 items
  final String insight;

  MonthlyAnalytics({
    required this.habitsAchieved,
    required this.goalsAchieved,
    required this.daysActive,
    required this.weeklyHabitCompletion,
    required this.weeklyGoalsAchieved,
    required this.insight,
  });

  factory MonthlyAnalytics.fromJson(Map<String, dynamic> json) => MonthlyAnalytics(
        habitsAchieved: json['habits_achieved'] as int,
        goalsAchieved: json['goals_achieved'] as int,
        daysActive: json['days_active'] as int,
        weeklyHabitCompletion: (json['weekly_habit_completion'] as List)
            .map((e) => (e as num).toDouble())
            .toList(),
        weeklyGoalsAchieved:
            (json['weekly_goals_achieved'] as List).map((e) => e as int).toList(),
        insight: json['insight'],
      );
}