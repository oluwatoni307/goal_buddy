// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_define_model.freezed.dart';
part 'goal_define_model.g.dart';

// ---------- Input ----------
@freezed
abstract class GoalInputDto with _$GoalInputDto {
  const factory GoalInputDto({
    required String statement,
    required DateTime date,
    required int importance,
    required String context,
  }) = _GoalInputDto;

  factory GoalInputDto.fromJson(Map<String, dynamic> json) =>
      _$GoalInputDtoFromJson(json);
}

// ---------- Output ----------
@freezed
abstract class GoalOutputDto with _$GoalOutputDto {
  const factory GoalOutputDto({
    // Make goalId optional since API doesn't return it
    String? goalId,

    // Map snake_case API fields to camelCase Dart fields
    @JsonKey(name: 'goal_type') required String goalType,
    required int specific,
    required String complexity,
    required String motivation,
    @JsonKey(name: 'skill_level') required String skillLevel,
    required String dependencies,
    required String measurability,
    required String decomposability,
    required String urgency,
    required String autonomy,
    required String readiness,
    @JsonKey(name: 'identity_alignment') required String identityAlignment,
    @JsonKey(name: 'goal_classification') required String goalClassification,
    @JsonKey(name: 'complexity_rating') required double complexityRating,
    @JsonKey(name: 'success_probability') required String successProbability,
    @JsonKey(name: 'recommended_approach') required String recommendedApproach,
  }) = _GoalOutputDto;

  factory GoalOutputDto.fromJson(Map<String, dynamic> json) =>
      _$GoalOutputDtoFromJson(json);
}

// ---------- Saved record ----------
@freezed
abstract class Goal with _$Goal {
  const factory Goal({
    required String id,
    required String userId,
    required DateTime date,
    required String goalType,
    required int specific,
    required String complexity,
    required String motivation,
    required String skillLevel,
    required String dependencies,
    required String measurability,
    required String decomposability,
    required String urgency,
    required String autonomy,
    required String readiness,
    required String identityAlignment,
    required String goalClassification,
    required double complexityRating,
    required String successProbability,
    required String recommendedApproach,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}
