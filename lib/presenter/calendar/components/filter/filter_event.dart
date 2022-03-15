import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_event.freezed.dart';

@freezed
class FilterEvent with _$FilterEvent {
  const factory FilterEvent.load(String query) = Load;
  const factory FilterEvent.changeEmo(int emoIndex) = ChangeEmo;
}
