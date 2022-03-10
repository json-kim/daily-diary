import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/data/data_source/remote/backup_remote_data_source.dart';
import 'package:daily_diary/domain/model/backup/backup_data.dart';
import 'package:daily_diary/domain/model/backup/backup_item.dart';
import 'package:daily_diary/domain/repository/backup_repository.dart';

class BackupRepositoryImpl with BackupRepository {
  final BackupRemoteDataSource _dataSource;

  BackupRepositoryImpl(this._dataSource);

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
  Future<Result<int>> saveBackupData(BackupData backupData) async {
    final result = await _dataSource.saveBackup(backupData);

    return result.when(
      success: (saveResult) {
        return Result.success(saveResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}
