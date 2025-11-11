// GENERATED for feature: dashboard
// TODO: implement
import 'dart:convert';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/api_service.dart';
import 'dashboard_model.dart';

Future<Dashboard> fetchDashboard() async {
  final ApiService _api = Get.find<ApiService>();
  final uid = Supabase.instance.client.auth.currentUser?.id;
  final endpoint = '/dashboard';
  final resp = await _api.get(endpoint, query: {'user_id': uid});

  if (resp.statusCode != 200) {
    throw Exception('Failed to fetch dashboard: HTTP ${resp.statusCode}');
  }
  
  // Check if resp.data is already decoded
  final data = resp.data is String ? jsonDecode(resp.data) : resp.data;
  return Dashboard.fromJson(data as Map<String, dynamic>);
}