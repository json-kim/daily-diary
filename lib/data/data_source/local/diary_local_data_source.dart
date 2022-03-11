import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/data/data_source/local/entity/diary_local_entity.dart';
import 'package:daily_diary/service/sqflite_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqlite_api.dart';

class DiaryLocalDataSource {
  Database _db;

  DiaryLocalDataSource(this._db);

  String getUid() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception('로그인 필요');
    }

    return currentUser.uid;
  }

  /// 저장된 모든 다이어리 가져오기
  Future<Result<List<DiaryLocalEntity>>> getAllDiaries() async {
    // db 연결 안되어 있으면 에러
    if (!_db.isOpen) {
      return Result.error('$runtimeType:getAllDiaries : db is not open');
    }

    final List<Map<String, dynamic>> maps =
        await _db.query('diary', where: 'uid = ?', whereArgs: [getUid()]);

    final entities = maps.map((e) => DiaryLocalEntity.fromJson(e)).toList();

    return Result.success(entities);
  }

  /// 현재 년도의 다이어리 가져오기
  Future<Result<List<DiaryLocalEntity>>> getDiariesYear(int year) async {
    if (!_db.isOpen) {
      return Result.error('$runtimeType:getDiariesYear : db is not open');
    }

    final List<Map<String, dynamic>> maps = await _db.query('diary',
        where: 'year = ? and uid = ?', whereArgs: [year, getUid()]);

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
        where: 'uid = ? and year = ? and month = ? and day = ?',
        whereArgs: [getUid(), date.year, date.month, date.day]);

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
  Future<Result<int>> deleteDiary(String id) async {
    // db 연결 안되어 있으면 에러
    if (!await _isDatabaseOpen()) {
      return Result.error('$runtimeType:deleteDiary : db is not open');
    }

    final result = await _db.delete('diary', where: 'id = ?', whereArgs: [id]);

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

    final result =
        await _db.delete('diary', where: 'uid = ?', whereArgs: [getUid()]);

    return Result.success(result);
  }

  /// 다이어리 리스트 저장하기
  Future<Result<int>> saveDiaries(List<DiaryLocalEntity> diaries) async {
    if (!await _isDatabaseOpen()) {
      return Result.error('$runtimeType:deleteAll : db is not open');
    }

    final valueString = diaries.map((entity) => entity.toRawValues()).join(',');

    final result = await _db.rawInsert('''
    INSERT INTO diary
      (id, content, emoIndex, year, month, day)
    VALUES
      $valueString
    ''');

    return Result.success(diaries.length);
  }

  /// 백업 데이터로 db 초기화
  Future<Result<int>> restoreDiaries(List<DiaryLocalEntity> diaries) async {
    if (!await _isDatabaseOpen()) {
      return Result.error('$runtimeType:deleteAll : db is not open');
    }

    final valueString = diaries.map((entity) => entity.toRawValues()).join(',');

    final batch = _db.batch();
    batch.delete('diary', where: 'uid = ?', whereArgs: [getUid()]);
    batch.rawInsert('''
    INSERT INTO diary
      (id, content, uid, emoIndex, year, month, day)
    VALUES
      $valueString
    ''');

    await batch.commit();

    return const Result.success(1);
  }

  /// db 연결 확인 & false => 다시 초기화
  Future<bool> _isDatabaseOpen() async {
    if (!_db.isOpen) {
      await SqlService.instance.init();
    }
    return true;
  }
}
