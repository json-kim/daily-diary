import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/model/diary/diary.dart';
import 'package:daily_diary/domain/repository/diary_repository.dart';
import 'package:daily_diary/domain/usecase/usecase.dart';

class DeleteDiaryUseCase extends UseCase<int, Data<Diary>> {
  final DiaryRepository _repository;

  DeleteDiaryUseCase(this._repository);

  @override
  Future<Result<int>> call(Data<Diary> param) async {
    final diary = param.data;

    final result = await _repository.deleteDiary(diary);

    return result.when(success: (delResult) {
      return Result.success(delResult);
    }, error: (message) {
      return Result.error(message);
    });
  }
}
