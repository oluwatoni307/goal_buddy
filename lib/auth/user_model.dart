// models/auth_models.dart

class User {
  final String id;
  final String email;

  User({required this.id, required this.email});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(id: map['id'] ?? '', email: map['email'] ?? '');
  }
}

class AuthResponse {
  final bool success;
  final User? user;
  final String? error;

  AuthResponse({required this.success, this.user, this.error});
}
