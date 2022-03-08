import 'dart:async';

import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/domain/usecase/load_diaries_year_use_case.dart';
import 'package:daily_diary/service/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

import 'calendar_state.dart';
import 'calendar_event.dart';
import 'calendar_ui_event.dart';

class CalendarViewModel with ChangeNotifier {
  /// 유스케이스
  final LoadDiariesYearUseCase _loadDiariesYearUseCase;

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
  CalendarViewModel(this._loadDiariesYearUseCase) {
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
        load: _load, changeYear: _changeYear, delete: _delete, reset: _reset);
  }

  /// 연도 변경
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

    final result = await _loadDiariesYearUseCase(Data(_state.currentDate.year));
    result.when(
      success: (diaries) {
        _state = _state.copyWith(
          diaries: diaries,
        );
      },
      error: (message) {
        LoggerService.instance.logger?.e(message);
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

  /// 다이어리 리셋
  Future<void> _reset() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    // TODO: 데이터 리셋

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }
}
