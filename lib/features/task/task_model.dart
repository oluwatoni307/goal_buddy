class TaskCompletionDto {
  final String id;
  final String name;
  final String description;
  String completionDescription;
  final String status;

  // Parsed fields from description
  final String? objective;
  final String? taskType;
  final String? cognitiveLoad;
  final String? timeAllocated;
  final List<String> specificActions;
  final String? successMetric;

  TaskCompletionDto({
    required this.id,
    required this.name,
    required this.description,
    this.completionDescription = '',
    required this.status,
    this.objective,
    this.taskType,
    this.cognitiveLoad,
    this.timeAllocated,
    this.specificActions = const [],
    this.successMetric,
  });

  factory TaskCompletionDto.fromJson(Map<String, dynamic> json) {
    final description = json['description'] as String;
    final parsed = _parseDescription(description);

    return TaskCompletionDto(
      id: json['id'],
      name: json['name'],
      description: description,
      completionDescription: json['completion_description'] ?? '',
      status: json['status'],
      objective: parsed['objective'],
      taskType: parsed['taskType'],
      cognitiveLoad: parsed['cognitiveLoad'],
      timeAllocated: parsed['timeAllocated'],
      specificActions: parsed['specificActions'] ?? [],
      successMetric: parsed['successMetric'],
    );
  }

  static Map<String, dynamic> _parseDescription(String description) {
    final Map<String, dynamic> result = {};

    // Extract Objective
    final objectiveMatch = RegExp(
      r'\*\*Objective:\*\*\s*([^\*]+)',
    ).firstMatch(description);
    if (objectiveMatch != null) {
      result['objective'] = objectiveMatch.group(1)?.trim();
    }

    // Extract Task Type
    final taskTypeMatch = RegExp(
      r'\*\*Task Type:\*\*\s*(\w+)',
    ).firstMatch(description);
    if (taskTypeMatch != null) {
      result['taskType'] = taskTypeMatch.group(1)?.trim();
    }

    // Extract Cognitive Load
    final cognitiveLoadMatch = RegExp(
      r'\*\*Cognitive Load:\*\*\s*(\w+)',
    ).firstMatch(description);
    if (cognitiveLoadMatch != null) {
      result['cognitiveLoad'] = cognitiveLoadMatch.group(1)?.trim();
    }

    // Extract Time Allocated
    final timeMatch = RegExp(
      r'\*\*Time Allocated:\*\*\s*([^\*]+)',
    ).firstMatch(description);
    if (timeMatch != null) {
      result['timeAllocated'] = timeMatch.group(1)?.trim();
    }

    // Extract Specific Actions (bullet points)
    final actionsSection = RegExp(
      r'\*\*Specific Actions:\*\*\s*((?:- [^\n]+\n?)+)',
    ).firstMatch(description);
    if (actionsSection != null) {
      final actionsText = actionsSection.group(1) ?? '';
      result['specificActions'] = actionsText
          .split('\n')
          .where((line) => line.trim().startsWith('-'))
          .map((line) => line.replaceFirst(RegExp(r'^\s*-\s*'), '').trim())
          .where((line) => line.isNotEmpty)
          .toList();
    }

    // Extract Success Metric
    final successMatch = RegExp(
      r'\*\*Success Metric:\*\*\s*([^\*\n]+)',
    ).firstMatch(description);
    if (successMatch != null) {
      result['successMetric'] = successMatch.group(1)?.trim();
    }

    return result;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'completion_description': completionDescription,
  };

  bool get isCompleted => status == 'completed';
}
