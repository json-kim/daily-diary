import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/repository/diary_repository.dart';

import '../usecase.dart';

class DeleteAllUseCase extends UseCase<int, None> {
  final DiaryRepository _repository;

  DeleteAllUseCase(this._repository);

  @override
  Future<Result<int>> call(None param) async {
    final result = await _repository.deleteAll();

    return result.when(
      success: (delResult) {
        return Result.success(delResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}
