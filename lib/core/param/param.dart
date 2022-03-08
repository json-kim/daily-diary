import 'package:freezed_annotation/freezed_annotation.dart';

part 'param.freezed.dart';

/// 계층간 파리마터(parameter) 클래스
@freezed
class Param<T> with _$Param<T> {
  const factory Param.data(T data) = Data; // 데이터 파라미터
  const factory Param.none() = None; // 빈 파라미터
}
