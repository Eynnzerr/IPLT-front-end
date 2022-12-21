import 'package:dio/dio.dart';
import 'package:learnflutter/config/log_utils.dart';
import 'package:learnflutter/data/bean/position.dart';
import 'package:learnflutter/utils/network/logging_interceptor.dart';
import 'package:learnflutter/utils/network/token_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HttpType { httpTypeGet, httpTypePost }

class Urls {
  static const testPos = '/pos/test';
  static const allPos = '/pos/all';
  static const batchPos = '/pos/batch';
  static const testRun = '/run/test';
  static const allRun = '/run/all';
  static const batchRun = '/run/batch';
  static const login = '/user/login/pwd';
  static const auth = '/user/register/auth';
  static const info = '/user/register/info';
  static const send = '/user/register/send';
}

// uniform encapsulation for responses of http requests.
// success signifies whether this request is successful.
// If true, data carries the requested entity; If false, msg carries the reason of error.
class HttpResponse<T> {
  bool success;
  String? err;
  T? data;

  HttpResponse(this.success, {this.err, this.data});
}

class DioClient {
  DioClient._internal() {
    LoggerUtils.d(_tag, 'client is initialized.');
  }

  static DioClient instance = DioClient._internal();
  static const _tag = 'DioClient';
  static const _baseUrl = 'http://192.168.2.161:8080';
  // static const _baseUrl = 'http://192.168.43.33:8080';

  final Dio _dio = Dio()
    ..interceptors.addAll([LoggingInterceptor(), TokenInterceptor()])
    ..options.baseUrl = _baseUrl;

  // login by username and password
  Future<bool> login(String name, String password) async {
    const url = Urls.login;
    FormData form = FormData.fromMap({
      'name': name,
      'password': password
    });
    Response response = await _post(url: url, data: form);

    // get token from json response and store in sharedPreferences
    Map<String, dynamic> result = response.data;
    int code = result['code'];
    if (code == 200) {
      String token = result['data'];
      final sp = await SharedPreferences.getInstance();
      sp.setString('token', token);
      return true;
    } else {
      LoggerUtils.d(_tag, 'Login response is received but is wrong.');
      return false;
    }
  }

  Future<HttpResponse<List<Position>>> getTestData() async {
    const url = Urls.testPos;
    Response response = await _get(url: url);

    Map<String, dynamic> result = response.data;
    int code = result['code'];
    if (code == 200) {
      List? positions = result['data'];
      if (positions == null) {
        return HttpResponse(false, err: 'The response is OK but no data is returned.');
      }

      final data = <Position>[];
      for (var posJson in positions) {
        data.add(Position.fromJson(posJson));
      }
      return HttpResponse(true, data: data);
    } else {
      return HttpResponse(false, err: 'wtf?');
    }
  }

  // Basic request method of Dio
  Future<Response> _get({required String url}) async {
    return await _sendHttpRequest(HttpType.httpTypeGet, url);
  }

  Future<Response> _post({required String url, Map<String, dynamic>? queryParameters, dynamic data}) async {
    return await _sendHttpRequest(HttpType.httpTypePost, url, queryParameters: queryParameters, data: data);
  }

  Future _sendHttpRequest(HttpType type, String url,
      {Map<String, dynamic>? queryParameters, dynamic data}) async {
    try {
      switch (type) {
        case HttpType.httpTypeGet:
          return await _dio.get(url);
        case HttpType.httpTypePost:
          return await _dio
              .post(url, queryParameters: queryParameters, data: data);
        default:
          throw Exception('Only GET and POST method are allowed!');
      }
    } on DioError catch (e) {
      LoggerUtils.d('dio', '$e');
    }
  }
}