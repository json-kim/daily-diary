import 'package:logger/logger.dart';

class LoggerService {
  Logger? _logger;

  Logger? get logger => _logger;

  LoggerService._();

  static LoggerService _instance = LoggerService._();

  static LoggerService get instance => _instance;

  void init() {
    _logger = Logger();
  }
}
