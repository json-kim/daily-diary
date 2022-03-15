import 'package:daily_diary/domain/model/diary/diary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_state.freezed.dart';

@freezed
class CalendarState with _$CalendarState {
  const factory CalendarState({
    @Default(false) bool isLoading,
    @Default(CalendarMode.year) CalendarMode calendarMode,
    required DateTime currentDate,
    @Default([]) List<Diary> diaries,
  }) = _CalendarState;
}

enum CalendarMode {
  year,
  month,
  filter,
}
