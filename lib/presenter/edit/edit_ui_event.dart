import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_ui_event.freezed.dart';

@freezed
class EditUiEvent with _$EditUiEvent {
  const factory EditUiEvent.snackBar(String message) = SnackBar;
  const factory EditUiEvent.loaded(String content) = Loaded;
}
