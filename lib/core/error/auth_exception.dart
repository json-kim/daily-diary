import 'package:daily_diary/core/error/app_exception.dart';

/// 인증(로그인)시 발생하는 에러
class AuthException extends AppException {
  AuthException(this.errorCause, this.authType, this.message) : super(message);

  final String? message; // 에러 메시지
  final String errorCause; // 에러 원인
  final String authType; // 인증 방법

  @override
  String toString() {
    return '''
    AuthException: {
      authType: $authType, 
      errorCause: $errorCause, 
      message: $message
    }
    ''';
  }
}
