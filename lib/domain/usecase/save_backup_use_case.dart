import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/model/backup/backup_data.dart';
import 'package:daily_diary/domain/model/diary/diary.dart';
import 'package:daily_diary/domain/repository/backup_repository.dart';
import 'package:daily_diary/domain/usecase/load_all_use_case.dart';

import 'usecase.dart';

/// 로컬에 저장된 다이어리 데이터 불러와서
/// 백업 데이터로 변환하여
/// 원격 서버에 저장
class SaveBackupUseCase extends UseCase<int, None> {
  final BackupRepository _repository;
  final LoadAllUseCase _loadAllUseCase;

  SaveBackupUseCase(this._repository, this._loadAllUseCase);

  @override
  Future<Result<int>> call(None param) async {
    final diaries = await _getAllDiaries();

    final backupData = BackupData(uploadDate: DateTime.now(), diaries: diaries);

    final result = await _repository.saveBackupData(backupData);

    return result.when(
      success: (saveResult) {
        return Result.success(saveResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  Future<List<Diary>> _getAllDiaries() async {
    final result = await _loadAllUseCase(const None());

    return result.when(
      success: (list) {
        return list;
      },
      error: (message) {
        throw Exception(message);
      },
    );
  }
}
