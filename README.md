# 🎭 오늘의 감정 - AI 감정 일기 앱

Flutter로 만든 AI 감정 분석 일기 애플리케이션입니다. Google Gemini API를 사용하여 입력한 일기의 감정을 자동으로 분석합니다.

## 📋 주요 기능

### 1. 📝 일기 작성 및 감정 분석
- 일기 내용을 입력하면 Google Gemini 2.5 Flash 모델이 실시간으로 감정을 분석
- 8가지 감정 분류: 기쁨, 설렘, 감사, 평온, 지루함, 슬픔, 분노, 불안
- API 키는 앱 설정 화면에서 직접 입력/변경 가능

### 2. 📅 달력 보기
- 월간 캘린더 형식으로 일별 감정 조회
- 감정별 아이콘과 색상으로 직관적 표시
- 선택한 날짜의 상세 일기 내용 확인

### 3. 📊 통계 분석
- 전체 일기 통계 (작성, 분석완료, 분석대기)
- 감정별 상세 분석 및 비율
- 최근 7일간 감정 트렌드
- 주요 감정 Top 3 순위

### 4. ⚙️ 설정
- Google Gemini API 키 입력/변경
- API 키 표시/숨김 토글
- 기본값으로 초기화

## 🏗️ 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── config/
│   └── api_config.dart      # API 설정 (git에서 제외)
├── models/
│   ├── diary.dart           # 일기 데이터 모델
│   └── emotion_enum.dart    # 감정 열거형
├── providers/
│   └── diary_provider.dart  # Provider 패턴으로 상태 관리
├── screens/
│   ├── home_screen.dart     # 메인 화면 & 일기 탭
│   ├── calendar_screen.dart # 달력 탭
│   ├── stats_screen.dart    # 통계 탭
│   └── settings_screen.dart # 설정 화면
└── services/
    ├── database_service.dart    # SQLite 데이터베이스 관리
    └── gemini_service.dart      # Google Gemini REST API
```

## 🔧 기술 스택

### Frontend
- **Flutter**: UI 프레임워크
- **Provider**: 상태 관리
- **Material Design 3**: 디자인 시스템

### Backend & Storage
- **SQLite + sqflite**: 로컬 데이터베이스
- **Google Gemini API**: AI 감정 분석
- **HTTP**: REST API 통신

### Dependencies
- `http: ^1.1.0` - HTTP 요청
- `provider: ^6.1.5+1` - 상태 관리
- `sqflite: ^2.4.2` - SQLite
- `sqflite_common_ffi: ^2.3.4` - FFI 지원 (Windows/Linux)
- `table_calendar: ^3.0.9` - 달력 UI
- `intl: ^0.19.0` - 날짜 포맷팅

## 🚀 시작하기

### 사전 요구사항
- Flutter SDK (3.10.4+)
- Dart SDK
- Google Cloud API 키 (Gemini API)

### 설치

1. 저장소 클론
```bash
git clone <repository-url>
cd diary
```

2. 패키지 설치
```bash
flutter pub get
```

3. API 키 설정
   - 앱 실행 후 우측 상단 **⚙️ 설정** 아이콘 클릭
   - Google Gemini API 키 입력
   - **저장** 클릭

### 실행

**Windows/Linux/macOS:**
```bash
flutter run -d windows
flutter run -d linux
flutter run -d macos
```

**Android:**
```bash
flutter run -d <device-id>
```

## 📱 화면 구성

### 1️⃣ 일기 탭
- 입력창에서 일기 작성
- 감정 아이콘으로 분석 결과 표시
- 일기 삭제 기능

### 2️⃣ 달력 탭
- 월별 캘린더 뷰
- 감정별 아이콘 표시
- 선택 날짜의 상세 일기

### 3️⃣ 통계 탭
- 전체 통계 요약
- 감정 카테고리별 분석 (펼침/접기)
- 최근 7일 감정 트렌드
- 주요 감정 순위

### ⚙️ 설정
- API 키 관리
- 앱 정보 확인

## 🎨 디자인 특징

- **색상 테마**: 흰색 배경 + 회색/검정색 텍스트
- **감정 아이콘**: 감정별 다양한 색상 (다채로운 UI)
- **카드 레이아웃**: 깔끔한 카드 기반 디자인
- **반응형 UI**: 다양한 화면 크기 지원

## 🔐 보안 및 프라이버시

- **API 키**: 코드에 하드코딩하지 않음, 앱 설정에서만 관리
- **로컬 저장**: 모든 일기 데이터는 로컬 SQLite에 저장
- **git 제외**: API 관련 파일은 `.gitignore`에 포함

## 📊 감정 분류 체계

| 카테고리 | 감정 | 설명 |
|---------|------|------|
| 긍정 | 기쁨 (happiness) | 기쁨, 행복감 |
| | 설렘 (excitement) | 흥분, 설렘, 설래함 |
| | 감사 (gratitude) | 감사, 고마움 |
| 중립 | 평온 (calm) | 평온, 차분함, 무사 |
| | 지루함 (boredom) | 지루함, 무관심 |
| 부정 | 슬픔 (sadness) | 슬픔, 우울함 |
| | 분노 (anger) | 분노, 화남, 짜증 |
| | 불안 (anxiety) | 불안, 걱정 |

## 🔄 데이터 흐름

```
입력 → API 키 확인 → Gemini 분석 → 감정 저장 → DB 저장 → UI 업데이트
```

1. 사용자가 일기 입력
2. GeminiService가 API 키로 Gemini API 호출
3. AI가 감정 분석 후 결과 반환
4. DatabaseService가 일기와 감정을 SQLite에 저장
5. Provider가 상태 업데이트
6. UI가 자동으로 리빌드되어 표시

## 🛠️ 개발 팁

### 상태 관리
```dart
// Provider 사용
final provider = Provider.of<DiaryProvider>(context);
provider.addDiary(content);
provider.loadDiaries();
```

### API 키 변경
```dart
GeminiService.setApiKey('your-api-key');
final currentKey = GeminiService.getApiKey();
```

### 새 감정 추가
1. `emotion_enum.dart`에 새 감정 추가
2. `gemini_service.dart`의 프롬프트 업데이트
3. 필요시 아이콘/색상 정의

## 📝 API 할당량

Google Gemini API는 무료 계정 기준:
- **할당량**: 하루 20번 요청
- **권장**: 개인 사용자 기준으로는 충분

## 🐛 알려진 제한사항

- Windows 빌드 시 C++ 컴파일러 필요
- API 키 노출 주의 (설정 화면에서만 입력)

## 📄 라이선스

이 프로젝트는 개인 학습용으로 만들어졌습니다.

## 🤝 기여

개선 사항이나 버그 리포트는 언제든 환영합니다!

---

**마지막 업데이트**: 2025-12-26
**개발 플랫폼**: Flutter 3.10.4
**타겟**: Windows, macOS, Linux, Android
