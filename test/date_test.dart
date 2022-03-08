import 'package:dart_date/dart_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('date 패키지 테스트', () {
    final now = DateTime.now();

    print(now.getDaysInMonth);
    print(now.startOfMonth);
    print(now.endOfMonth);
  });
}
