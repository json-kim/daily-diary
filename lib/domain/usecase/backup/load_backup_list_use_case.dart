import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/model/backup/backup_item.dart';
import 'package:daily_diary/domain/repository/backup_repository.dart';

import '../usecase.dart';

class LoadBackupListUseCase extends UseCase<List<BackupItem>, None> {
  final BackupRepository _repository;

  LoadBackupListUseCase(this._repository);

  @override
  Future<Result<List<BackupItem>>> call(None param) async {
    final result = await _repository.getBackupItemList();

    return result.when(
      success: (list) {
        // 날짜 순으로 내림차순 정렬
        list.sort((a, b) => -a.uploadDate.compareTo(b.uploadDate));
        return Result.success(list);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}
