import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/emotion_enum.dart';

class GeminiService {
  // 발급받은 API 키 (환경변수에서 로드하거나 설정에서 변경 가능)
  // 기본값: 앱 시작 시 설정 화면에서 입력하도록 유도
  static String _apiKey = '';

  // Gemini REST API 엔드포인트
  // gemini-2.5-flash 모델 사용
  static const String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  GeminiService() {
    print('🌐 Gemini REST API 모드 초기화');
  }

  // API 키 변경 메서드
  static void setApiKey(String newKey) {
    _apiKey = newKey;
    print('🔑 API 키 변경됨');
  }

  // 현재 API 키 조회 메서드
  static String getApiKey() {
    return _apiKey;
  }

  // REST API를 사용한 Gemini 감정 분석
  Future<EmotionTag> analyzeEmotion(String content) async {
    try {
      print('🚀 감정 분석 시작: "$content"');
      print('📱 Gemini REST API 호출 중...');

      // 프롬프트 작성
      final prompt = '''당신은 감정 분석 전문가입니다. 사용자의 일기 내용을 읽고 정확히 하나의 감정만 선택하세요.

[감정 정의]
- happiness: 기쁨, 행복감 (예: "기뻤어", "행복했다", "즐거웠다")
- excitement: 흥분, 설렘, 설래함 (예: "설래", "흥미진진", "두근거려")
- gratitude: 감사, 고마움 (예: "감사해", "고맙다", "은혜")
- calm: 평온, 차분함, 무사 (예: "평온했다", "편했다", "무사했다")
- boredom: 지루함, 무관심 (예: "지루해", "따분해", "흥미 없어")
- sadness: 슬픔, 우울함 (예: "슬퍼", "우울해", "속상해")
- anger: 분노, 화남, 짜증 (예: "화나", "짜증나", "열받아")
- anxiety: 불안, 걱정 (예: "불안해", "걱정돼", "초조해")
- none: 감정을 판단할 수 없거나 의미 없는 내용 (예: "ㅋㅋ", "123", "아무말대잔디")

[지침]
1. 반드시 위의 감정 단어 중 정확히 하나만 선택하세요.
2. 다른 설명이나 이유는 절대 쓰지 마세요.
3. 오직 감정 단어 하나만 소문자로 리턴하세요.

[일기 내용]
$content

[답]''';

      // REST API 요청 본문
      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      };

      // HTTP POST 요청
      final response = await http.post(
        Uri.parse('$_apiUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('📥 API 응답 상태: ${response.statusCode}');

      if (response.statusCode == 200) {
        // 성공 응답 처리
        final responseData = jsonDecode(response.body);
        final emotionName = responseData['candidates'][0]['content']['parts'][0]['text']
            .toString()
            .trim()
            .toLowerCase();

        print('🤖 Gemini 응답: "$emotionName"');

        // 응답을 EmotionTag Enum으로 변환
        return EmotionTag.values.firstWhere(
          (e) => e.name == emotionName,
          orElse: () => EmotionTag.none,
        );
      } else {
        // 에러 응답 처리
        print('❌ API 에러: ${response.statusCode}');
        print('응답 본문: ${response.body}');
        throw Exception('API 호출 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 감정 분석 실패: $e');
      print('💾 감정 분석 없이 저장 (분석 대기 중 상태 유지)');
      rethrow;
    }
  }
}
