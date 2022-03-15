import 'package:daily_diary/domain/model/backup/backup_item.dart';
import 'package:daily_diary/presenter/calendar/calendar_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_event.freezed.dart';

@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent.load() = Load;
  const factory CalendarEvent.changeYear(bool up) = ChangeYear;
  const factory CalendarEvent.changeMonth(bool up) = ChangeMonth;
  const factory CalendarEvent.changeMode(CalendarMode calendarMode) =
      ChangeMode;
  const factory CalendarEvent.delete(DateTime date) = Delete;
  const factory CalendarEvent.reset() = Reset;
  const factory CalendarEvent.backup() = Backup;
  const factory CalendarEvent.loadBackupList() = LoadBackupList;
  const factory CalendarEvent.restoreBackupData(BackupItem item) =
      RestoreBackupData;
  const factory CalendarEvent.deleteBackupData(BackupItem item) =
      DeleteBackupData;
}
