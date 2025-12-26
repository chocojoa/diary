import 'package:flutter/material.dart';
import '../models/diary.dart';
import '../models/emotion_enum.dart';
import '../services/database_service.dart';
import '../services/gemini_service.dart'; // 변경

class DiaryProvider extends ChangeNotifier {
  List<Diary> _diaries = [];
  List<Diary> get diaries => _diaries;

  final DatabaseService _dbService = DatabaseService();
  final GeminiService _aiService = GeminiService(); // 진짜 AI 서비스!

  Future<void> loadDiaries() async {
    _diaries = await _dbService.getDiaries();
    notifyListeners();
  }

  Future<void> addDiary(String content) async {
    // 1. 저장 (감정 없음)
    int newId = await _dbService.addDiary(content);
    await loadDiaries(); // 화면 갱신 (모래시계 뜸)

    // 2. Gemini Nano에게 분석 요청
    // (네트워크 통신이므로 약간의 시간이 걸림)
    try {
      EmotionTag result = await _aiService.analyzeEmotion(content);

      // 3. 결과 업데이트
      await _dbService.updateEmotion(newId, result);
      await loadDiaries(); // 화면 갱신 (감정 아이콘 뜸!)
    } catch (e) {
      // API 실패 시 감정 업데이트 안 함 (분석 대기 중 상태 유지)
      print('❌ 감정 분석 실패: $e');
      print('📌 감정 분석 대기 중... (나중에 재시도 가능)');
      // loadDiaries()를 호출하지 않음 = 모래시계 계속 표시
    }
  }

  // (deleteDiary, updateEmotion 등 나머지는 그대로)
  Future<void> deleteDiary(int id) async {
    await _dbService.deleteDiary(id);
    await loadDiaries();
  }
}