import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/model/diary/diary.dart';
import 'package:daily_diary/domain/repository/diary_repository.dart';
import 'package:daily_diary/domain/usecase/diary/util/filter.dart';
import 'package:daily_diary/domain/usecase/usecase.dart';

class LoadAllUseCase extends UseCase<List<Diary>, Param<Filter>> {
  final DiaryRepository _repository;

  LoadAllUseCase(this._repository);

  @override
  Future<Result<List<Diary>>> call(Param<Filter> param) async {
    final result = await _repository.getAllDiaries();

    return result.when(
      success: (diaries) {
        return param.when(data: (filter) {
          return Result.success(
            diaries
                .where(
                  (diary) =>
                      diary.emoIndex == filter.emoIndex &&
                      diary.content.contains(filter.query),
                )
                .toList(),
          );
        }, none: () {
          return Result.success(diaries);
        });
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}
