import 'package:daily_diary/data/data_source/local/diary_local_data_source.dart';
import 'package:daily_diary/data/data_source/local/entity/diary_local_entity.dart';
import 'package:daily_diary/service/logger_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('로컬 데이터 소스 테스트 합니다.', () async {
    LoggerService.instance.init();
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

    await db.execute(
      '''
          CREATE TABLE diary(
            id TEXT PRIMARY KEY,
            content TEXT NOT NULL,
            year INTEGER NOT NULL,
            month INTEGER NOT NULL,
            day INTEGER NOT NULL,
            emoIndex INTEGER NOT NULL
          )
          ''',
    );

    final dataSource = DiaryLocalDataSource(db);

    final result1 = await dataSource.saveDiary(entity);

    result1.when(
      success: (result) {
        LoggerService.instance.logger?.i(result);
      },
      error: (message) {
        LoggerService.instance.logger?.e(message);
      },
    );

    final result2 = await dataSource.getAllDiaries();

    result2.when(success: (list) {
      LoggerService.instance.logger?.i(list);
    }, error: (message) {
      LoggerService.instance.logger?.e(message);
    });

    final result4 = await dataSource.updateDiary(entity2);
    final result5 = await dataSource.deleteDiary(DateTime(2022, 12, 21));
    final result3 = await dataSource.getDiariesYear(2022);

    result3.when(success: (list) {
      LoggerService.instance.logger?.i(list);
    }, error: (message) {
      LoggerService.instance.logger?.e(message);
    });
  });
}

final entity = DiaryLocalEntity(
    id: 'testid',
    content: 'hihihihihihi',
    emoIndex: 0,
    year: 2022,
    month: 12,
    day: 21);

final entity2 = DiaryLocalEntity(
    id: 'testid',
    content: 'hohohoho',
    emoIndex: 1,
    year: 2022,
    month: 12,
    day: 21);
