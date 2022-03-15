import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_ui_event.freezed.dart';

@freezed
class FilterUiEvent with _$FilterUiEvent {
  const factory FilterUiEvent.snackBar(String message) = SnackBar;
}
