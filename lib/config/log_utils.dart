import 'package:logger/logger.dart';

class LoggerUtils {
  // verbose, flag = 1
  static void v(String tag, String msg) => getLogger().v('$tag: $msg');

  // debug, flag = 2
  static void d(String tag, String msg) => getLogger().d('$tag: $msg');

  // info, flag = 3
  static void i(String tag, String msg) => getLogger().i('$tag: $msg');

  // warning, flag = 4
  static void w(String tag, String msg) => getLogger().w('$tag: $msg');

  // error, flag = 5
  static void e(String tag, String msg) => getLogger().e('$tag: $msg');

  static Logger? _logger;
  static Logger getLogger() {
    _logger ??= Logger();
    return _logger!;
  }
}