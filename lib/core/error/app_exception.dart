/// 앱에서 발생하는 모든 에러의 베이스 클래스
class AppException implements Exception {
  AppException(this.message);

  final String? message;
}
