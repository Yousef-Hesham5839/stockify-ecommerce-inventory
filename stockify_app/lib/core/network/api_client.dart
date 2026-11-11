import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_endpoints.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  ApiClient({required this.dio, required this.secureStorage}) {
    dio.options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Adding Interceptors to recieve the token automatically in every request
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await secureStorage.read(key: 'jwt_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          final errorMessage = _handleDioError(e);
          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: errorMessage,
              response: e.response,
              type: e.type,
            ),
          );
        },
      ),
    );
  }

  String _handleDioError(DioException error) {
    if (error.response != null && error.response?.data != null) {
      final data = error.response?.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'].toString();
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout with server';
      case DioExceptionType.connectionError:
        return 'Cannot connect to server. Check your network or server status.';
      default:
        return 'Unexpected network error occurred';
    }
  }

  // Get
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ServerException(
        message: e.error?.toString() ?? 'Failed to perform GET request',
        statusCode: e.response?.statusCode,
      );
    }
  }


  // Post
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await dio.post(path, data: data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.error?.toString() ?? 'Failed to perform POST request',
        statusCode: e.response?.statusCode,
      );
    }
  }

  // Put
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await dio.put(path, data: data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.error?.toString() ?? 'Failed to perform PUT request',
        statusCode: e.response?.statusCode,
      );
    }
  }

  // Delete
  Future<Response> delete(String path) async {
    try {
      return await dio.delete(path);
    } on DioException catch (e) {
      throw ServerException(
        message: e.error?.toString() ?? 'Failed to perform DELETE request',
        statusCode: e.response?.statusCode,
      );
    }
  }
}