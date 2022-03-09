import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/model/diary/diary.dart';

abstract class DiaryRepository {
  Future<Result<List<Diary>>> getAllDiaries();

  Future<Result<List<Diary>>> getDiariesByYear(int year);

  Future<Result<Diary>> getDiary(DateTime date);

  Future<Result<int>> deleteDiary(DateTime date);

  Future<Result<int>> updateDiary(Diary diary);

  Future<Result<int>> saveDairy(Diary diary);

  Future<Result<int>> deleteAll();
}
