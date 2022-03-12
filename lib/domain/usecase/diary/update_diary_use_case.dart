import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/model/diary/diary.dart';
import 'package:daily_diary/domain/repository/diary_repository.dart';
import 'package:daily_diary/domain/usecase/usecase.dart';

class UpdateDiaryUseCase extends UseCase<int, Data<Diary>> {
  final DiaryRepository _repository;

  UpdateDiaryUseCase(this._repository);

  @override
  Future<Result<int>> call(Data<Diary> param) async {
    final diary = param.data;

    final result = await _repository.updateDiary(diary);

    return result.when(
      success: (updateResult) {
        return Result.success(updateResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}
