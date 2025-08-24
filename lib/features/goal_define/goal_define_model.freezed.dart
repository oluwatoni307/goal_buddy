// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_define_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoalInputDto {

 String get statement; DateTime get date; int get importance; String get context;
/// Create a copy of GoalInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalInputDtoCopyWith<GoalInputDto> get copyWith => _$GoalInputDtoCopyWithImpl<GoalInputDto>(this as GoalInputDto, _$identity);

  /// Serializes this GoalInputDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalInputDto&&(identical(other.statement, statement) || other.statement == statement)&&(identical(other.date, date) || other.date == date)&&(identical(other.importance, importance) || other.importance == importance)&&(identical(other.context, context) || other.context == context));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statement,date,importance,context);

@override
String toString() {
  return 'GoalInputDto(statement: $statement, date: $date, importance: $importance, context: $context)';
}


}

/// @nodoc
abstract mixin class $GoalInputDtoCopyWith<$Res>  {
  factory $GoalInputDtoCopyWith(GoalInputDto value, $Res Function(GoalInputDto) _then) = _$GoalInputDtoCopyWithImpl;
@useResult
$Res call({
 String statement, DateTime date, int importance, String context
});




}
/// @nodoc
class _$GoalInputDtoCopyWithImpl<$Res>
    implements $GoalInputDtoCopyWith<$Res> {
  _$GoalInputDtoCopyWithImpl(this._self, this._then);

  final GoalInputDto _self;
  final $Res Function(GoalInputDto) _then;

/// Create a copy of GoalInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statement = null,Object? date = null,Object? importance = null,Object? context = null,}) {
  return _then(_self.copyWith(
statement: null == statement ? _self.statement : statement // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,importance: null == importance ? _self.importance : importance // ignore: cast_nullable_to_non_nullable
as int,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalInputDto].
extension GoalInputDtoPatterns on GoalInputDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalInputDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalInputDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalInputDto value)  $default,){
final _that = this;
switch (_that) {
case _GoalInputDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalInputDto value)?  $default,){
final _that = this;
switch (_that) {
case _GoalInputDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String statement,  DateTime date,  int importance,  String context)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalInputDto() when $default != null:
return $default(_that.statement,_that.date,_that.importance,_that.context);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String statement,  DateTime date,  int importance,  String context)  $default,) {final _that = this;
switch (_that) {
case _GoalInputDto():
return $default(_that.statement,_that.date,_that.importance,_that.context);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String statement,  DateTime date,  int importance,  String context)?  $default,) {final _that = this;
switch (_that) {
case _GoalInputDto() when $default != null:
return $default(_that.statement,_that.date,_that.importance,_that.context);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GoalInputDto implements GoalInputDto {
  const _GoalInputDto({required this.statement, required this.date, required this.importance, required this.context});
  factory _GoalInputDto.fromJson(Map<String, dynamic> json) => _$GoalInputDtoFromJson(json);

@override final  String statement;
@override final  DateTime date;
@override final  int importance;
@override final  String context;

/// Create a copy of GoalInputDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalInputDtoCopyWith<_GoalInputDto> get copyWith => __$GoalInputDtoCopyWithImpl<_GoalInputDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoalInputDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalInputDto&&(identical(other.statement, statement) || other.statement == statement)&&(identical(other.date, date) || other.date == date)&&(identical(other.importance, importance) || other.importance == importance)&&(identical(other.context, context) || other.context == context));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statement,date,importance,context);

@override
String toString() {
  return 'GoalInputDto(statement: $statement, date: $date, importance: $importance, context: $context)';
}


}

/// @nodoc
abstract mixin class _$GoalInputDtoCopyWith<$Res> implements $GoalInputDtoCopyWith<$Res> {
  factory _$GoalInputDtoCopyWith(_GoalInputDto value, $Res Function(_GoalInputDto) _then) = __$GoalInputDtoCopyWithImpl;
@override @useResult
$Res call({
 String statement, DateTime date, int importance, String context
});




}
/// @nodoc
class __$GoalInputDtoCopyWithImpl<$Res>
    implements _$GoalInputDtoCopyWith<$Res> {
  __$GoalInputDtoCopyWithImpl(this._self, this._then);

  final _GoalInputDto _self;
  final $Res Function(_GoalInputDto) _then;

/// Create a copy of GoalInputDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statement = null,Object? date = null,Object? importance = null,Object? context = null,}) {
  return _then(_GoalInputDto(
statement: null == statement ? _self.statement : statement // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,importance: null == importance ? _self.importance : importance // ignore: cast_nullable_to_non_nullable
as int,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GoalOutputDto {

// Make goalId optional since API doesn't return it
 String? get goalId;// Map snake_case API fields to camelCase Dart fields
@JsonKey(name: 'goal_type') String get goalType; int get specific; String get complexity; String get motivation;@JsonKey(name: 'skill_level') String get skillLevel; String get dependencies; String get measurability; String get decomposability; String get urgency; String get autonomy; String get readiness;@JsonKey(name: 'identity_alignment') String get identityAlignment;@JsonKey(name: 'goal_classification') String get goalClassification;@JsonKey(name: 'complexity_rating') double get complexityRating;@JsonKey(name: 'success_probability') String get successProbability;@JsonKey(name: 'recommended_approach') String get recommendedApproach;
/// Create a copy of GoalOutputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalOutputDtoCopyWith<GoalOutputDto> get copyWith => _$GoalOutputDtoCopyWithImpl<GoalOutputDto>(this as GoalOutputDto, _$identity);

  /// Serializes this GoalOutputDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalOutputDto&&(identical(other.goalId, goalId) || other.goalId == goalId)&&(identical(other.goalType, goalType) || other.goalType == goalType)&&(identical(other.specific, specific) || other.specific == specific)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.motivation, motivation) || other.motivation == motivation)&&(identical(other.skillLevel, skillLevel) || other.skillLevel == skillLevel)&&(identical(other.dependencies, dependencies) || other.dependencies == dependencies)&&(identical(other.measurability, measurability) || other.measurability == measurability)&&(identical(other.decomposability, decomposability) || other.decomposability == decomposability)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.autonomy, autonomy) || other.autonomy == autonomy)&&(identical(other.readiness, readiness) || other.readiness == readiness)&&(identical(other.identityAlignment, identityAlignment) || other.identityAlignment == identityAlignment)&&(identical(other.goalClassification, goalClassification) || other.goalClassification == goalClassification)&&(identical(other.complexityRating, complexityRating) || other.complexityRating == complexityRating)&&(identical(other.successProbability, successProbability) || other.successProbability == successProbability)&&(identical(other.recommendedApproach, recommendedApproach) || other.recommendedApproach == recommendedApproach));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,goalId,goalType,specific,complexity,motivation,skillLevel,dependencies,measurability,decomposability,urgency,autonomy,readiness,identityAlignment,goalClassification,complexityRating,successProbability,recommendedApproach);

@override
String toString() {
  return 'GoalOutputDto(goalId: $goalId, goalType: $goalType, specific: $specific, complexity: $complexity, motivation: $motivation, skillLevel: $skillLevel, dependencies: $dependencies, measurability: $measurability, decomposability: $decomposability, urgency: $urgency, autonomy: $autonomy, readiness: $readiness, identityAlignment: $identityAlignment, goalClassification: $goalClassification, complexityRating: $complexityRating, successProbability: $successProbability, recommendedApproach: $recommendedApproach)';
}


}

/// @nodoc
abstract mixin class $GoalOutputDtoCopyWith<$Res>  {
  factory $GoalOutputDtoCopyWith(GoalOutputDto value, $Res Function(GoalOutputDto) _then) = _$GoalOutputDtoCopyWithImpl;
@useResult
$Res call({
 String? goalId,@JsonKey(name: 'goal_type') String goalType, int specific, String complexity, String motivation,@JsonKey(name: 'skill_level') String skillLevel, String dependencies, String measurability, String decomposability, String urgency, String autonomy, String readiness,@JsonKey(name: 'identity_alignment') String identityAlignment,@JsonKey(name: 'goal_classification') String goalClassification,@JsonKey(name: 'complexity_rating') double complexityRating,@JsonKey(name: 'success_probability') String successProbability,@JsonKey(name: 'recommended_approach') String recommendedApproach
});




}
/// @nodoc
class _$GoalOutputDtoCopyWithImpl<$Res>
    implements $GoalOutputDtoCopyWith<$Res> {
  _$GoalOutputDtoCopyWithImpl(this._self, this._then);

  final GoalOutputDto _self;
  final $Res Function(GoalOutputDto) _then;

/// Create a copy of GoalOutputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? goalId = freezed,Object? goalType = null,Object? specific = null,Object? complexity = null,Object? motivation = null,Object? skillLevel = null,Object? dependencies = null,Object? measurability = null,Object? decomposability = null,Object? urgency = null,Object? autonomy = null,Object? readiness = null,Object? identityAlignment = null,Object? goalClassification = null,Object? complexityRating = null,Object? successProbability = null,Object? recommendedApproach = null,}) {
  return _then(_self.copyWith(
goalId: freezed == goalId ? _self.goalId : goalId // ignore: cast_nullable_to_non_nullable
as String?,goalType: null == goalType ? _self.goalType : goalType // ignore: cast_nullable_to_non_nullable
as String,specific: null == specific ? _self.specific : specific // ignore: cast_nullable_to_non_nullable
as int,complexity: null == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as String,motivation: null == motivation ? _self.motivation : motivation // ignore: cast_nullable_to_non_nullable
as String,skillLevel: null == skillLevel ? _self.skillLevel : skillLevel // ignore: cast_nullable_to_non_nullable
as String,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as String,measurability: null == measurability ? _self.measurability : measurability // ignore: cast_nullable_to_non_nullable
as String,decomposability: null == decomposability ? _self.decomposability : decomposability // ignore: cast_nullable_to_non_nullable
as String,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as String,autonomy: null == autonomy ? _self.autonomy : autonomy // ignore: cast_nullable_to_non_nullable
as String,readiness: null == readiness ? _self.readiness : readiness // ignore: cast_nullable_to_non_nullable
as String,identityAlignment: null == identityAlignment ? _self.identityAlignment : identityAlignment // ignore: cast_nullable_to_non_nullable
as String,goalClassification: null == goalClassification ? _self.goalClassification : goalClassification // ignore: cast_nullable_to_non_nullable
as String,complexityRating: null == complexityRating ? _self.complexityRating : complexityRating // ignore: cast_nullable_to_non_nullable
as double,successProbability: null == successProbability ? _self.successProbability : successProbability // ignore: cast_nullable_to_non_nullable
as String,recommendedApproach: null == recommendedApproach ? _self.recommendedApproach : recommendedApproach // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalOutputDto].
extension GoalOutputDtoPatterns on GoalOutputDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalOutputDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalOutputDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalOutputDto value)  $default,){
final _that = this;
switch (_that) {
case _GoalOutputDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalOutputDto value)?  $default,){
final _that = this;
switch (_that) {
case _GoalOutputDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? goalId, @JsonKey(name: 'goal_type')  String goalType,  int specific,  String complexity,  String motivation, @JsonKey(name: 'skill_level')  String skillLevel,  String dependencies,  String measurability,  String decomposability,  String urgency,  String autonomy,  String readiness, @JsonKey(name: 'identity_alignment')  String identityAlignment, @JsonKey(name: 'goal_classification')  String goalClassification, @JsonKey(name: 'complexity_rating')  double complexityRating, @JsonKey(name: 'success_probability')  String successProbability, @JsonKey(name: 'recommended_approach')  String recommendedApproach)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalOutputDto() when $default != null:
return $default(_that.goalId,_that.goalType,_that.specific,_that.complexity,_that.motivation,_that.skillLevel,_that.dependencies,_that.measurability,_that.decomposability,_that.urgency,_that.autonomy,_that.readiness,_that.identityAlignment,_that.goalClassification,_that.complexityRating,_that.successProbability,_that.recommendedApproach);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? goalId, @JsonKey(name: 'goal_type')  String goalType,  int specific,  String complexity,  String motivation, @JsonKey(name: 'skill_level')  String skillLevel,  String dependencies,  String measurability,  String decomposability,  String urgency,  String autonomy,  String readiness, @JsonKey(name: 'identity_alignment')  String identityAlignment, @JsonKey(name: 'goal_classification')  String goalClassification, @JsonKey(name: 'complexity_rating')  double complexityRating, @JsonKey(name: 'success_probability')  String successProbability, @JsonKey(name: 'recommended_approach')  String recommendedApproach)  $default,) {final _that = this;
switch (_that) {
case _GoalOutputDto():
return $default(_that.goalId,_that.goalType,_that.specific,_that.complexity,_that.motivation,_that.skillLevel,_that.dependencies,_that.measurability,_that.decomposability,_that.urgency,_that.autonomy,_that.readiness,_that.identityAlignment,_that.goalClassification,_that.complexityRating,_that.successProbability,_that.recommendedApproach);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? goalId, @JsonKey(name: 'goal_type')  String goalType,  int specific,  String complexity,  String motivation, @JsonKey(name: 'skill_level')  String skillLevel,  String dependencies,  String measurability,  String decomposability,  String urgency,  String autonomy,  String readiness, @JsonKey(name: 'identity_alignment')  String identityAlignment, @JsonKey(name: 'goal_classification')  String goalClassification, @JsonKey(name: 'complexity_rating')  double complexityRating, @JsonKey(name: 'success_probability')  String successProbability, @JsonKey(name: 'recommended_approach')  String recommendedApproach)?  $default,) {final _that = this;
switch (_that) {
case _GoalOutputDto() when $default != null:
return $default(_that.goalId,_that.goalType,_that.specific,_that.complexity,_that.motivation,_that.skillLevel,_that.dependencies,_that.measurability,_that.decomposability,_that.urgency,_that.autonomy,_that.readiness,_that.identityAlignment,_that.goalClassification,_that.complexityRating,_that.successProbability,_that.recommendedApproach);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GoalOutputDto implements GoalOutputDto {
  const _GoalOutputDto({this.goalId, @JsonKey(name: 'goal_type') required this.goalType, required this.specific, required this.complexity, required this.motivation, @JsonKey(name: 'skill_level') required this.skillLevel, required this.dependencies, required this.measurability, required this.decomposability, required this.urgency, required this.autonomy, required this.readiness, @JsonKey(name: 'identity_alignment') required this.identityAlignment, @JsonKey(name: 'goal_classification') required this.goalClassification, @JsonKey(name: 'complexity_rating') required this.complexityRating, @JsonKey(name: 'success_probability') required this.successProbability, @JsonKey(name: 'recommended_approach') required this.recommendedApproach});
  factory _GoalOutputDto.fromJson(Map<String, dynamic> json) => _$GoalOutputDtoFromJson(json);

// Make goalId optional since API doesn't return it
@override final  String? goalId;
// Map snake_case API fields to camelCase Dart fields
@override@JsonKey(name: 'goal_type') final  String goalType;
@override final  int specific;
@override final  String complexity;
@override final  String motivation;
@override@JsonKey(name: 'skill_level') final  String skillLevel;
@override final  String dependencies;
@override final  String measurability;
@override final  String decomposability;
@override final  String urgency;
@override final  String autonomy;
@override final  String readiness;
@override@JsonKey(name: 'identity_alignment') final  String identityAlignment;
@override@JsonKey(name: 'goal_classification') final  String goalClassification;
@override@JsonKey(name: 'complexity_rating') final  double complexityRating;
@override@JsonKey(name: 'success_probability') final  String successProbability;
@override@JsonKey(name: 'recommended_approach') final  String recommendedApproach;

/// Create a copy of GoalOutputDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalOutputDtoCopyWith<_GoalOutputDto> get copyWith => __$GoalOutputDtoCopyWithImpl<_GoalOutputDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoalOutputDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalOutputDto&&(identical(other.goalId, goalId) || other.goalId == goalId)&&(identical(other.goalType, goalType) || other.goalType == goalType)&&(identical(other.specific, specific) || other.specific == specific)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.motivation, motivation) || other.motivation == motivation)&&(identical(other.skillLevel, skillLevel) || other.skillLevel == skillLevel)&&(identical(other.dependencies, dependencies) || other.dependencies == dependencies)&&(identical(other.measurability, measurability) || other.measurability == measurability)&&(identical(other.decomposability, decomposability) || other.decomposability == decomposability)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.autonomy, autonomy) || other.autonomy == autonomy)&&(identical(other.readiness, readiness) || other.readiness == readiness)&&(identical(other.identityAlignment, identityAlignment) || other.identityAlignment == identityAlignment)&&(identical(other.goalClassification, goalClassification) || other.goalClassification == goalClassification)&&(identical(other.complexityRating, complexityRating) || other.complexityRating == complexityRating)&&(identical(other.successProbability, successProbability) || other.successProbability == successProbability)&&(identical(other.recommendedApproach, recommendedApproach) || other.recommendedApproach == recommendedApproach));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,goalId,goalType,specific,complexity,motivation,skillLevel,dependencies,measurability,decomposability,urgency,autonomy,readiness,identityAlignment,goalClassification,complexityRating,successProbability,recommendedApproach);

@override
String toString() {
  return 'GoalOutputDto(goalId: $goalId, goalType: $goalType, specific: $specific, complexity: $complexity, motivation: $motivation, skillLevel: $skillLevel, dependencies: $dependencies, measurability: $measurability, decomposability: $decomposability, urgency: $urgency, autonomy: $autonomy, readiness: $readiness, identityAlignment: $identityAlignment, goalClassification: $goalClassification, complexityRating: $complexityRating, successProbability: $successProbability, recommendedApproach: $recommendedApproach)';
}


}

/// @nodoc
abstract mixin class _$GoalOutputDtoCopyWith<$Res> implements $GoalOutputDtoCopyWith<$Res> {
  factory _$GoalOutputDtoCopyWith(_GoalOutputDto value, $Res Function(_GoalOutputDto) _then) = __$GoalOutputDtoCopyWithImpl;
@override @useResult
$Res call({
 String? goalId,@JsonKey(name: 'goal_type') String goalType, int specific, String complexity, String motivation,@JsonKey(name: 'skill_level') String skillLevel, String dependencies, String measurability, String decomposability, String urgency, String autonomy, String readiness,@JsonKey(name: 'identity_alignment') String identityAlignment,@JsonKey(name: 'goal_classification') String goalClassification,@JsonKey(name: 'complexity_rating') double complexityRating,@JsonKey(name: 'success_probability') String successProbability,@JsonKey(name: 'recommended_approach') String recommendedApproach
});




}
/// @nodoc
class __$GoalOutputDtoCopyWithImpl<$Res>
    implements _$GoalOutputDtoCopyWith<$Res> {
  __$GoalOutputDtoCopyWithImpl(this._self, this._then);

  final _GoalOutputDto _self;
  final $Res Function(_GoalOutputDto) _then;

/// Create a copy of GoalOutputDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? goalId = freezed,Object? goalType = null,Object? specific = null,Object? complexity = null,Object? motivation = null,Object? skillLevel = null,Object? dependencies = null,Object? measurability = null,Object? decomposability = null,Object? urgency = null,Object? autonomy = null,Object? readiness = null,Object? identityAlignment = null,Object? goalClassification = null,Object? complexityRating = null,Object? successProbability = null,Object? recommendedApproach = null,}) {
  return _then(_GoalOutputDto(
goalId: freezed == goalId ? _self.goalId : goalId // ignore: cast_nullable_to_non_nullable
as String?,goalType: null == goalType ? _self.goalType : goalType // ignore: cast_nullable_to_non_nullable
as String,specific: null == specific ? _self.specific : specific // ignore: cast_nullable_to_non_nullable
as int,complexity: null == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as String,motivation: null == motivation ? _self.motivation : motivation // ignore: cast_nullable_to_non_nullable
as String,skillLevel: null == skillLevel ? _self.skillLevel : skillLevel // ignore: cast_nullable_to_non_nullable
as String,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as String,measurability: null == measurability ? _self.measurability : measurability // ignore: cast_nullable_to_non_nullable
as String,decomposability: null == decomposability ? _self.decomposability : decomposability // ignore: cast_nullable_to_non_nullable
as String,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as String,autonomy: null == autonomy ? _self.autonomy : autonomy // ignore: cast_nullable_to_non_nullable
as String,readiness: null == readiness ? _self.readiness : readiness // ignore: cast_nullable_to_non_nullable
as String,identityAlignment: null == identityAlignment ? _self.identityAlignment : identityAlignment // ignore: cast_nullable_to_non_nullable
as String,goalClassification: null == goalClassification ? _self.goalClassification : goalClassification // ignore: cast_nullable_to_non_nullable
as String,complexityRating: null == complexityRating ? _self.complexityRating : complexityRating // ignore: cast_nullable_to_non_nullable
as double,successProbability: null == successProbability ? _self.successProbability : successProbability // ignore: cast_nullable_to_non_nullable
as String,recommendedApproach: null == recommendedApproach ? _self.recommendedApproach : recommendedApproach // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Goal {

 String get id; String get userId; DateTime get date; String get goalType; int get specific; String get complexity; String get motivation; String get skillLevel; String get dependencies; String get measurability; String get decomposability; String get urgency; String get autonomy; String get readiness; String get identityAlignment; String get goalClassification; double get complexityRating; String get successProbability; String get recommendedApproach;
/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalCopyWith<Goal> get copyWith => _$GoalCopyWithImpl<Goal>(this as Goal, _$identity);

  /// Serializes this Goal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Goal&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.goalType, goalType) || other.goalType == goalType)&&(identical(other.specific, specific) || other.specific == specific)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.motivation, motivation) || other.motivation == motivation)&&(identical(other.skillLevel, skillLevel) || other.skillLevel == skillLevel)&&(identical(other.dependencies, dependencies) || other.dependencies == dependencies)&&(identical(other.measurability, measurability) || other.measurability == measurability)&&(identical(other.decomposability, decomposability) || other.decomposability == decomposability)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.autonomy, autonomy) || other.autonomy == autonomy)&&(identical(other.readiness, readiness) || other.readiness == readiness)&&(identical(other.identityAlignment, identityAlignment) || other.identityAlignment == identityAlignment)&&(identical(other.goalClassification, goalClassification) || other.goalClassification == goalClassification)&&(identical(other.complexityRating, complexityRating) || other.complexityRating == complexityRating)&&(identical(other.successProbability, successProbability) || other.successProbability == successProbability)&&(identical(other.recommendedApproach, recommendedApproach) || other.recommendedApproach == recommendedApproach));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,date,goalType,specific,complexity,motivation,skillLevel,dependencies,measurability,decomposability,urgency,autonomy,readiness,identityAlignment,goalClassification,complexityRating,successProbability,recommendedApproach]);

@override
String toString() {
  return 'Goal(id: $id, userId: $userId, date: $date, goalType: $goalType, specific: $specific, complexity: $complexity, motivation: $motivation, skillLevel: $skillLevel, dependencies: $dependencies, measurability: $measurability, decomposability: $decomposability, urgency: $urgency, autonomy: $autonomy, readiness: $readiness, identityAlignment: $identityAlignment, goalClassification: $goalClassification, complexityRating: $complexityRating, successProbability: $successProbability, recommendedApproach: $recommendedApproach)';
}


}

/// @nodoc
abstract mixin class $GoalCopyWith<$Res>  {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) _then) = _$GoalCopyWithImpl;
@useResult
$Res call({
 String id, String userId, DateTime date, String goalType, int specific, String complexity, String motivation, String skillLevel, String dependencies, String measurability, String decomposability, String urgency, String autonomy, String readiness, String identityAlignment, String goalClassification, double complexityRating, String successProbability, String recommendedApproach
});




}
/// @nodoc
class _$GoalCopyWithImpl<$Res>
    implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._self, this._then);

  final Goal _self;
  final $Res Function(Goal) _then;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? date = null,Object? goalType = null,Object? specific = null,Object? complexity = null,Object? motivation = null,Object? skillLevel = null,Object? dependencies = null,Object? measurability = null,Object? decomposability = null,Object? urgency = null,Object? autonomy = null,Object? readiness = null,Object? identityAlignment = null,Object? goalClassification = null,Object? complexityRating = null,Object? successProbability = null,Object? recommendedApproach = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,goalType: null == goalType ? _self.goalType : goalType // ignore: cast_nullable_to_non_nullable
as String,specific: null == specific ? _self.specific : specific // ignore: cast_nullable_to_non_nullable
as int,complexity: null == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as String,motivation: null == motivation ? _self.motivation : motivation // ignore: cast_nullable_to_non_nullable
as String,skillLevel: null == skillLevel ? _self.skillLevel : skillLevel // ignore: cast_nullable_to_non_nullable
as String,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as String,measurability: null == measurability ? _self.measurability : measurability // ignore: cast_nullable_to_non_nullable
as String,decomposability: null == decomposability ? _self.decomposability : decomposability // ignore: cast_nullable_to_non_nullable
as String,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as String,autonomy: null == autonomy ? _self.autonomy : autonomy // ignore: cast_nullable_to_non_nullable
as String,readiness: null == readiness ? _self.readiness : readiness // ignore: cast_nullable_to_non_nullable
as String,identityAlignment: null == identityAlignment ? _self.identityAlignment : identityAlignment // ignore: cast_nullable_to_non_nullable
as String,goalClassification: null == goalClassification ? _self.goalClassification : goalClassification // ignore: cast_nullable_to_non_nullable
as String,complexityRating: null == complexityRating ? _self.complexityRating : complexityRating // ignore: cast_nullable_to_non_nullable
as double,successProbability: null == successProbability ? _self.successProbability : successProbability // ignore: cast_nullable_to_non_nullable
as String,recommendedApproach: null == recommendedApproach ? _self.recommendedApproach : recommendedApproach // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Goal].
extension GoalPatterns on Goal {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Goal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Goal() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Goal value)  $default,){
final _that = this;
switch (_that) {
case _Goal():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Goal value)?  $default,){
final _that = this;
switch (_that) {
case _Goal() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime date,  String goalType,  int specific,  String complexity,  String motivation,  String skillLevel,  String dependencies,  String measurability,  String decomposability,  String urgency,  String autonomy,  String readiness,  String identityAlignment,  String goalClassification,  double complexityRating,  String successProbability,  String recommendedApproach)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Goal() when $default != null:
return $default(_that.id,_that.userId,_that.date,_that.goalType,_that.specific,_that.complexity,_that.motivation,_that.skillLevel,_that.dependencies,_that.measurability,_that.decomposability,_that.urgency,_that.autonomy,_that.readiness,_that.identityAlignment,_that.goalClassification,_that.complexityRating,_that.successProbability,_that.recommendedApproach);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime date,  String goalType,  int specific,  String complexity,  String motivation,  String skillLevel,  String dependencies,  String measurability,  String decomposability,  String urgency,  String autonomy,  String readiness,  String identityAlignment,  String goalClassification,  double complexityRating,  String successProbability,  String recommendedApproach)  $default,) {final _that = this;
switch (_that) {
case _Goal():
return $default(_that.id,_that.userId,_that.date,_that.goalType,_that.specific,_that.complexity,_that.motivation,_that.skillLevel,_that.dependencies,_that.measurability,_that.decomposability,_that.urgency,_that.autonomy,_that.readiness,_that.identityAlignment,_that.goalClassification,_that.complexityRating,_that.successProbability,_that.recommendedApproach);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  DateTime date,  String goalType,  int specific,  String complexity,  String motivation,  String skillLevel,  String dependencies,  String measurability,  String decomposability,  String urgency,  String autonomy,  String readiness,  String identityAlignment,  String goalClassification,  double complexityRating,  String successProbability,  String recommendedApproach)?  $default,) {final _that = this;
switch (_that) {
case _Goal() when $default != null:
return $default(_that.id,_that.userId,_that.date,_that.goalType,_that.specific,_that.complexity,_that.motivation,_that.skillLevel,_that.dependencies,_that.measurability,_that.decomposability,_that.urgency,_that.autonomy,_that.readiness,_that.identityAlignment,_that.goalClassification,_that.complexityRating,_that.successProbability,_that.recommendedApproach);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Goal implements Goal {
  const _Goal({required this.id, required this.userId, required this.date, required this.goalType, required this.specific, required this.complexity, required this.motivation, required this.skillLevel, required this.dependencies, required this.measurability, required this.decomposability, required this.urgency, required this.autonomy, required this.readiness, required this.identityAlignment, required this.goalClassification, required this.complexityRating, required this.successProbability, required this.recommendedApproach});
  factory _Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

@override final  String id;
@override final  String userId;
@override final  DateTime date;
@override final  String goalType;
@override final  int specific;
@override final  String complexity;
@override final  String motivation;
@override final  String skillLevel;
@override final  String dependencies;
@override final  String measurability;
@override final  String decomposability;
@override final  String urgency;
@override final  String autonomy;
@override final  String readiness;
@override final  String identityAlignment;
@override final  String goalClassification;
@override final  double complexityRating;
@override final  String successProbability;
@override final  String recommendedApproach;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalCopyWith<_Goal> get copyWith => __$GoalCopyWithImpl<_Goal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Goal&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.goalType, goalType) || other.goalType == goalType)&&(identical(other.specific, specific) || other.specific == specific)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.motivation, motivation) || other.motivation == motivation)&&(identical(other.skillLevel, skillLevel) || other.skillLevel == skillLevel)&&(identical(other.dependencies, dependencies) || other.dependencies == dependencies)&&(identical(other.measurability, measurability) || other.measurability == measurability)&&(identical(other.decomposability, decomposability) || other.decomposability == decomposability)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.autonomy, autonomy) || other.autonomy == autonomy)&&(identical(other.readiness, readiness) || other.readiness == readiness)&&(identical(other.identityAlignment, identityAlignment) || other.identityAlignment == identityAlignment)&&(identical(other.goalClassification, goalClassification) || other.goalClassification == goalClassification)&&(identical(other.complexityRating, complexityRating) || other.complexityRating == complexityRating)&&(identical(other.successProbability, successProbability) || other.successProbability == successProbability)&&(identical(other.recommendedApproach, recommendedApproach) || other.recommendedApproach == recommendedApproach));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,date,goalType,specific,complexity,motivation,skillLevel,dependencies,measurability,decomposability,urgency,autonomy,readiness,identityAlignment,goalClassification,complexityRating,successProbability,recommendedApproach]);

@override
String toString() {
  return 'Goal(id: $id, userId: $userId, date: $date, goalType: $goalType, specific: $specific, complexity: $complexity, motivation: $motivation, skillLevel: $skillLevel, dependencies: $dependencies, measurability: $measurability, decomposability: $decomposability, urgency: $urgency, autonomy: $autonomy, readiness: $readiness, identityAlignment: $identityAlignment, goalClassification: $goalClassification, complexityRating: $complexityRating, successProbability: $successProbability, recommendedApproach: $recommendedApproach)';
}


}

/// @nodoc
abstract mixin class _$GoalCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$GoalCopyWith(_Goal value, $Res Function(_Goal) _then) = __$GoalCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, DateTime date, String goalType, int specific, String complexity, String motivation, String skillLevel, String dependencies, String measurability, String decomposability, String urgency, String autonomy, String readiness, String identityAlignment, String goalClassification, double complexityRating, String successProbability, String recommendedApproach
});




}
/// @nodoc
class __$GoalCopyWithImpl<$Res>
    implements _$GoalCopyWith<$Res> {
  __$GoalCopyWithImpl(this._self, this._then);

  final _Goal _self;
  final $Res Function(_Goal) _then;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? date = null,Object? goalType = null,Object? specific = null,Object? complexity = null,Object? motivation = null,Object? skillLevel = null,Object? dependencies = null,Object? measurability = null,Object? decomposability = null,Object? urgency = null,Object? autonomy = null,Object? readiness = null,Object? identityAlignment = null,Object? goalClassification = null,Object? complexityRating = null,Object? successProbability = null,Object? recommendedApproach = null,}) {
  return _then(_Goal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,goalType: null == goalType ? _self.goalType : goalType // ignore: cast_nullable_to_non_nullable
as String,specific: null == specific ? _self.specific : specific // ignore: cast_nullable_to_non_nullable
as int,complexity: null == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as String,motivation: null == motivation ? _self.motivation : motivation // ignore: cast_nullable_to_non_nullable
as String,skillLevel: null == skillLevel ? _self.skillLevel : skillLevel // ignore: cast_nullable_to_non_nullable
as String,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as String,measurability: null == measurability ? _self.measurability : measurability // ignore: cast_nullable_to_non_nullable
as String,decomposability: null == decomposability ? _self.decomposability : decomposability // ignore: cast_nullable_to_non_nullable
as String,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as String,autonomy: null == autonomy ? _self.autonomy : autonomy // ignore: cast_nullable_to_non_nullable
as String,readiness: null == readiness ? _self.readiness : readiness // ignore: cast_nullable_to_non_nullable
as String,identityAlignment: null == identityAlignment ? _self.identityAlignment : identityAlignment // ignore: cast_nullable_to_non_nullable
as String,goalClassification: null == goalClassification ? _self.goalClassification : goalClassification // ignore: cast_nullable_to_non_nullable
as String,complexityRating: null == complexityRating ? _self.complexityRating : complexityRating // ignore: cast_nullable_to_non_nullable
as double,successProbability: null == successProbability ? _self.successProbability : successProbability // ignore: cast_nullable_to_non_nullable
as String,recommendedApproach: null == recommendedApproach ? _self.recommendedApproach : recommendedApproach // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
