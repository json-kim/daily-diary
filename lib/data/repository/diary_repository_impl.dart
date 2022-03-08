import 'package:daily_diary/data/data_source/local/entity/diary_local_entity.dart';

import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/data/data_source/local/diary_local_data_source.dart';
import 'package:daily_diary/domain/model/diary/diary.dart';
import 'package:daily_diary/domain/repository/diary_repository.dart';

class DiaryRepositoryImpl with DiaryRepository {
  final DiaryLocalDataSource _dataSource;

  DiaryRepositoryImpl(this._dataSource);

  @override
  Future<Result<int>> deleteDiary(DateTime date) async {
    final result = await _dataSource.deleteDiary(date);

    return result.when(
      success: (deleteResult) {
        return Result.success(deleteResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<List<Diary>>> getAllDiaries() async {
    final result = await _dataSource.getAllDiaries();

    return result.when(
      success: (list) {
        final List<Diary> diaries =
            list.map((entity) => entity.toDiary()).toList();

        return Result.success(diaries);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<Diary>> getDiary(DateTime date) async {
    final result = await _dataSource.getDiary(date);

    return result.when(
      success: (entity) {
        return Result.success(entity.toDiary());
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<int>> saveDairy(Diary diary) async {
    final entity = DiaryLocalEntity.fromDiary(diary);

    final result = await _dataSource.saveDiary(entity);

    return result.when(
      success: (saveResult) {
        return Result.success(saveResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<int>> updateDiary(Diary diary) async {
    final entity = DiaryLocalEntity.fromDiary(diary);

    final result = await _dataSource.updateDiary(entity);

    return result.when(
      success: (updateResult) {
        return Result.success(updateResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<List<Diary>>> getDiariesByYear(int year) async {
    final result = await _dataSource.getDiariesYear(year);

    return result.when(
      success: (list) {
        final diaries = list.map((e) => e.toDiary()).toList();

        return Result.success(diaries);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}
