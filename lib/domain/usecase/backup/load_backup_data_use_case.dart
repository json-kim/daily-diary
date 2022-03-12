import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/model/backup/backup_data.dart';
import 'package:daily_diary/domain/model/backup/backup_item.dart';
import 'package:daily_diary/domain/repository/backup_repository.dart';

import '../usecase.dart';

class LoadBackupDataUseCase extends UseCase<BackupData, Data<BackupItem>> {
  final BackupRepository _repository;

  LoadBackupDataUseCase(this._repository);

  @override
  Future<Result<BackupData>> call(Data<BackupItem> param) async {
    final backupItem = param.data;
    final path = backupItem.path;

    final result = await _repository.getBackupData(path);

    return result.when(
      success: (backupData) {
        return Result.success(backupData);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}
