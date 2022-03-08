import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/repository/diary_repository.dart';
import 'package:daily_diary/domain/usecase/usecase.dart';

class DeleteDiaryUseCase extends UseCase<int, Data<DateTime>> {
  final DiaryRepository _repository;

  DeleteDiaryUseCase(this._repository);

  @override
  Future<Result<int>> call(Data<DateTime> param) async {
    final date = param.data;

    final result = await _repository.deleteDiary(date);

    return result.when(success: (delResult) {
      return Result.success(delResult);
    }, error: (message) {
      return Result.error(message);
    });
  }
}
