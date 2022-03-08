import 'dart:async';

import 'package:daily_diary/core/param/param.dart';
import 'package:daily_diary/domain/model/diary/diary.dart';
import 'package:daily_diary/domain/usecase/delete_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/load_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/save_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/update_diary_use_case.dart';
import 'package:daily_diary/service/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'edit_state.dart';
import 'edit_event.dart';
import 'edit_ui_event.dart';

class EditViewModel with ChangeNotifier {
  /// 유스케이스
  final SaveDiaryUseCase _saveDiaryUseCase; // 다이어리 저장
  final UpdateDiaryUseCase _updateDiaryUseCase; // 다이어리 업데이트
  final LoadDiaryUseCase _loadDiaryUseCase; // 다이어리 로드(현재 날짜)
  final DeleteDiaryUseCase _deleteDiaryUseCase; // 다이어리 삭제(현재 날짜)

  /// 이미 저장된 다이어리 (null일 시 새로 저장)
  Diary? _diary;

  /// 다이어리 id 생성 클래스
  final _uuid = Uuid();

  /// ui 이벤트 스트림 컨트롤러 (뷰모델 => 뷰)
  final _streamController = StreamController<EditUiEvent>.broadcast();
  Stream<EditUiEvent> get uiEventStream => _streamController.stream;

  /// 상태
  EditState _state;
  EditState get state => _state;

  /// 생성자 (유스케이스, 현재 날짜) : 상태 초기화 => 다이어리 로드
  EditViewModel(
    this._saveDiaryUseCase,
    this._updateDiaryUseCase,
    this._loadDiaryUseCase,
    this._deleteDiaryUseCase,
    DateTime selectedDate,
  ) : _state = EditState(
          selectedDate: selectedDate,
          emoIndex: 0,
          content: '',
        ) {
    _load();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  /// 이벤트 리스너 등록 (뷰 => 뷰모델)
  void onEvent(EditEvent event) {
    event.when(
      modeChange: _modeChange,
      load: _load,
      changeDate: _changeDate,
      setEmoData: _setEmoData,
      save: _save,
      delete: _delete,
    );
  }

  /// 수정, 뷰 모드 변경
  void _modeChange(bool isEditMode) {
    _state = _state.copyWith(isEditMode: isEditMode);

    notifyListeners();
  }

  /// 날짜 변경
  void _changeDate(DateTime pickedDate) async {
    _state = _state.copyWith(selectedDate: pickedDate);

    _load();
  }

  /// 감정 변경
  void _setEmoData(int emoIndex) {
    _state = _state.copyWith(emoIndex: emoIndex);
    notifyListeners();
  }

  /// 다이어리 저장하기 (이미 있다면 업데이트)
  Future<void> _save(String message) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final newId = _diary?.id ?? _uuid.v4();
    final newDiary = Diary(
      id: newId,
      date: _state.selectedDate,
      content: message,
      emoIndex: _state.emoIndex,
    );

    if (_diary == null) {
      final result = await _saveDiaryUseCase(Data(newDiary));
      result.when(
        success: (saveResult) {
          _streamController.add(const EditUiEvent.snackBar('저장 성공'));
          _state = _state.copyWith(isEditMode: false);

          // 다시 불러오기
          _load();
        },
        error: (message) {
          LoggerService.instance.logger?.e(message);
          _streamController.add(const EditUiEvent.snackBar('저장 실패'));
        },
      );
    } else {
      final result = await _updateDiaryUseCase(Data(newDiary));
      result.when(
        success: (updateResult) {
          _streamController.add(const EditUiEvent.snackBar('저장 성공'));
          _state = _state.copyWith(isEditMode: false);

          // 다시 불러오기
          _load();
        },
        error: (message) {
          LoggerService.instance.logger?.e(message);
          _streamController.add(const EditUiEvent.snackBar('저장 실패'));
        },
      );
    }
  }

  /// 다이어리 불러오기 (현재 날짜)
  Future<void> _load() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _loadDiaryUseCase(Data(_state.selectedDate));

    result.when(
      success: (diary) {
        // 불러오기 성공 시, 상태 업데이트
        _diary = diary;
        _state = _state.copyWith(
          isEditMode: false,
          selectedDate: diary.date,
          emoIndex: diary.emoIndex,
          content: diary.content,
        );
        _streamController.add(EditUiEvent.loaded(diary.content));
      },
      error: (message) {
        // 불러오기 실패 시(저장된 데이터 없을 경우), 상태 초기화
        _diary = null;
        _state = _state.copyWith(
          isEditMode: true,
          emoIndex: 0,
          content: '',
        );
        _streamController.add(const EditUiEvent.loaded(''));
      },
    );

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }

  // 다이어리 삭제하기 (현재 날짜)
  Future<void> _delete() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _deleteDiaryUseCase(Data(_state.selectedDate));

    result.when(
      success: (delResult) {
        _streamController.add(const EditUiEvent.snackBar('삭제 성공'));

        // 다시 불러오기
        _load();
      },
      error: (message) {
        LoggerService.instance.logger?.e(message);
        _streamController.add(const EditUiEvent.snackBar('삭제 실패'));
      },
    );
  }
}
