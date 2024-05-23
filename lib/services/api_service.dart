import 'package:dio/dio.dart';
import 'package:stockbuddy_flutter_app/app/app_configurations.dart';

import 'app_interceptor.dart';

class RestClient {
  static final _instance = RestClient._internal();

  Dio? _dio;

  RestClient._internal() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(milliseconds: 20000),
      receiveTimeout: const Duration(milliseconds: 20000),
      sendTimeout: const Duration(milliseconds: 20000),
      baseUrl: AppConfigurations.instance.apiBaseUrl,
    ));

    _dio!.options.contentType = Headers.formUrlEncodedContentType;

    _dio!.interceptors.addAll([
      LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          request: true),
      AppInterceptor(),
    ]);
  }

  factory RestClient() {
    return _instance;
  }

  Dio? dio() => _dio?..options.contentType = Headers.jsonContentType;

  Dio? dioByContentType(String contentType) =>
      _dio?..options.contentType = contentType;
}
