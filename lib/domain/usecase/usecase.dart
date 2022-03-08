import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/core/result/result.dart';

/// UseCase 추상 클래스
abstract class UseCase<DataType, ParamType extends Param> {
  Future<Result<DataType>> call(ParamType param);
}
