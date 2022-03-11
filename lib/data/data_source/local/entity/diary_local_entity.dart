import 'package:daily_diary/domain/model/diary/diary.dart';

class DiaryLocalEntity {
  final String id;
  final String content;
  final String uid;
  final int emoIndex;
  final int year;
  final int month;
  final int day;

  DiaryLocalEntity({
    required this.id,
    required this.content,
    required this.uid,
    required this.emoIndex,
    required this.year,
    required this.month,
    required this.day,
  });

  factory DiaryLocalEntity.fromJson(Map<String, dynamic> json) {
    return DiaryLocalEntity(
      id: json['id'],
      content: json['content'],
      uid: json['uid'],
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
      'uid': uid,
      'emoIndex': emoIndex,
      'year': year,
      'month': month,
      'day': day,
    };
  }

  factory DiaryLocalEntity.fromDiary(Diary diary, String uid) {
    return DiaryLocalEntity(
      id: diary.id,
      content: diary.content,
      emoIndex: diary.emoIndex,
      uid: uid,
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
    return 'DiaryLocalEntity(id: $id, content: $content, uid: $uid, emoIndex: $emoIndex, year: $year, month: $month, day: $day)';
  }

  String toRawValues() {
    return '("$id", "$content", "$uid", $emoIndex, $year, $month, $day)';
  }
}
