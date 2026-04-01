import 'package:base_app/common/services/storage_service.dart';
import 'package:base_app/config/network/auth_interceptor.dart';
import 'package:base_app/config/network/error_interceptor.dart';
import 'package:dio/dio.dart';

Dio makeDio({
  required StorageService storageService,
  String baseUrl = 'https://api.example.com',
  bool enableLogs = false,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  if (enableLogs) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  dio.interceptors.add(AuthInterceptor(storageService));
  dio.interceptors.add(ErrorInterceptor());
  return dio;
}
