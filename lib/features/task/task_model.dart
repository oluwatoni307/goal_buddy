// GENERATED for feature: task
// TODO: implement
class TaskCompletionDto {
  final String taskId;
  final String goalName;
  final String milestoneName;
  final String taskTitle;
  final String ritual;
  String userNotes;
  final bool isCompleted;

  TaskCompletionDto({
    required this.taskId,
    required this.goalName,
    required this.milestoneName,
    required this.taskTitle,
    required this.ritual,
    this.userNotes = '',
    this.isCompleted = false,
  });

  factory TaskCompletionDto.fromJson(Map<String, dynamic> json) =>
      TaskCompletionDto(
        taskId: json['task_id'],
        goalName: json['goal_name'],
        milestoneName: json['milestone_name'],
        taskTitle: json['task_title'],
        ritual: json['ritual'],
        userNotes: json['user_notes'] ?? '',
        isCompleted: json['status'] == 'completed',
      );

  Map<String, dynamic> toJson() => {
        'task_id': taskId,
        'status': isCompleted ? 'completed' : 'pending',
        'user_notes': userNotes,
      };
}