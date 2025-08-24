import 'package:get/get.dart';
import 'goal_define_model.dart';
import '/services/api_service.dart';
import 'dart:convert' show jsonDecode;


class GoalCreationController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  /* ---------- Reactive state shared by all pages ---------- */
  final Rx<GoalInputDto?> input = Rx(null);          
  final Rx<GoalOutputDto?> analysis = Rx(null);      
  final RxBool isLoading = false.obs;
  final RxBool isAnalyzing = false.obs; // Separate loading state for analysis
  final RxBool isSaving = false.obs;    // Separate loading state for saving
  final RxString error = ''.obs;

  /* ---------- Helper to get or create default input ---------- */
  GoalInputDto _getOrCreateInput() {
    return input.value ?? GoalInputDto(
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

 // Update the analyzeGoal method in your controller

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
        // Handle both String and Map responses
        Map<String, dynamic> jsonData;
        
        if (resp.data is String) {
          jsonData = jsonDecode(resp.data);
        } else if (resp.data is Map<String, dynamic>) {
          jsonData = resp.data;
        } else {
          throw FormatException('Unexpected response type: ${resp.data.runtimeType}');
        }
        
        print('Parsed JSON data: $jsonData');
        
        // Let Freezed handle the parsing with proper error messages
        final analysisResult = GoalOutputDto.fromJson(jsonData);
        analysis(analysisResult);
        
        print('Analysis successfully parsed: ${analysisResult.goalType}');
        return true;
        
      } catch (e) {
        print('JSON parsing error: $e');
        
        // More specific error handling for Freezed/JSON issues
        if (e.toString().contains('FormatException')) {
          error('Invalid JSON format from server');
        } else if (e.toString().contains('type \'Null\' is not a subtype')) {
          error('Missing required fields in server response');
        } else if (e.toString().contains('CheckedFromJsonException')) {
          // Freezed validation error
          error('Invalid data format: ${e.toString().split(':').last.trim()}');
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
    
    // Network and API errors
    if (e.toString().contains('SocketException')) {
      error('Network connection error. Please check your internet connection.');
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

// Don't forget to add this import at the top if not present
Future<bool> saveGoal() async {
  final out = analysis.value;
  if (out == null) {
    error('No analysis available to save');
    return false;
  }
  
  try {
    isSaving(true);
    isLoading(true); // Keep for backward compatibility
    error('');
   
    final toSave = Goal(
      id: "test",
      userId: 'mock-user-id', // TODO: real user id
      date: input.value!.date,
      goalType: out.goalType,
      specific: out.specific,
      complexity: out.complexity,
      motivation: out.motivation,
      skillLevel: out.skillLevel,
      dependencies: out.dependencies,
      measurability: out.measurability,
      decomposability: out.decomposability,
      urgency: out.urgency,
      autonomy: out.autonomy,
      readiness: out.readiness,
      identityAlignment: out.identityAlignment,
      goalClassification: out.goalClassification,
      complexityRating: out.complexityRating,
      successProbability: out.successProbability,
      recommendedApproach: out.recommendedApproach,
    );
   
    // Convert to snake_case JSON format for server
    final jsonData = {
      'id': toSave.id,
      'userId': toSave.userId, // Check if server expects 'user_id' instead
      'date': toSave.date.toIso8601String(),
      'goal_type': toSave.goalType,
      'specific': toSave.specific,
      'complexity': toSave.complexity,
      'motivation': toSave.motivation,
      'skill_level': toSave.skillLevel,
      'dependencies': toSave.dependencies,
      'measurability': toSave.measurability,
      'decomposability': toSave.decomposability,
      'urgency': toSave.urgency,
      'autonomy': toSave.autonomy,
      'readiness': toSave.readiness,
      'identity_alignment': toSave.identityAlignment,
      'goal_classification': toSave.goalClassification,
      'complexity_rating': toSave.complexityRating,
      'success_probability': toSave.successProbability,
      'recommended_approach': toSave.recommendedApproach,
    };
   
    await _api.post('/goals', data: jsonData);
   
     // Navigate after successful save
    Get.offAllNamed('/goals');
    return true;
   
  } catch (e) {
    error('Failed to save goal: ${e.toString()}');
    print(" ${e.toString()}");
    return false;
  } finally {
    isSaving(false);
    isLoading(false);
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
    // Clean up if needed
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