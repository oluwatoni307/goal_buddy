/// Generic wrapper for every backend response.
/// Works for both success and error payloads.
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) =>
      ApiResponse<T>(
        success: json['success'] as bool,
        message: json['message'] as String?,
        data: json['data'] != null ? fromJsonT(json['data']) : null,
      );

  Map<String, dynamic> toJson(
    Map<String, dynamic> Function(T) toJsonT,
  ) =>
      {
        'success': success,
        'message': message,
        'data': data != null ? toJsonT(data as T) : null,
      };
}

/// When the server simply returns a list instead of an object.
class ApiListResponse<T> {
  final bool success;
  final String? message;
  final List<T> data;

  const ApiListResponse({
    required this.success,
    this.message,
    required this.data,
  });

  factory ApiListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) =>
      ApiListResponse<T>(
        success: json['success'] as bool,
        message: json['message'] as String?,
        data: (json['data'] as List)
            .map((e) => fromJsonT(e as Map<String, dynamic>))
            .toList(),
      );
}