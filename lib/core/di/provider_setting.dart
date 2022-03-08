import 'package:daily_diary/data/data_source/local/diary_local_data_source.dart';
import 'package:daily_diary/data/repository/diary_repository_impl.dart';
import 'package:daily_diary/domain/repository/diary_repository.dart';
import 'package:daily_diary/domain/usecase/delete_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/load_all_use_case.dart';
import 'package:daily_diary/domain/usecase/load_diaries_year_use_case.dart';
import 'package:daily_diary/domain/usecase/load_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/save_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/update_diary_use_case.dart';
import 'package:daily_diary/presentation/calendar/calendar_view_model.dart';
import 'package:daily_diary/service/sqflite_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<List<SingleChildWidget>> setProviders() async {
  // TODO: 로컬 hive 세팅

  // 로컬 sqlite 세팅
  await SqlService.instance.init();
  final db = SqlService.instance.db;

  if (db == null) {
    throw Exception('db 로딩 에러');
  }

  final List<SingleChildWidget> dataSources = [
    Provider(create: (context) => DiaryLocalDataSource(db)),
  ];

  final List<SingleChildWidget> repositories = [
    ProxyProvider<DiaryLocalDataSource, DiaryRepository>(
        update: (context, dataSource, _) => DiaryRepositoryImpl(dataSource)),
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
  ];

  final List<SingleChildWidget> viewModels = [
    ChangeNotifierProvider<CalendarViewModel>(
      create: (context) => CalendarViewModel(
        context.read<LoadDiariesYearUseCase>(),
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
