import 'package:daily_diary/core/error/app_exception.dart';

/// 로컬 db 사용시 발생하는 에러
class LocalDbException extends AppException {
  LocalDbException(this.errorCause, this.dbType, this.message) : super(message);

  final DbErrorCause errorCause; // 에러 원인(메소드)
  final String dbType; // db 타입
  final String? message; // 에러 메시지

  @override
  String toString() {
    return '''
    LocalDbException: {
      dbType: $dbType, 
      errorCause: $errorCause, 
      message: $message
      }
      ''';
  }
}

enum DbErrorCause {
  NOT_OPENDED,
  REQUEST_DENIED,
  EMPTY,
}

enum DbType {
  SQLITE,
  HIVE,
}
