# 제이(Jay) — 의료 복지 혜택 통합 탐색 앱

> 복잡한 의료 복지 혜택 정보를 개인 맞춤으로 탐색하고, 이웃과 경험을 나눌 수 있는 커뮤니티 플랫폼

---

## 기술 스택

| 분류 | 기술 |
|------|------|
| 프레임워크 | Flutter 3.x (iOS · Android · Web 멀티플랫폼) |
| 상태관리 | Flutter Riverpod 2.x (AsyncNotifier, StateProvider) |
| 네비게이션 | go_router (ShellRoute 탭 구조 + 딥링크) |
| 백엔드 | Supabase (PostgreSQL, Auth, RLS) |
| 인증 | Supabase OAuth — Google / Kakao (PKCE 방식) |
| 분석 | Firebase Analytics |
| 로컬저장 | SharedPreferences (필터 설정 영구 보존) |
| 폰트 | Pretendard (9가지 굵기) |
| 아키텍처 | MVVM (Model / Repository / ViewModel / View) |

---

## 주요 기능

### 1. 의료 복지 혜택 공고

- **공고 목록**: 무한 스크롤 페이지네이션 (10개씩 추가 로드)
- **제목 검색**: 실시간 입력 감지, X 버튼으로 즉시 초기화
- **맞춤 필터**: 하단 모달에서 아래 조건 조합 설정
  - 질환 종류 (다중 선택)
  - 거주 지역 (시·도 / 시·군·구)
  - 생년월일 → 나이 자동 계산
  - 월 소득 / 가족 수 → 기준 중위소득 자동 산출
  - 개인정보 수집·이용 동의
- **필터 자동 표시**: 첫 실행 시 필터 모달 자동 노출 (SharedPreferences 기록)
- **필터 영구 저장**: 앱 재시작 후에도 마지막 필터 유지
- **공고 상세**: 전체 내용 확인 + URL 공유(`share_plus`) + 외부 링크 이동(`url_launcher`)
- **빈 상태 처리**: 결과 없을 때 "필터 변경" / "검색 초기화" 버튼 안내

### 2. 커뮤니티

- **게시글 목록**: 무한 스크롤, 최신순 / 인기순 정렬 전환
- **게시글 검색**: 제목 검색 + X 버튼 초기화
- **pull-to-refresh**: 당겨서 최신 목록 새로고침
- **좋아요**: 본인 좋아요 여부에 따라 하트 빨간색 / 회색 구분 표시
  - 목록 진입 시 단일 쿼리로 좋아요한 게시글 ID 일괄 조회 (N+1 쿼리 방지)
- **게시글 작성 / 수정 / 삭제** (로그인 필요)
- **게시글 상세**: 본문 + 좋아요 + 댓글 목록
- **댓글 작성**: 로그인 필요, 작성 후 목록 즉시 갱신
- **본인 댓글 수정 / 삭제**: 상세 화면에서 내 댓글에만 수정·삭제 아이콘 표시
- **고정 헤더**: 배너 + 정렬 버튼은 고정, 게시글 목록만 스크롤

### 3. 회원 / 마이페이지

- **소셜 로그인**: Google · Kakao OAuth (PKCE, `supabase_flutter`)
- **로그인 에러 처리**: 취소 / 네트워크 오류 시 스낵바 안내
- **내가 쓴 글 관리**: 목록 조회 + 수정(작성 화면 재사용) + 삭제
- **내가 쓴 댓글 관리**: 목록 조회 + 삭제
- **로그아웃**
- **회원 탈퇴**: 확인 다이얼로그 → Supabase RPC로 계정 및 데이터 완전 삭제

---

## 아키텍처

```
lib/
├── features/
│   ├── postings/          # 복지 혜택 공고
│   │   ├── models/        # PostingModel, FilterModel
│   │   ├── repos/         # PostingRepository, FilterRepository
│   │   ├── view_models/   # PostingViewModel (AsyncNotifier), FilterViewModel
│   │   ├── views/         # PostingScreen, PostingDetailScreen, FilterModal
│   │   └── widgets/       # PostingCard, SearchTextField, 필터 선택 위젯들
│   ├── community/         # 커뮤니티
│   │   ├── models/        # CommunityPostModel, CommunityCommentModel
│   │   ├── repos/         # CommunityRepository
│   │   ├── view_models/   # CommunityViewModel (AsyncNotifier)
│   │   ├── views/         # CommunityScreen, DetailScreen, WriteScreen
│   │   └── widgets/       # CommunityPostCard
│   └── users/             # 회원·인증
│       ├── repos/         # AuthRepository
│       ├── view_models/   # AuthViewModel (AsyncNotifier)
│       └── views/         # LoginScreen, MyPageScreen, MyPostsScreen, MyCommentsScreen
├── route.dart             # go_router (ShellRoute + 전체 라우트 정의)
└── main_screen.dart       # 하단 탭 네비게이션 (커스텀 NavigationBar)
```

### 상태관리 패턴

- `AsyncNotifier` — 비동기 목록 로드, 무한 스크롤, 갱신
- `StateProvider` — 정렬 기준, 검색어 등 단순 UI 상태
- Riverpod 의존성 변경 시 `build()` 자동 재실행 활용 (검색어·정렬 변경 → 자동 리페치)

### 보안

- Supabase Row Level Security (RLS) 전 테이블 적용
  - `community_posts` / `community_comments` / `community_likes` 각각 SELECT · INSERT · UPDATE · DELETE 정책
  - UPDATE 정책: `auth.uid() = user_id` USING + WITH CHECK
- 환경 분리: `flutter_dotenv`로 dev / prod Supabase 프로젝트 분리

---

## 환경 설정

```
assets/config/.env.dev
assets/config/.env.prod
```

```env
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
```

---

## 실행

```bash
flutter pub get
flutter run                  # 디바이스 자동 선택
flutter run -d chrome        # 웹
flutter run -d ios           # iOS 시뮬레이터
flutter build apk            # Android 빌드
flutter build web            # Web 빌드
```
