import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/data/data_source/local/entity/diary_local_entity.dart';
import 'package:daily_diary/service/sqflite_service.dart';
import 'package:sqflite/sqlite_api.dart';

class DiaryLocalDataSource {
  Database _db;

  DiaryLocalDataSource(this._db);

  /// 저장된 모든 다이어리 가져오기
  Future<Result<List<DiaryLocalEntity>>> getAllDiaries() async {
    // db 연결 안되어 있으면 에러
    if (!_db.isOpen) {
      return Result.error('$runtimeType:getAllDiaries : db is not open');
    }

    final List<Map<String, dynamic>> maps = await _db.query('diary');

    final entities = maps.map((e) => DiaryLocalEntity.fromJson(e)).toList();

    return Result.success(entities);
  }

  /// 현재 년도의 다이어리 가져오기
  Future<Result<List<DiaryLocalEntity>>> getDiariesYear(int year) async {
    if (!_db.isOpen) {
      return Result.error('$runtimeType:getDiariesYear : db is not open');
    }

    final List<Map<String, dynamic>> maps =
        await _db.query('diary', where: 'year = ?', whereArgs: [year]);

    final entities = maps.map((e) => DiaryLocalEntity.fromJson(e)).toList();

    return Result.success(entities);
  }

  /// 특정 날짜의 다이어리 가져오기
  Future<Result<DiaryLocalEntity>> getDiary(DateTime date) async {
    // db 연결 안되어 있으면 에러
    if (!_db.isOpen) {
      return Result.error('$runtimeType:getDiary : db is not open');
    }

    final List<Map<String, dynamic>> maps = await _db.query('diary',
        where: 'year = ? and month = ? and day = ?',
        whereArgs: [date.year, date.month, date.day]);

    if (maps.isEmpty) {
      return const Result.error('저장된 다이어리가 없습니다.');
    }
    final entity = DiaryLocalEntity.fromJson(maps.first);

    return Result.success(entity);
  }

  /// 다이어리 저장하기
  Future<Result<int>> saveDiary(DiaryLocalEntity diary) async {
    // db 연결 안되어 있으면 에러
    if (!await _isDatabaseOpen()) {
      return Result.error('$runtimeType:saveDiary : db is not open');
    }

    final result = await _db.insert('diary', diary.toJson());

    return Result.success(result);
  }

  /// 다이어리 삭제하기
  Future<Result<int>> deleteDiary(DateTime date) async {
    // db 연결 안되어 있으면 에러
    if (!await _isDatabaseOpen()) {
      return Result.error('$runtimeType:deleteDiary : db is not open');
    }

    final result = await _db.delete('diary',
        where: 'year = ? and month = ? and day = ?',
        whereArgs: [date.year, date.month, date.day]);

    return Result.success(result);
  }

  /// 다이어리 업데이트 하기
  Future<Result<int>> updateDiary(DiaryLocalEntity diary) async {
    // db 연결 안되어 있으면 에러
    if (!await _isDatabaseOpen()) {
      return Result.error('$runtimeType:updateDiary : db is not open');
    }

    final result = await _db.update('diary', diary.toJson(),
        where: 'id = ?', whereArgs: [diary.id]);

    return Result.success(result);
  }

  /// 다이어리 전부 삭제하기
  Future<Result<int>> deleteAll() async {
    // db 연결 안되어 있으면 에러
    if (!await _isDatabaseOpen()) {
      return Result.error('$runtimeType:deleteAll : db is not open');
    }

    final result = await _db.delete('diary');

    return Result.success(result);
  }

  /// db 연결 확인 & false => 다시 초기화
  Future<bool> _isDatabaseOpen() async {
    if (!_db.isOpen) {
      await SqlService.instance.init();
    }
    return true;
  }
}
