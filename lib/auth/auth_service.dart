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

      // If response.user is null, Supabase likely requires email confirmation.
      // Try to sign in immediately — this will only work if confirmation is NOT required.
      final loginResult = await login(email: email, password: password);
      if (loginResult.success) return loginResult;

      // Otherwise return a clearer message so UI can prompt the user to check email.
      return AuthResponse(
        success: false,
        error:
            'Sign up created but no session was returned. If your project requires email confirmation, check your inbox and verify your email before logging in.',
      );
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

  // Start listening to auth state changes (use in your app to update UI when session changes)
  void startAuthListener(void Function(Session? session) onChange) {
    _supabase.auth.onAuthStateChange.listen((data) {
      // data.event and data.session available
      onChange(data.session);
    });
  }
}
