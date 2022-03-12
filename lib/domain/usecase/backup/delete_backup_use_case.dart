import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/model/backup/backup_item.dart';
import 'package:daily_diary/domain/repository/backup_repository.dart';

import '../usecase.dart';

class DeleteBackupUseCase implements UseCase<int, Data<BackupItem>> {
  final BackupRepository _repository;

  DeleteBackupUseCase(this._repository);

  @override
  Future<Result<int>> call(Data<BackupItem> param) async {
    final item = param.data;

    final result = await _repository.deleteBackup(item);

    return result.when(
      success: (delResult) {
        return Result.success(delResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}
