import 'package:dio/dio.dart';

/// Interceptor for the app
class AppInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({'Accept': 'application/json'});

    ///Add auth token
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      ///Logout
      // await SharedPreferencesUtils().clear();
    }
    super.onError(err, handler);
  }
}
