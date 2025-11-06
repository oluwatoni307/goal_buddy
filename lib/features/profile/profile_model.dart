// features/profile/profile_model.dart

/// Profile statistics from backend
class ProfileStats {
  final int activeGoals;
  final int completedGoals;

  ProfileStats({required this.activeGoals, required this.completedGoals});

  /// Calculate badge type based on completed goals
  BadgeType get badgeType {
    if (completedGoals == 0) return BadgeType.beginner;
    if (completedGoals <= 5) return BadgeType.achiever;
    if (completedGoals <= 10) return BadgeType.champion;
    return BadgeType.legend;
  }

  /// Parse from API response
  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      activeGoals: json['active_goals'] as int,
      completedGoals: json['completed_goals'] as int,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'activeGoals': activeGoals, 'completedGoals': completedGoals};
  }
}

/// Badge types based on achievements
enum BadgeType {
  beginner,
  achiever,
  champion,
  legend;

  /// Display name for badge
  String get displayName {
    switch (this) {
      case BadgeType.beginner:
        return 'Beginner';
      case BadgeType.achiever:
        return 'Achiever';
      case BadgeType.champion:
        return 'Champion';
      case BadgeType.legend:
        return 'Legend';
    }
  }

  /// Icon emoji for badge
  String get icon {
    switch (this) {
      case BadgeType.beginner:
        return '🌱';
      case BadgeType.achiever:
        return '⭐';
      case BadgeType.champion:
        return '🏆';
      case BadgeType.legend:
        return '👑';
    }
  }

  /// Color for badge
  int get color {
    switch (this) {
      case BadgeType.beginner:
        return 0xFF9E9E9E; // Grey
      case BadgeType.achiever:
        return 0xFF2196F3; // Blue
      case BadgeType.champion:
        return 0xFF9C27B0; // Purple
      case BadgeType.legend:
        return 0xFFFFD700; // Gold
    }
  }
}
