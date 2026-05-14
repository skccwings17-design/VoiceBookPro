# VoiceBook Pro 📙

온디바이스 ML Kit OCR과 Google Chirp 3 보이스 클로닝 기술을 결합한 프리미엄 동화책 낭독 앱입니다.

## 주요 기능
- **실시간 OCR**: 인터넷 연결 없이 기기 내에서 즉시 동화책 글자 인식 (Google ML Kit)
- **보이스 클로닝**: 엄마, 아빠의 목소리를 10초 만에 학습하여 동화 구연 (Chirp 3)
- **스마트 번역**: Gemini 1.5 Flash를 통한 아이 눈높이 맞춤 번역 (의역)
- **동화구연 페르소나**: 느린 속도와 원어민 발음이 적용된 고품질 음성 합성
- **멀티 플랫폼**: Flutter 기반 Android 및 iOS 지원

## 구조 (Monorepo)
- `/app`: Flutter 모바일 앱 프로젝트
- `/server`: Node.js 백엔드 (Cloud Run 배포용)

## 시작하기 전 설정 (GCP/Firebase)

### 1. Firebase 설정
1. [Firebase Console](https://console.firebase.google.com/)에서 프로젝트 생성
2. **Authentication**: Google 및 Apple 로그인 활성화
3. **Firestore**: 데이터베이스 생성 (유저 프로필 저장용)
4. `google-services.json` (Android) 및 `GoogleService-Info.plist` (iOS)를 각 플랫폼 폴더에 배치

### 2. GCP API 활성화
```bash
gcloud services enable \
  run.googleapis.com \
  artifactregistry.googleapis.com \
  texttospeech.googleapis.com \
  aiplatform.googleapis.com
```

### 3. GitHub Secrets 설정
- `GCP_PROJECT_ID`: `voicebook-flutter-pro`
- `GCP_CREDENTIALS`: 서비스 계정 JSON 키
- `GEMINI_API_KEY`: Google AI Studio에서 발급받은 키

## 개발 및 배포
- **서버**: `main` 브랜치의 `server/` 폴더 변경 시 자동으로 Cloud Run에 배포됩니다.
- **앱**: `cd app && flutter run`으로 실행하세요.
