import 'dart:async';

import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/domain/model/backup/backup_item.dart';
import 'package:daily_diary/domain/usecase/backup/delete_backup_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/delete_all_use_case.dart';
import 'package:daily_diary/domain/usecase/backup/load_backup_list_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/load_diaries_year_use_case.dart';
import 'package:daily_diary/domain/usecase/backup/resotre_backup_data_use_case.dart';
import 'package:daily_diary/domain/usecase/backup/save_backup_use_case.dart';
import 'package:daily_diary/service/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

import 'calendar_state.dart';
import 'calendar_event.dart';
import 'calendar_ui_event.dart';

class CalendarViewModel with ChangeNotifier {
  /// 유스케이스
  final LoadDiariesYearUseCase _loadDiariesYearUseCase;
  final DeleteAllUseCase _deleteAllUseCase;
  final SaveBackupUseCase _saveBackupUseCase;
  final LoadBackupListUseCase _loadBackupListUseCase;
  final RestoreBackupDataUseCase _restoreBackupDataUseCase;
  final DeleteBackupUseCase _deleteBackupDataUseCase;

  /// ui event 스트림 컨트롤러 (viewModel => view)
  final _streamController = StreamController<CalendarUiEvent>.broadcast();
  Stream<CalendarUiEvent> get uiEventStream => _streamController.stream;

  /// 상태
  CalendarState _state = CalendarState(currentDate: DateTime.now());
  CalendarState get state => _state;

  List<int> get dates {
    return List.generate(12,
        (index) => DateTime(_state.currentDate.year, index + 1).getDaysInMonth);
  }

  /// 생성자 (_load 호출)
  CalendarViewModel(
    this._loadDiariesYearUseCase,
    this._deleteAllUseCase,
    this._saveBackupUseCase,
    this._loadBackupListUseCase,
    this._restoreBackupDataUseCase,
    this._deleteBackupDataUseCase,
  ) {
    _load();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  /// 이벤트 리스너 등록 (view => viewModel)
  void onEvent(CalendarEvent event) {
    event.when(
      load: _load,
      changeYear: _changeYear,
      delete: _delete,
      reset: _reset,
      backup: _backup,
      loadBackupList: _loadBackupList,
      restoreBackupData: _restoreBackupData,
      deleteBackupData: _deleteBackupData,
    );
  }

  /// 연도 변경 콜백
  void _changeYear(bool up) {
    // 연도 변경 (+1, -1)
    if (up) {
      _state = _state.copyWith(currentDate: _state.currentDate.addYears(1));
    } else {
      _state = _state.copyWith(currentDate: _state.currentDate.subYears(1));
    }

    // 데이터 다시 로드
    _load();
  }

  /// 현재 연도의 다이어리 리스트 로드
  Future<void> _load() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    // 다이어리 가져오기 (현재 연도)
    final result = await _loadDiariesYearUseCase(Data(_state.currentDate.year));
    result.when(
      success: (diaries) {
        // 상태 변경
        _state = _state.copyWith(
          diaries: diaries,
        );
      },
      error: (message) {
        // 실패시 에러 메시지 출력
        LoggerService.instance.logger?.e(message);

        // 실패 메시지 화면 표시
        _streamController.add(const CalendarUiEvent.snackBar('불러오기 실패'));
      },
    );

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }

  /// 다이어리 삭제
  Future<void> _delete(DateTime date) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    // TODO: 삭제 후

    // 데이터 다시 로드
    _load();
  }

  /// 다이어리 리셋 콜백 함수
  Future<void> _reset() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    // 데이터 리셋
    final result = await _deleteAllUseCase(const None());

    result.when(
      success: (delResult) {
        // 리셋 메시지
        _streamController.add(const CalendarUiEvent.snackBar('리셋 되었습니다.'));

        // 리셋 후 데이터 다시 로드
        _load();
      },
      error: (message) {
        // 에러 메시지 출력
        LoggerService.instance.logger?.e(message);

        // 실패 메시지 화면 표시
        _streamController.add(const CalendarUiEvent.snackBar('리셋 실패!'));
      },
    );

    _streamController.add(const CalendarUiEvent.toggleDrawer(false));

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }

  /// 백업 저장 이벤트 콜백 함수
  Future<void> _backup() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _saveBackupUseCase(const None());

    result.when(
      success: (_) {
        _streamController.add(const CalendarUiEvent.snackBar('백업 저장에 성공했습니다.'));
      },
      error: (message) {
        LoggerService.instance.logger?.e(message);
        _streamController
            .add(const CalendarUiEvent.snackBar('백업 데이터 저장에 실패했습니다.'));
      },
    );

    _streamController.add(const CalendarUiEvent.toggleDrawer(false));

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }

  /// 백업리스트 로딩 이벤트 콜백 함수
  Future<void> _loadBackupList() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _loadBackupListUseCase(const None());

    result.when(
      success: (list) {
        _streamController.add(CalendarUiEvent.showBackupList(list));
      },
      error: (message) {
        LoggerService.instance.logger?.e(message);
      },
    );

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }

  /// 백업 데이터 적용 이벤트 콜백 함수
  Future<void> _restoreBackupData(BackupItem backupItem) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _restoreBackupDataUseCase(Data(backupItem));

    result.when(
      success: (_) {
        // 백업 적용 후 다시 로드
        _load();

        _streamController
            .add(const CalendarUiEvent.snackBar('백업 데이터 적용 성공했습니다.'));
      },
      error: (message) {
        LoggerService.instance.logger?.e(message);

        _streamController
            .add(const CalendarUiEvent.snackBar('백업 실패. 다시 시도해 보세요.'));
      },
    );

    _streamController.add(const CalendarUiEvent.toggleDrawer(false));

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }

  /// 백업 데이터 삭제 이벤트 콜백 함수
  Future<void> _deleteBackupData(BackupItem backupItem) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _deleteBackupDataUseCase(Data(backupItem));

    result.when(
      success: (_) {
        _streamController.add(const CalendarUiEvent.toggleDrawer(false));
        _streamController.add(const CalendarUiEvent.snackBar('삭제 되었습니다.'));
      },
      error: (message) {
        LoggerService.instance.logger?.e(message);

        _streamController
            .add(const CalendarUiEvent.snackBar('백업 데이터 삭제 실패. 다시 시도해보세요'));
      },
    );

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }
}
