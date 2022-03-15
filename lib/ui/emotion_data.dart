import 'package:flutter/material.dart';
import 'package:daily_diary/ui/colors.dart';

/// 감정 라벨
/// 인덱스 (0, 1, 2, 3, 4)
const List<String> emoLabels = [
  'very good',
  'good',
  'soso',
  'bad',
  'very bad',
];

/// 감정라벨 -> 감정컬러
Map<String, Color> emoDatas = {
  emoLabels[0]: emoColor1,
  emoLabels[1]: emoColor2,
  emoLabels[2]: emoColor3,
  emoLabels[3]: emoColor4,
  emoLabels[4]: emoColor5,
};

Map<String, IconData> emoIcons = {
  emoLabels[0]: Icons.sentiment_very_satisfied_rounded,
  emoLabels[1]: Icons.sentiment_satisfied_outlined,
  emoLabels[2]: Icons.sentiment_neutral_outlined,
  emoLabels[3]: Icons.sentiment_dissatisfied_outlined,
  emoLabels[4]: Icons.sentiment_very_dissatisfied_outlined,
};
