import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/model/diary/diary.dart';
import 'package:daily_diary/domain/repository/diary_repository.dart';
import 'package:daily_diary/domain/usecase/usecase.dart';

class LoadDiaryUseCase extends UseCase<Diary, Data<DateTime>> {
  final DiaryRepository _repository;

  LoadDiaryUseCase(this._repository);

  @override
  Future<Result<Diary>> call(Data<DateTime> param) async {
    final date = param.data;

    final result = await _repository.getDiary(date);

    return result.when(success: (diary) {
      return Result.success(diary);
    }, error: (message) {
      return Result.error(message);
    });
  }
}
