import 'emotion_enum.dart';

class Diary {
  final int? id;         // SQLite는 id가 없으면 자동으로 만들어줌 (Nullable)
  final String content;  // 내용
  final DateTime createdAt; // 날짜
  EmotionTag? emotion;   // 감정 (저장할 땐 문자열로 변환)

  Diary({
    this.id,
    required this.content,
    required this.createdAt,
    this.emotion,
  });

  // 1. DB에 저장할 때: 객체 -> Map(딕셔너리) 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(), // 날짜는 문자열로 저장
      // 감정은 Enum의 영어 이름(happiness 등)으로 저장. 없으면 null
      'emotion': emotion?.name,
    };
  }

  // 2. DB에서 가져올 때: Map -> 객체 변환
  factory Diary.fromMap(Map<String, dynamic> map) {
    return Diary(
      id: map['id'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']), // 문자열 -> 날짜 복구
      // 저장된 영어 이름("happiness")을 보고 다시 Enum으로 찾기
      emotion: map['emotion'] != null
          ? EmotionTag.values.firstWhere((e) => e.name == map['emotion'])
          : null,
    );
  }
}