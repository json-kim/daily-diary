import 'package:daily_diary/domain/model/diary/diary.dart';

class Backup {
  DateTime uploadDate;
  List<Diary> diaries;

  Backup({
    required this.uploadDate,
    required this.diaries,
  });
}
