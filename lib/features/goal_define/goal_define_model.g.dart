// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_define_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GoalInputDto _$GoalInputDtoFromJson(Map<String, dynamic> json) =>
    _GoalInputDto(
      statement: json['statement'] as String,
      date: DateTime.parse(json['date'] as String),
      importance: (json['importance'] as num).toInt(),
      context: json['context'] as String,
    );

Map<String, dynamic> _$GoalInputDtoToJson(_GoalInputDto instance) =>
    <String, dynamic>{
      'statement': instance.statement,
      'date': instance.date.toIso8601String(),
      'importance': instance.importance,
      'context': instance.context,
    };

_GoalOutputDto _$GoalOutputDtoFromJson(Map<String, dynamic> json) =>
    _GoalOutputDto(
      goalId: json['goalId'] as String?,
      goalType: json['goal_type'] as String,
      specific: (json['specific'] as num).toInt(),
      complexity: json['complexity'] as String,
      motivation: json['motivation'] as String,
      skillLevel: json['skill_level'] as String,
      dependencies: json['dependencies'] as String,
      measurability: json['measurability'] as String,
      decomposability: json['decomposability'] as String,
      urgency: json['urgency'] as String,
      autonomy: json['autonomy'] as String,
      readiness: json['readiness'] as String,
      identityAlignment: json['identity_alignment'] as String,
      goalClassification: json['goal_classification'] as String,
      complexityRating: (json['complexity_rating'] as num).toDouble(),
      successProbability: json['success_probability'] as String,
      recommendedApproach: json['recommended_approach'] as String,
    );

Map<String, dynamic> _$GoalOutputDtoToJson(_GoalOutputDto instance) =>
    <String, dynamic>{
      'goalId': instance.goalId,
      'goal_type': instance.goalType,
      'specific': instance.specific,
      'complexity': instance.complexity,
      'motivation': instance.motivation,
      'skill_level': instance.skillLevel,
      'dependencies': instance.dependencies,
      'measurability': instance.measurability,
      'decomposability': instance.decomposability,
      'urgency': instance.urgency,
      'autonomy': instance.autonomy,
      'readiness': instance.readiness,
      'identity_alignment': instance.identityAlignment,
      'goal_classification': instance.goalClassification,
      'complexity_rating': instance.complexityRating,
      'success_probability': instance.successProbability,
      'recommended_approach': instance.recommendedApproach,
    };

_Goal _$GoalFromJson(Map<String, dynamic> json) => _Goal(
  id: json['id'] as String,
  userId: json['userId'] as String,
  date: DateTime.parse(json['date'] as String),
  goalType: json['goalType'] as String,
  specific: (json['specific'] as num).toInt(),
  complexity: json['complexity'] as String,
  motivation: json['motivation'] as String,
  skillLevel: json['skillLevel'] as String,
  dependencies: json['dependencies'] as String,
  measurability: json['measurability'] as String,
  decomposability: json['decomposability'] as String,
  urgency: json['urgency'] as String,
  autonomy: json['autonomy'] as String,
  readiness: json['readiness'] as String,
  identityAlignment: json['identityAlignment'] as String,
  goalClassification: json['goalClassification'] as String,
  complexityRating: (json['complexityRating'] as num).toDouble(),
  successProbability: json['successProbability'] as String,
  recommendedApproach: json['recommendedApproach'] as String,
);

Map<String, dynamic> _$GoalToJson(_Goal instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'date': instance.date.toIso8601String(),
  'goalType': instance.goalType,
  'specific': instance.specific,
  'complexity': instance.complexity,
  'motivation': instance.motivation,
  'skillLevel': instance.skillLevel,
  'dependencies': instance.dependencies,
  'measurability': instance.measurability,
  'decomposability': instance.decomposability,
  'urgency': instance.urgency,
  'autonomy': instance.autonomy,
  'readiness': instance.readiness,
  'identityAlignment': instance.identityAlignment,
  'goalClassification': instance.goalClassification,
  'complexityRating': instance.complexityRating,
  'successProbability': instance.successProbability,
  'recommendedApproach': instance.recommendedApproach,
};
