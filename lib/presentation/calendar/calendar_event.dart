import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_event.freezed.dart';

@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent.load() = Load;
  const factory CalendarEvent.changeYear(bool up) = ChangeYear;
  const factory CalendarEvent.delete(DateTime date) = Delete;
  const factory CalendarEvent.reset() = Reset;
}
