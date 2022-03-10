import 'package:daily_diary/domain/model/backup/backup_item.dart';
import 'package:daily_diary/domain/model/backup/backup_data.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/repository/backup_repository.dart';

class BackupRepositoryImpl with BackupRepository {
  @override
  Future<Result<BackupData>> getBackupData() {
    // TODO: implement getBackupData
    throw UnimplementedError();
  }

  @override
  Future<Result<List<BackupItem>>> getBackupItemList() {
    // TODO: implement getBackupItemList
    throw UnimplementedError();
  }

  @override
  Future<Result<int>> saveBackupData(BackupData backupData) {
    // TODO: implement saveBackupData
    throw UnimplementedError();
  }
}
