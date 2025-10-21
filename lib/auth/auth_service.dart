// services/supabase_service.dart

import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse, User;
import 'user_model.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // Sign up
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return AuthResponse(
          success: true,
          user: User(id: response.user!.id, email: response.user!.email ?? ''),
        );
      }
      return AuthResponse(success: false, error: 'Sign up failed');
    } catch (e) {
      return AuthResponse(success: false, error: e.toString());
    }
  }

  // Login
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return AuthResponse(
          success: true,
          user: User(id: response.user!.id, email: response.user!.email ?? ''),
        );
      }
      return AuthResponse(success: false, error: 'Login failed');
    } catch (e) {
      return AuthResponse(success: false, error: e.toString());
    }
  }

  // Logout
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      return User(id: user.id, email: user.email ?? '');
    }
    return null;
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _supabase.auth.currentUser != null;
  }
}
