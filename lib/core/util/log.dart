// coverage:ignore-file
import 'package:logger/logger.dart';

class Log {
  static final Log _instance = Log._internal();
  late final Logger _logger;

  factory Log() => _instance;

  Log._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  /// Debug logs
  static void debug(dynamic message) => _instance._logger.d(message);

  /// Info logs
  static void info(dynamic message) => _instance._logger.i(message);

  /// Warning logs
  static void warning(dynamic message) => _instance._logger.w(message);

  /// Error logs with optional stacktrace
  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _instance._logger.e(message, error: error, stackTrace: stackTrace);

  /// Verbose / fine-grained logs
  static void verbose(dynamic message) => _instance._logger.t(message);

  /// WTF-level logs (critical)
  static void wtf(dynamic message) => _instance._logger.f(message);
}