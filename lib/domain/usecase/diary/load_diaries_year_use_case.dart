import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/model/diary/diary.dart';
import 'package:daily_diary/domain/repository/diary_repository.dart';
import 'package:daily_diary/domain/usecase/usecase.dart';

class LoadDiariesYearUseCase extends UseCase<List<Diary>, Data<int>> {
  final DiaryRepository _repository;

  LoadDiariesYearUseCase(this._repository);

  @override
  Future<Result<List<Diary>>> call(Data<int> param) async {
    final year = param.data;

    final result = await _repository.getDiariesByYear(year);

    return result.when(
      success: (diaries) {
        return Result.success(diaries);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}
