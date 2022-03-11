import 'package:daily_diary/data/data_source/local/entity/diary_local_entity.dart';

import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/data/data_source/local/diary_local_data_source.dart';
import 'package:daily_diary/domain/model/diary/diary.dart';
import 'package:daily_diary/domain/repository/diary_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiaryRepositoryImpl with DiaryRepository {
  final DiaryLocalDataSource _dataSource;

  DiaryRepositoryImpl(this._dataSource);

  String getUid() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception('로그인 필요');
    }

    return currentUser.uid;
  }

  @override
  Future<Result<int>> deleteDiary(Diary diary) async {
    final result = await _dataSource.deleteDiary(diary.id);

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
    final entity = DiaryLocalEntity.fromDiary(diary, getUid());

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
    final entity = DiaryLocalEntity.fromDiary(diary, getUid());

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

  @override
  Future<Result<int>> deleteAll() async {
    final result = await _dataSource.deleteAll();

    return result.when(
      success: (delResult) {
        return Result.success(delResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<int>> saveDairies(List<Diary> diaries) async {
    final entities = diaries
        .map((diary) => DiaryLocalEntity.fromDiary(diary, getUid()))
        .toList();

    final result = await _dataSource.saveDiaries(entities);

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
  Future<Result<int>> restoreDiaries(List<Diary> diaries) async {
    final entities = diaries
        .map((diary) => DiaryLocalEntity.fromDiary(diary, getUid()))
        .toList();

    final result = await _dataSource.restoreDiaries(entities);

    return result.when(
      success: (restoreResult) {
        return Result.success(restoreResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}
