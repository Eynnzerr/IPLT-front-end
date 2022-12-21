import 'package:dio/dio.dart';
import 'package:learnflutter/config/log_utils.dart';

class LoggingInterceptor extends Interceptor {

  static const _tag = 'Network Logger';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    StringBuffer sb = StringBuffer()
      ..writeln('sending new request ${options.method.toUpperCase()} url: ${options.baseUrl + options.path}')
      ..write('headers: ')
      ..writeAll(options.headers.entries)
      ..write('\nqueryParameters(null if empty): ')
      ..writeAll(options.queryParameters.entries)
      ..writeln('\nrequest body: ${options.data?.toString()??"no data"}')
      ..write('end of request.');
    LoggerUtils.d(_tag, sb.toString());
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    var response = err.response;
    StringBuffer sb = StringBuffer()
      ..writeln('new network error!')
      ..write('message: ${err.message}')
      ..writeln('url: ${response?.requestOptions.baseUrl}${response?.requestOptions.path}')
      ..writeln('error response: ${response?.data.toString()}')
      ..write('end of error.');
    LoggerUtils.d(_tag, sb.toString());
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    StringBuffer sb = StringBuffer()
      ..writeln('receiving new response ${response.statusCode} url: ${response.requestOptions.baseUrl + response.requestOptions.path}')
      ..write('headers: ')
      ..writeAll(response.headers.map.entries)
      ..writeln('\nresponse data: ')
      ..writeln(response.data.toString())
      ..write('end of response.');
    LoggerUtils.d(_tag, sb.toString());
    handler.next(response);
  }
}