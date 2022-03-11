import 'package:daily_diary/domain/model/backup/backup_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_ui_event.freezed.dart';

@freezed
class CalendarUiEvent with _$CalendarUiEvent {
  const factory CalendarUiEvent.snackBar(String message) = SnackBar;
  const factory CalendarUiEvent.toggleDrawer(bool isOpen) = ToggleDrawer;
  const factory CalendarUiEvent.showBackupList(List<BackupItem> backupList) =
      ShowBackupList;
}
