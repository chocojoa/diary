import 'package:flutter/material.dart';

// 1. 대분류 (긍정, 중립, 부정)
enum EmotionCategory {
  positive(Colors.blue, "긍정"),
  neutral(Colors.grey, "중립"),
  negative(Colors.red, "부정");

  final Color color; // 카테고리별 대표 색상
  final String label;

  const EmotionCategory(this.color, this.label);
}

// 2. 소분류 (실제 선택할 8가지 감정)
enum EmotionTag {
  // 긍정 그룹
  happiness(EmotionCategory.positive, "행복", Icons.sentiment_very_satisfied),
  excitement(EmotionCategory.positive, "설림", Icons.favorite),
  gratitude(EmotionCategory.positive, "감사", Icons.handshake),

  // 중립 그룹
  calm(EmotionCategory.neutral, "평온", Icons.self_improvement),
  boredom(EmotionCategory.neutral, "무덤덤", Icons.sentiment_neutral),
  none(EmotionCategory.neutral, "모르겠음", Icons.help_outline),

  // 부정 그룹
  sadness(EmotionCategory.negative, "슬픔", Icons.sentiment_dissatisfied),
  anger(EmotionCategory.negative, "분노", Icons.whatshot),
  anxiety(EmotionCategory.negative, "불안", Icons.error_outline);

  final EmotionCategory category; // 내가 어디 소속인지
  final String label; // 한글 이름
  final IconData icon; // 대표 아이콘

  const EmotionTag(this.category, this.label, this.icon);
}

