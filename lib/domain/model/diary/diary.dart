class Diary {
  final String id;
  final DateTime date; // 날짜
  final String content; // 다이어리 내용
  final int emoIndex; // 감정 인덱스 (0~4)

  Diary({
    required this.id,
    required this.date,
    required this.content,
    required this.emoIndex,
  });

  @override
  String toString() {
    return 'Diary(id: $id, date: $date, content: $content, emoIndex: $emoIndex)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Diary && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
