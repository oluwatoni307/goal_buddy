class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatar;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  /// Factory from JSON (placeholder shape)
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        avatar: json['avatar'] as String?,
      );

  /// To JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatar': avatar,
      };

  /// Empty user for initial state
  static const empty = UserModel(id: 0, name: '', email: '');
}