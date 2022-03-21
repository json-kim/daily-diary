import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// 계층간 결과(result) 클래스
@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success; // 성공 시
  const factory Result.error(Exception exception) = Error; // 실패 시
}
