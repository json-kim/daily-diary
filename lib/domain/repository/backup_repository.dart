import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/model/backup/backup_data.dart';
import 'package:daily_diary/domain/model/backup/backup_item.dart';

abstract class BackupRepository {
  Future<Result<List<BackupItem>>> getBackupItemList();

  Future<Result<BackupData>> getBackupData(String path);

  Future<Result<int>> saveBackupData(BackupData backupData);
}
