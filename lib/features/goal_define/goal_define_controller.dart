import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../bannerService.dart';
import 'goal_define_model.dart';
import '/services/api_service.dart';
import 'dart:convert' show jsonDecode;

class GoalCreationController extends GetxController {
  final ApiService _api = Get.find<ApiService>();
  final BannerService _bannerService = Get.find<BannerService>();

  /* ---------- Reactive state shared by all pages ---------- */
  final Rx<GoalInputDto?> input = Rx(null);
  final Rx<GoalOutputDto?> analysis = Rx(null);
  final RxBool isLoading = false.obs;
  final RxBool isAnalyzing = false.obs;
  final RxBool isSaving = false.obs;
  final RxString error = ''.obs;

  /* ---------- Helper to get or create default input ---------- */
  GoalInputDto _getOrCreateInput() {
    return input.value ??
        GoalInputDto(
          statement: '',
          date: DateTime.now().add(const Duration(days: 7)),
          importance: 5,
          context: '',
        );
  }

  /* ---------- Helper setters (called by UI) ---------- */
  void setStatement(String s) =>
      input.value = _getOrCreateInput().copyWith(statement: s);

  void setDate(DateTime d) =>
      input.value = _getOrCreateInput().copyWith(date: d);

  void setImportance(int i) =>
      input.value = _getOrCreateInput().copyWith(importance: i);

  void setContext(String c) =>
      input.value = _getOrCreateInput().copyWith(context: c);

  /* ---------- Validation ---------- */
  bool get canAnalyze {
    final dto = input.value;
    return dto != null && dto.statement.trim().isNotEmpty;
  }

  /* ---------- Analyze Goal ---------- */
  Future<bool> analyzeGoal() async {
    final dto = input.value;
    if (dto == null || dto.statement.trim().isEmpty) {
      error('Please enter a goal statement');
      return false;
    }

    try {
      isAnalyzing(true);
      isLoading(true);
      error('');

      print('Analyzing goal: ${dto.statement}');

      final resp = await _api.post('/goals/analyze', data: dto.toJson());

      print('Raw API response: ${resp.data}');
      print('Response type: ${resp.data.runtimeType}');

      if (resp.data != null) {
        try {
          Map<String, dynamic> jsonData;

          if (resp.data is String) {
            jsonData = jsonDecode(resp.data);
          } else if (resp.data is Map<String, dynamic>) {
            jsonData = resp.data;
          } else {
            throw FormatException(
              'Unexpected response type: ${resp.data.runtimeType}',
            );
          }

          print('Parsed JSON data: $jsonData');

          final analysisResult = GoalOutputDto.fromJson(jsonData);
          analysis(analysisResult);

          print('Analysis successfully parsed: ${analysisResult.goalType}');
          return true;
        } catch (e) {
          print('JSON parsing error: $e');

          if (e.toString().contains('FormatException')) {
            error('Invalid JSON format from server');
          } else if (e.toString().contains('type \'Null\' is not a subtype')) {
            error('Missing required fields in server response');
          } else if (e.toString().contains('CheckedFromJsonException')) {
            error(
              'Invalid data format: ${e.toString().split(':').last.trim()}',
            );
          } else {
            error('Failed to parse server response: ${e.toString()}');
          }
          return false;
        }
      } else {
        error('Empty response from server');
        return false;
      }
    } catch (e) {
      print('Analysis error: $e');

      if (e.toString().contains('SocketException')) {
        error(
          'Network connection error. Please check your internet connection.',
        );
      } else if (e.toString().contains('TimeoutException')) {
        error('Request timed out. Please try again.');
      } else {
        error('Failed to analyze goal: ${e.toString()}');
      }

      analysis(null);
      return false;
    } finally {
      isAnalyzing(false);
      isLoading(false);
    }
  }

  /* ---------- Save Goal (Fire-and-Forget with Background Processing) ---------- */
  Future<bool> saveGoal() async {
    final inputData = input.value;
    final analysisData = analysis.value;

    if (inputData == null || inputData.statement.trim().isEmpty) {
      error('Please enter a goal statement');
      return false;
    }

    if (analysisData == null) {
      error('Please analyze the goal first');
      return false;
    }

    try {
      isSaving(true);
      error('');

      print('Preparing to save goal...');
        final uid = Supabase.instance.client.auth.currentUser?.id;
  if (uid == null || uid.isEmpty) {
    error('User not authenticated');
    return false;
  }


      // Combine user input + only key analysis fields
      final jsonData = {
        'user_id': uid, // TODO: Get from auth service
        'statement': inputData.statement,
        'date': inputData.date.toIso8601String(),
        'importance': inputData.importance,
        'context': inputData.context,

        // Save only essential analysis fields for planning
        'goal_classification': analysisData.goalClassification,
        'complexity_rating': analysisData.complexityRating,
        'recommended_approach': analysisData.recommendedApproach,
        'success_probability': analysisData.successProbability,
      };

      print('Saving goal with data: $jsonData');

      // Navigate immediately (user doesn't wait)
      Get.offAllNamed('/goals');

      // Fire-and-forget: Process in background without awaiting
      _processGoalInBackground(jsonData);

      return true;
    } catch (e) {
      error('Failed to save goal: ${e.toString()}');
      print('Save error: ${e.toString()}');
      return false;
    } finally {
      isSaving(false);
    }
  }

  /* ---------- Background Processing (Fire-and-Forget) ---------- */
  Future<void> _processGoalInBackground(Map<String, dynamic> jsonData) async {
    try {
      _bannerService.showInfo(
        'Finalizing your goal...',
        duration: const Duration(seconds: 60),
      );

      print('Starting background goal processing...');

      await _api.post('/goals/verify_and_save', data: jsonData);

      print('Goal verified and saved successfully in background');
      _bannerService.showSuccess(
        'Goal saved successfully!',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Background processing error: $e');
      _bannerService.showError(
        'Failed to finalize goal. Please try again.',
        duration: const Duration(seconds: 4),
      );
    }
  }

  /* ---------- Utility methods ---------- */
  void clearError() => error('');

  void resetAnalysis() {
    analysis(null);
    error('');
  }

  Future<void> reAnalyze() async {
    resetAnalysis();
    await analyzeGoal();
  }

  /* ---------- Lifecycle ---------- */
  @override
  void onClose() {
    super.onClose();
  }

  /* ---------- Debug helpers ---------- */
  void debugPrintState() {
    print('=== Controller State ===');
    print('Input: ${input.value?.statement}');
    print('Analysis: ${analysis.value?.goalType}');
    print('IsLoading: ${isLoading.value}');
    print('IsAnalyzing: ${isAnalyzing.value}');
    print('IsSaving: ${isSaving.value}');
    print('Error: ${error.value}');
    print('========================');
  }
}
