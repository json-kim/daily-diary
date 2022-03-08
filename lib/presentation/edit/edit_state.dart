import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'edit_state.freezed.dart';

@freezed
class EditState with _$EditState {
  const factory EditState({
    @Default(false) bool isLoading,
    @Default(true) bool isEditMode,
    required DateTime selectedDate,
    required int emoIndex,
    @Default('') String content,
  }) = _EditState;
}
