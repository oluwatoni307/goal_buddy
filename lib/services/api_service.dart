import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:get/get.dart' hide Response;

import '../constants.dart';

/// Simple HTTP client for demo phase - no auth required
class ApiService extends GetxService {
  late final Dio _dio;

  @override
  void onInit() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://tes12t-fcc7366774c7.herokuapp.com', // For Flutter web
        connectTimeout: AppDurations.apiTimeout,
        receiveTimeout: AppDurations.apiTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    if (Get.isLogEnable) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }

    super.onInit();
  }

  Dio get dio => _dio;

  Future<Response> get(String path, {Map<String, dynamic>? query}) =>
      _dio.get(path, queryParameters: query);

  Future<Response> post(String path, {dynamic data}) =>
      _dio.post(path, data: data);

  Future<Response> put(String path, {dynamic data}) =>
      _dio.put(path, data: data);

  Future<Response> patch(String path, {dynamic data}) =>
      _dio.patch(path, data: data);

  Future<Response> delete(String path, {dynamic data}) =>
      _dio.delete(path, data: data);
}
