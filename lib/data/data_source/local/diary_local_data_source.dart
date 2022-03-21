import 'package:daily_diary/core/error/auth_exception.dart';
import 'package:daily_diary/core/error/error_api.dart';
import 'package:daily_diary/core/error/local_db_exception.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/data/data_source/local/entity/diary_local_entity.dart';
import 'package:daily_diary/service/logger_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqlite_api.dart';

class DiaryLocalDataSource {
  final Database _db;
  final Logger _logger = LoggerService.instance.logger ?? Logger();

  DiaryLocalDataSource(this._db);

  String _getUid() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw AuthException(
          'currentuser is null', 'FIREBASE AUTH', 'login is needed');
    }

    return currentUser.uid;
  }

  /// db에 연결되어 있는지 체크
  Future<void> _dbOpenCheck() async {
    // db 연결 안되어 있으면 에러
    if (!_db.isOpen) {
      throw LocalDbException(
          DbErrorCause.NOT_OPENDED, 'SQLITE', 'db is not open');
    }
  }

  /// 저장된 모든 다이어리 가져오기
  Future<Result<List<DiaryLocalEntity>>> getAllDiaries() async {
    return ErrorApi.handleLocalDbError(() async {
      await _dbOpenCheck();

      // db에서 데이터 가져오기
      final List<Map<String, dynamic>> maps =
          await _db.query('diary', where: 'uid = ?', whereArgs: [_getUid()]);

      final entities = maps.map((e) => DiaryLocalEntity.fromJson(e)).toList();

      return Result.success(entities);
    }, _logger, '$runtimeType.getAllDiaries');
  }

  /// 현재 년도의 다이어리 가져오기
  Future<Result<List<DiaryLocalEntity>>> getDiariesYear(int year) async {
    return ErrorApi.handleLocalDbError(() async {
      await _dbOpenCheck();

      // db에서 데이터 가져오기
      final List<Map<String, dynamic>> maps = await _db.query('diary',
          where: 'year = ? and uid = ?', whereArgs: [year, _getUid()]);

      final entities = maps.map((e) => DiaryLocalEntity.fromJson(e)).toList();

      return Result.success(entities);
    }, _logger, '$runtimeType.getDiariesYear');
  }

  /// 특정 날짜의 다이어리 가져오기
  Future<Result<DiaryLocalEntity>> getDiary(DateTime date) async {
    return ErrorApi.handleLocalDbError(() async {
      await _dbOpenCheck();

      // db에서 데이터 가져오기
      final List<Map<String, dynamic>> maps = await _db.query('diary',
          where: 'uid = ? and year = ? and month = ? and day = ?',
          whereArgs: [_getUid(), date.year, date.month, date.day]);

      // 저장된 값이 없다면 에러
      if (maps.isEmpty) {
        throw LocalDbException(DbErrorCause.EMPTY, 'SQLITE', 'no saved data');
      }

      final entity = DiaryLocalEntity.fromJson(maps.first);

      return Result.success(entity);
    }, _logger, '$runtimeType.getDiary');
  }

  /// 다이어리 저장하기
  Future<Result<int>> saveDiary(DiaryLocalEntity diary) async {
    return ErrorApi.handleLocalDbError(() async {
      await _dbOpenCheck();

      // db에 데이터 저장
      final result = await _db.insert('diary', diary.toJson());

      return Result.success(result);
    }, _logger, '$runtimeType.saveDiary');
  }

  /// 다이어리 삭제하기
  Future<Result<int>> deleteDiary(String id) async {
    return ErrorApi.handleLocalDbError(() async {
      await _dbOpenCheck();

      // db에서 데이터 삭제
      final result =
          await _db.delete('diary', where: 'id = ?', whereArgs: [id]);

      return Result.success(result);
    }, _logger, '$runtimeType.deleteDiary');
  }

  /// 다이어리 업데이트 하기
  Future<Result<int>> updateDiary(DiaryLocalEntity diary) async {
    return ErrorApi.handleLocalDbError(() async {
      await _dbOpenCheck();

      // db에 데이터 업데이트 하기
      final result = await _db.update('diary', diary.toJson(),
          where: 'id = ?', whereArgs: [diary.id]);

      return Result.success(result);
    }, _logger, '$runtimeType.updateDiary');
  }

  /// 다이어리 전부 삭제하기
  Future<Result<int>> deleteAll() async {
    return ErrorApi.handleLocalDbError(() async {
      await _dbOpenCheck();

      // db에서 데이터 전부 삭제
      final result =
          await _db.delete('diary', where: 'uid = ?', whereArgs: [_getUid()]);

      return Result.success(result);
    }, _logger, '$runtimeType.deleteAll');
  }

  /// 다이어리 리스트 저장하기
  Future<Result<int>> saveDiaries(List<DiaryLocalEntity> diaries) async {
    return ErrorApi.handleLocalDbError(() async {
      await _dbOpenCheck();

      final valueString =
          diaries.map((entity) => entity.toRawValues()).join(',');

      final result = await _db.rawInsert('''
      INSERT INTO diary
        (id, content, emoIndex, year, month, day)
      VALUES
        $valueString
      ''');

      return Result.success(diaries.length);
    }, _logger, '$runtimeType.saveDiaries');
  }

  /// 백업 데이터로 db 초기화
  Future<Result<int>> restoreDiaries(List<DiaryLocalEntity> diaries) async {
    return ErrorApi.handleLocalDbError(() async {
      await _dbOpenCheck();

      final batch = _db.batch();
      batch.delete('diary', where: 'uid = ?', whereArgs: [_getUid()]);

      if (diaries.isNotEmpty) {
        final valueString =
            diaries.map((entity) => entity.toRawValues()).join(',');
        batch.rawInsert('''
        INSERT INTO diary
          (id, content, uid, emoIndex, year, month, day)
        VALUES
          $valueString
        ''');
      }

      await batch.commit();

      return const Result.success(1);
    }, _logger, '$runtimeType.restoreDiaries');
  }
}
