import 'dart:async';

import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/domain/usecase/diary/load_all_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/util/filter.dart';
import 'package:daily_diary/service/logger_service.dart';
import 'package:flutter/material.dart';

import 'filter_state.dart';
import 'filter_event.dart';
import 'filter_ui_event.dart';

class FilterViewModel with ChangeNotifier {
  final LoadAllUseCase _loadAllUseCase;

  final _streamController = StreamController<FilterUiEvent>.broadcast();
  Stream<FilterUiEvent> get uiEventStream => _streamController.stream;

  FilterState _state = FilterState();
  FilterState get state => _state;

  FilterViewModel(this._loadAllUseCase) {
    _load('');
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void onEvent(FilterEvent event) {
    event.when(load: _load, changeEmo: _changeEmo);
  }

  void _changeEmo(int emoIndex) {
    _state = _state.copyWith(selectedIndex: emoIndex);
    notifyListeners();

    // 다시 로드
    _load(_state.query);
  }

  Future<void> _load(String query) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    // query == '' 일 때 생각해보기
    _state = _state.copyWith(query: query);
    final filter = Filter(query: _state.query, emoIndex: _state.selectedIndex);
    final result = await _loadAllUseCase(Data(filter));

    result.when(
      success: (diaries) {
        _state = _state.copyWith(diaries: diaries);
      },
      error: (message) {
        _streamController.add(FilterUiEvent.snackBar(message));
        LoggerService.instance.logger?.e(message);
      },
    );

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }
}

  // /// 필터 정보(쿼리, 이모지 인덱스)를 가지고 다이어리 리스트 로드
  // Future<void> _loadWithFilter(String query, int emoIndex) async {
  //   _state = _state.copyWith(isLoading: true);
  //   notifyListeners();

  //   final result =
  //       await _loadAllUseCase(Data(Filter(query: query, emoIndex: emoIndex)));

  //   result.when(
  //     success: (diaries) {
  //       _state = _state.copyWith(diaries: diaries);
  //     },
  //     error: (message) {
  //       _streamController
  //           .add(const CalendarUiEvent.snackBar('가져오기 실패. 다시 시도하세요.'));
  //     },
  //   );

  //   _state = _state.copyWith(isLoading: false);
  //   notifyListeners();
  // }
