class TimeSlotEntry {
  final String day;
  final String timeSlot;
  final String flexibility; // Default to 'undefined'
  final String milestoneId;
  final int priorityScore; // Default to 0
  final int allocatedMinutes;

  const TimeSlotEntry({
    required this.day,
    required this.timeSlot,
    required this.flexibility,
    required this.milestoneId,
    required this.priorityScore,
    required this.allocatedMinutes,
  });

  factory TimeSlotEntry.fromJson(Map<String, dynamic> json, String day) =>
      TimeSlotEntry(
        day: day,
        timeSlot: json['time_slot'] as String,
        flexibility: json['flexibility'] as String? ?? 'undefined',
        milestoneId: json['milestone_id'] as String,
        priorityScore: json['priority_score'] as int? ?? 0,
        allocatedMinutes: json['allocated_minutes'] as int,
      );

  Map<String, dynamic> toJson() => {
    'time_slot': timeSlot,
    'flexibility': flexibility,
    'milestone_id': milestoneId,
    'priority_score': priorityScore,
    'allocated_minutes': allocatedMinutes,
  };
}

class WeeklySchedule {
  final List<TimeSlotEntry> monday;
  final List<TimeSlotEntry> tuesday;
  final List<TimeSlotEntry> wednesday;
  final List<TimeSlotEntry> thursday;
  final List<TimeSlotEntry> friday;
  final List<TimeSlotEntry> saturday;
  final List<TimeSlotEntry> sunday;

  const WeeklySchedule({
    this.monday = const [],
    this.tuesday = const [],
    this.wednesday = const [],
    this.thursday = const [],
    this.friday = const [],
    this.saturday = const [],
    this.sunday = const [],
  });

  factory WeeklySchedule.fromJson(Map<String, dynamic> json) => WeeklySchedule(
    monday:
        (json['monday'] as List<dynamic>?)
            ?.map(
              (e) =>
                  TimeSlotEntry.fromJson(e as Map<String, dynamic>, 'Monday'),
            )
            .toList() ??
        [],
    tuesday:
        (json['tuesday'] as List<dynamic>?)
            ?.map(
              (e) =>
                  TimeSlotEntry.fromJson(e as Map<String, dynamic>, 'Tuesday'),
            )
            .toList() ??
        [],
    wednesday:
        (json['wednesday'] as List<dynamic>?)
            ?.map(
              (e) => TimeSlotEntry.fromJson(
                e as Map<String, dynamic>,
                'Wednesday',
              ),
            )
            .toList() ??
        [],
    thursday:
        (json['thursday'] as List<dynamic>?)
            ?.map(
              (e) =>
                  TimeSlotEntry.fromJson(e as Map<String, dynamic>, 'Thursday'),
            )
            .toList() ??
        [],
    friday:
        (json['friday'] as List<dynamic>?)
            ?.map(
              (e) =>
                  TimeSlotEntry.fromJson(e as Map<String, dynamic>, 'Friday'),
            )
            .toList() ??
        [],
    saturday:
        (json['saturday'] as List<dynamic>?)
            ?.map(
              (e) =>
                  TimeSlotEntry.fromJson(e as Map<String, dynamic>, 'Saturday'),
            )
            .toList() ??
        [],
    sunday:
        (json['sunday'] as List<dynamic>?)
            ?.map(
              (e) =>
                  TimeSlotEntry.fromJson(e as Map<String, dynamic>, 'Sunday'),
            )
            .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'monday': monday.map((e) => e.toJson()).toList(),
    'tuesday': tuesday.map((e) => e.toJson()).toList(),
    'wednesday': wednesday.map((e) => e.toJson()).toList(),
    'thursday': thursday.map((e) => e.toJson()).toList(),
    'friday': friday.map((e) => e.toJson()).toList(),
    'saturday': saturday.map((e) => e.toJson()).toList(),
    'sunday': sunday.map((e) => e.toJson()).toList(),
  };
}

class ScheduleData {
  final String id;
  final WeeklySchedule scheduleData;
  final String createdAt;
  final String updatedAt;
  final String userId;

  const ScheduleData({
    required this.id,
    required this.scheduleData,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory ScheduleData.fromJson(Map<String, dynamic> json) => ScheduleData(
    id: json['id'] as String,
    scheduleData: WeeklySchedule.fromJson(
      json['schedule_data'] as Map<String, dynamic>,
    ),
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
    userId: json['user_id'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'schedule_data': scheduleData.toJson(),
    'created_at': createdAt,
    'updated_at': updatedAt,
    'user_id': userId,
  };
}
