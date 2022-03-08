import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'edit_event.freezed.dart';

@freezed
class EditEvent with _$EditEvent {
  const factory EditEvent.modeChange(bool isEditMode) = ModeChange;
  const factory EditEvent.load() = Load;
  const factory EditEvent.changeDate(DateTime date) = ChangeDate;
  const factory EditEvent.setEmoData(int emoIndex) = SetEmoData;
  const factory EditEvent.save(String message) = Save;
  const factory EditEvent.delete() = Delete;
}
