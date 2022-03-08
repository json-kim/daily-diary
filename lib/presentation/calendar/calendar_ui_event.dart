import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_ui_event.freezed.dart';

@freezed
class CalendarUiEvent with _$CalendarUiEvent {
  const factory CalendarUiEvent.snackBar(String message) = SnackBar;
}
