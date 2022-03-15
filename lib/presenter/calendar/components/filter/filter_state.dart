import 'package:daily_diary/domain/model/diary/diary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_state.freezed.dart';

@freezed
class FilterState with _$FilterState {
  const factory FilterState({
    @Default(false) bool isLoading,
    @Default('') String query,
    @Default(0) int selectedIndex,
    @Default([]) List<Diary> diaries,
  }) = _FilterState;
}
