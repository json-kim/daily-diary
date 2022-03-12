import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/model/backup/backup_item.dart';
import 'package:daily_diary/domain/model/diary/diary.dart';
import 'package:daily_diary/domain/repository/diary_repository.dart';
import 'package:daily_diary/domain/usecase/backup/load_backup_data_use_case.dart';

import '../usecase.dart';

class RestoreBackupDataUseCase extends UseCase<int, Data<BackupItem>> {
  final DiaryRepository _repository;
  final LoadBackupDataUseCase _loadBackupDataUseCase;

  RestoreBackupDataUseCase(
    this._repository,
    this._loadBackupDataUseCase,
  );

  @override
  Future<Result<int>> call(Data<BackupItem> param) async {
    final backupItem = param.data;
    final backupDiaries = await getBackupDiries(backupItem);

    final result = await _repository.restoreDiaries(backupDiaries);

    return result.when(
      success: (result) {
        return Result.success(result);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  Future<List<Diary>> getBackupDiries(BackupItem backupItem) async {
    final result = await _loadBackupDataUseCase(Data(backupItem));

    return result.when(
      success: (backupData) {
        return backupData.diaries;
      },
      error: (message) {
        throw Exception(message);
      },
    );
  }
}
