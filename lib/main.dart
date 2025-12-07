import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 로직 import
import 'package:studyshare/note/services/note_share_logic.dart';
import 'package:studyshare/community/services/community_share_logic.dart';
import 'package:studyshare/profile/services/profile_logic.dart';
// ✅ [통합] 친구 버전에서 명시된 Bookmark Logic 추가
import 'package:studyshare/bookmark/services/bookmark_logic.dart';

// 화면 및 인증 import
import 'package:studyshare/main/screens/home_main_screen.dart';
// ✅ [유지] 사용자님의 로그인 화면
import 'package:studyshare/Login/LoginScreen.dart';
// ✅ [통합] 인증 서비스
import 'package:studyshare/auth_manager/AuthService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider를 사용하여 앱 전체에 로직 주입
    return MultiProvider(
      providers: [
        // 1. 노트 로직
        ChangeNotifierProvider(create: (_) => StudyShareLogic()),

        // 2. 커뮤니티 로직
        ChangeNotifierProvider(create: (_) => CommunityShareLogic()),

        // 3. 프로필 로직
        ChangeNotifierProvider(create: (_) => ProfileLogic()),

        // 4. 북마크 로직 (이전 단계에서 확인된 필수 로직)
        ChangeNotifierProvider(create: (_) => BookmarkLogic()),
      ],
      child: MaterialApp(
        title: 'Study Share',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: Colors.white,
        ),

        // ✅ [핵심 통합] 로그인 유지 및 인증 체크 로직 적용
        home: FutureBuilder<String?>(
          // 1. 저장된 세션 쿠키 로드 시도
          future: AuthService.loadSession(),
          builder: (context, snapshot) {
            // 로딩 중 표시
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }

            // 2. 로그인 상태에 따라 화면 분기
            if (AuthService.isLoggedIn) {
              // 세션이 유효하면 MainScreen 로드
              return const MainScreen();
            } else {
              // 세션이 없거나 유효하지 않으면 LoginScreen 로드
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
