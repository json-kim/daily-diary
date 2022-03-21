import 'package:daily_diary/core/error/auth_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('error test', () {
    final AuthException authException =
        AuthException('원인', '페이스북', '아이디 비번 틀림');

    print(authException);
  });
}
