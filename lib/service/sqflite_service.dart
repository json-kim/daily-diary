import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlService {
  Database? _db;

  Database? get db => _db;

  SqlService._();

  static SqlService _instance = SqlService._();

  static SqlService get instance => _instance;

  Future<void> init() async {
    // 데이터베이스 경로 가져오기
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'diary.db');
    await deleteDatabase(path); // 데이터 베이스 삭제 코드

    // 데이터베이스 열기
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
          CREATE TABLE diary(
            id TEXT PRIMARY KEY,
            content TEXT NOT NULL,
            uid TEXT NOT NULL,
            year INTEGER NOT NULL,
            month INTEGER NOT NULL,
            day INTEGER NOT NULL,
            emoIndex INTEGER NOT NULL
          )
          ''',
        );
      },
    );
  }
}
