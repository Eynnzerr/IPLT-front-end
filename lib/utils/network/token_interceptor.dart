import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptor extends Interceptor {

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!options.path.startsWith('/user')) {
      final sp = await SharedPreferences.getInstance();
      options.headers.putIfAbsent('token', () => sp.getString('token'));
    }

    handler.next(options);
  }
}