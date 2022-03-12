import 'package:daily_diary/data/data_source/local/diary_local_data_source.dart';
import 'package:daily_diary/data/data_source/remote/backup_remote_data_source.dart';
import 'package:daily_diary/data/repository/backup_repository_impl.dart';
import 'package:daily_diary/data/repository/diary_repository_impl.dart';
import 'package:daily_diary/domain/repository/backup_repository.dart';
import 'package:daily_diary/domain/repository/diary_repository.dart';
import 'package:daily_diary/domain/usecase/backup/delete_backup_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/delete_all_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/delete_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/load_all_use_case.dart';
import 'package:daily_diary/domain/usecase/backup/load_backup_data_use_case.dart';
import 'package:daily_diary/domain/usecase/backup/load_backup_list_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/load_diaries_year_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/load_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/backup/resotre_backup_data_use_case.dart';
import 'package:daily_diary/domain/usecase/backup/save_backup_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/save_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/update_diary_use_case.dart';
import 'package:daily_diary/presenter/calendar/calendar_view_model.dart';
import 'package:daily_diary/service/sqflite_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<List<SingleChildWidget>> setProviders() async {
  // 로컬 sqlite 세팅
  await SqlService.instance.init();
  final db = SqlService.instance.db;

  if (db == null) {
    throw Exception('db 로딩 에러');
  }

  final List<SingleChildWidget> dataSources = [
    Provider(create: (context) => DiaryLocalDataSource(db)),
    Provider(create: (context) => BackupRemoteDataSource()),
  ];

  final List<SingleChildWidget> repositories = [
    ProxyProvider<DiaryLocalDataSource, DiaryRepository>(
        update: (context, dataSource, _) => DiaryRepositoryImpl(dataSource)),
    ProxyProvider<BackupRemoteDataSource, BackupRepository>(
        update: (context, dataSource, _) => BackupRepositoryImpl(dataSource)),
  ];

  final List<SingleChildWidget> usecases = [
    ProxyProvider<DiaryRepository, LoadAllUseCase>(
        update: (context, repository, _) => LoadAllUseCase(repository)),
    ProxyProvider<DiaryRepository, LoadDiariesYearUseCase>(
        update: (context, repository, _) => LoadDiariesYearUseCase(repository)),
    ProxyProvider<DiaryRepository, LoadDiaryUseCase>(
        update: (context, repository, _) => LoadDiaryUseCase(repository)),
    ProxyProvider<DiaryRepository, DeleteDiaryUseCase>(
        update: (context, repository, _) => DeleteDiaryUseCase(repository)),
    ProxyProvider<DiaryRepository, UpdateDiaryUseCase>(
        update: (context, repository, _) => UpdateDiaryUseCase(repository)),
    ProxyProvider<DiaryRepository, SaveDiaryUseCase>(
        update: (context, repository, _) => SaveDiaryUseCase(repository)),
    ProxyProvider<DiaryRepository, DeleteAllUseCase>(
        update: (context, repository, _) => DeleteAllUseCase(repository)),

    // 백업 데이터
    ProxyProvider<BackupRepository, SaveBackupUseCase>(
      update: (context, repository, _) => SaveBackupUseCase(
        repository,
        context.read<LoadAllUseCase>(),
      ),
    ),
    ProxyProvider<BackupRepository, LoadBackupListUseCase>(
      update: (context, repository, _) => LoadBackupListUseCase(repository),
    ),
    ProxyProvider<BackupRepository, LoadBackupDataUseCase>(
      update: (context, repository, _) => LoadBackupDataUseCase(repository),
    ),
    ProxyProvider<DiaryRepository, RestoreBackupDataUseCase>(
      update: (context, repository, _) => RestoreBackupDataUseCase(
        repository,
        context.read<LoadBackupDataUseCase>(),
      ),
    ),
    ProxyProvider<BackupRepository, DeleteBackupUseCase>(
      update: (context, repository, _) => DeleteBackupUseCase(repository),
    )
  ];

  final List<SingleChildWidget> viewModels = [
    ChangeNotifierProvider<CalendarViewModel>(
      create: (context) => CalendarViewModel(
        context.read<LoadDiariesYearUseCase>(),
        context.read<DeleteAllUseCase>(),
        context.read<SaveBackupUseCase>(),
        context.read<LoadBackupListUseCase>(),
        context.read<RestoreBackupDataUseCase>(),
        context.read<DeleteBackupUseCase>(),
      ),
    ),
  ];

  final List<SingleChildWidget> providers = [
    ...dataSources,
    ...repositories,
    ...usecases,
    ...viewModels,
  ];

  return providers;
}
