import 'package:daily_diary/domain/model/diary/diary.dart';

class DiaryLocalEntity {
  final String id;
  final String content;
  final int emoIndex;
  final int year;
  final int month;
  final int day;

  DiaryLocalEntity({
    required this.id,
    required this.content,
    required this.emoIndex,
    required this.year,
    required this.month,
    required this.day,
  });

  factory DiaryLocalEntity.fromJson(Map<String, dynamic> json) {
    return DiaryLocalEntity(
      id: json['id'],
      content: json['content'],
      emoIndex: json['emoIndex'],
      year: json['year'],
      month: json['month'],
      day: json['day'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'emoIndex': emoIndex,
      'year': year,
      'month': month,
      'day': day,
    };
  }

  factory DiaryLocalEntity.fromDiary(Diary diary) {
    return DiaryLocalEntity(
      id: diary.id,
      content: diary.content,
      emoIndex: diary.emoIndex,
      year: diary.date.year,
      month: diary.date.month,
      day: diary.date.day,
    );
  }

  Diary toDiary() {
    final date = DateTime(year, month, day);

    return Diary(id: id, content: content, emoIndex: emoIndex, date: date);
  }

  @override
  String toString() {
    return 'DiaryLocalEntity(id: $id, content: $content, emoIndex: $emoIndex, year: $year, month: $month, day: $day)';
  }
}
