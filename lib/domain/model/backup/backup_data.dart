import 'package:daily_diary/domain/model/diary/diary.dart';

class BackupData {
  DateTime uploadDate;
  List<Diary> diaries;

  BackupData({
    required this.uploadDate,
    required this.diaries,
  });

  factory BackupData.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> jsonList = json['diaries'];
    List<Diary> diaries = jsonList.map((json) => Diary.fromJson(json)).toList();

    return BackupData(
      uploadDate: DateTime.parse(json['uploadData']),
      diaries: diaries,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> jsonDiaries =
        diaries.map((diary) => diary.toJson()).toList();

    return {
      'uploadDate': uploadDate.toIso8601String(),
      'diaries': jsonDiaries,
    };
  }
}
