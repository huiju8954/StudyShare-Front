// lib/profile/screens/profile_screen.dart (최종 병합 코드 - 중앙 정렬 적용)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 💡 [오류 수정]: MyBookmarkScreen 충돌 방지를 위해 hide 적용
import 'package:studyshare/search/screens/search_screen.dart'
    hide MyBookmarkScreen;
// MyBookmarkScreen은 별도로 import합니다.
import 'package:studyshare/bookmark/screens/my_bookmark_screen.dart';

import 'package:studyshare/community/screens/my_community_screen.dart';
import 'package:studyshare/Login/LoginScreen.dart';
import 'package:studyshare/main/screens/home_main_screen.dart';
import 'package:studyshare/like/screens/my_likes_list_screen.dart';
import 'package:studyshare/note/screens/my_note_screen.dart';
import 'package:studyshare/community/screens/my_write_community_screen.dart';
import 'package:studyshare/profile/services/profile_logic.dart';
import 'package:studyshare/widgets/header.dart';
import 'package:studyshare/note/screens/my_write_note_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 프로필 데이터 갱신
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read를 사용하여 Logic의 데이터 패치를 트리거합니다.
      context.read<ProfileLogic>().fetchProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Consumer를 사용하여 로직 상태 구독
    return Consumer<ProfileLogic>(
      builder: (context, logic, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 1. AppHeader (모든 네비게이션 경로 포함)
                AppHeader(
                  onLogoTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()));
                  },
                  onSearchTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                  },
                  onProfileTap: () {
                    // 이미 프로필 화면이므로 아무것도 하지 않음 (또는 자기 자신을 새로고침)
                    print("Already on Profile Screen");
                  },
                  onWriteNoteTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyWriteNoteScreen()));
                  },
                  onLoginTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  onWriteCommunityTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MyWriteCommunityScreen()));
                  },
                  onBookmarkTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyBookmarkScreen()));
                  },
                ),

                // 2. 프로필 내용 (중앙 정렬)
                Center(
                  // 💡 [수정] Center를 사용하여 가로 중앙 정렬
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 800), // 최대 너비 800 유지
                    child: Padding(
                      // 💡 [수정] 기존 Padding의 가로/세로 패딩을 ConstrainedBox 안쪽으로 이동
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 50.0),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 45,
                            backgroundColor: Color(0xFFE0E0E0),
                            child: Icon(Icons.person,
                                size: 50, color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          // 💡 실제 닉네임 바인딩
                          Text(
                            logic.displayNickname,
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 30),

                          // 💡 작성글 및 좋아요 통계
                          Row(
                            children: [
                              _buildStatItem(
                                  logic.noteCount.toString(), '작성한 노트'),
                              const SizedBox(width: 20),
                              _buildStatItem(
                                  logic.postCount.toString(), '작성한 글'),
                              const SizedBox(width: 20),
                              _buildStatItem(
                                  logic.likeCount.toString(), '좋아요 글'),
                            ],
                          ),

                          const SizedBox(height: 50),
                          _buildSectionTitle('내 활동'),

                          // 💡 메뉴 아이템 (실제 카운트 및 화면 이동 적용)
                          _buildProfileMenuItem(
                            icon: Icons.description_outlined,
                            title: '내가 작성한 노트',
                            count: logic.noteCount.toString(),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MyNoteScreen()));
                            },
                          ),
                          _buildProfileMenuItem(
                            icon: Icons.chat_bubble_outline,
                            title: '내가 작성한 게시글',
                            count: logic.postCount.toString(),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MyCommunityScreen()));
                            },
                          ),
                          _buildProfileMenuItem(
                            icon: Icons.favorite_border,
                            title: '좋아요 글',
                            count: logic.likeCount.toString(),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LikesScreen()));
                            },
                          ),
                          _buildProfileMenuItem(
                              icon: Icons.bookmark_border,
                              title: '북마크',
                              count:
                                  logic.bookmarkCount.toString(), // 북마크 개수 반영
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyBookmarkScreen()));
                              }),

                          const SizedBox(height: 50),
                          _buildSectionTitle('설정'),
                          _buildProfileMenuItem(
                              icon: Icons.edit_outlined,
                              title: '프로필 편집',
                              onTap: () {
                                // TODO: 프로필 편집 화면으로 이동
                              }),
                          _buildProfileMenuItem(
                              icon: Icons.notifications_outlined,
                              title: '알림 설정',
                              onTap: () {
                                // TODO: 알림 설정 화면으로 이동
                              }),
                          _buildProfileMenuItem(
                              icon: Icons.privacy_tip_outlined,
                              title: '개인정보 처리방침',
                              onTap: () {
                                // TODO: 개인정보 처리방침 화면으로 이동
                              }),
                          const SizedBox(height: 30),

                          // 로그아웃 버튼
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: OutlinedButton(
                              onPressed: () async {
                                // ⭐️ [로그아웃 로직 구현]
                                // 1. ProfileLogic을 통해 로그아웃 처리
                                await context.read<ProfileLogic>().logout();

                                // 2. 로그인 화면으로 이동하며, 이전 화면 스택을 모두 제거
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                    (Route<dynamic> route) => false,
                                  );
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Color(0xFFFF7B7B)),
                                foregroundColor: const Color(0xFFFF7B7B),
                              ),
                              child: const Text('로그아웃'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Helper Widgets ---

  Widget _buildStatItem(String count, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD9D9D9)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Text(count,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
            const SizedBox(height: 5),
            Text(label,
                style: const TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
    );
  }

  Widget _buildProfileMenuItem(
      {required IconData icon,
      required String title,
      String? count,
      VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 15),
            Expanded(
                child: Text(title,
                    style: const TextStyle(fontSize: 16, color: Colors.black))),
            if (count != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(count,
                    style: const TextStyle(fontSize: 12, color: Colors.black)),
              ),
            if (onTap != null)
              const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
