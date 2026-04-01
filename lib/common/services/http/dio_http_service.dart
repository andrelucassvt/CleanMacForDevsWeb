import 'dart:developer';

import 'package:base_app/common/services/http/http_service.dart';
import 'package:dio/dio.dart';

/// Implementação do HttpService usando Dio
class DioHttpService implements HttpService {
  const DioHttpService(this._dio);

  final Dio _dio;

  @override
  Future<HttpResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _mapResponse(response);
    } catch (e) {
      log('❌ GET $path: $e', name: 'HTTP');
      rethrow;
    }
  }

  @override
  Future<HttpResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _mapResponse(response);
    } catch (e) {
      log('❌ POST $path: $e', name: 'HTTP');
      rethrow;
    }
  }

  @override
  Future<HttpResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _mapResponse(response);
    } catch (e) {
      log('❌ PUT $path: $e', name: 'HTTP');
      rethrow;
    }
  }

  @override
  Future<HttpResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _mapResponse(response);
    } catch (e) {
      log('❌ PATCH $path: $e', name: 'HTTP');
      rethrow;
    }
  }

  @override
  Future<HttpResponse> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _mapResponse(response);
    } catch (e) {
      log('❌ DELETE $path: $e', name: 'HTTP');
      rethrow;
    }
  }

  @override
  Future<HttpResponse> download(
    String path,
    String savePath, {
    Map<String, dynamic>? headers,
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    try {
      log('⬇️  DOWNLOAD $path -> $savePath', name: 'HTTP');
      final response = await _dio.download(
        path,
        savePath,
        options: Options(headers: headers),
        onReceiveProgress: onReceiveProgress,
      );
      log('✅ DOWNLOAD completed: ${response.statusCode}', name: 'HTTP');
      return _mapResponse(response);
    } catch (e) {
      log('❌ DOWNLOAD $path: $e', name: 'HTTP');
      rethrow;
    }
  }

  /// Converte Response do Dio para HttpResponse agnóstico
  HttpResponse _mapResponse(Response<dynamic> response) {
    return HttpResponse(
      data: response.data,
      statusCode: response.statusCode ?? 0,
      statusMessage: response.statusMessage,
      headers: response.headers.map,
    );
  }
}
