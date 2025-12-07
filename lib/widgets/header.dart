// header.dart (통합 최종 코드)

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:studyshare/profile/services/profile_logic.dart';
import 'package:studyshare/auth_manager/AuthService.dart';
import 'package:studyshare/Login/LoginScreen.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback onLogoTap;
  final VoidCallback onSearchTap;
  final VoidCallback onProfileTap;
  final VoidCallback onWriteNoteTap;
  final VoidCallback onLoginTap;
  final VoidCallback onWriteCommunityTap;
  final VoidCallback onBookmarkTap;

  const AppHeader({
    super.key,
    required this.onLogoTap,
    required this.onSearchTap,
    required this.onProfileTap,
    required this.onWriteNoteTap,
    required this.onLoginTap,
    required this.onWriteCommunityTap,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileLogic>(
      builder: (context, profileLogic, child) {
        print('--- HEADER REBUILD START ---');
        print('Is Logged In: ${profileLogic.isLoggedIn}');
        print('Nickname: ${profileLogic.userNickname}');
        print('--- HEADER REBUILD END ---');

        final String? userNickname = profileLogic.userNickname;

        final Widget topRightButtons = Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Row(
            children: profileLogic.isLoggedIn
                ? [
                    _buildTopButton(Icons.search, '검색', onTap: onSearchTap),
                    const SizedBox(width: 30),
                    _buildTopButton(Icons.logout, '로그아웃', onTap: () async {
                      await AuthService.logout();
                      profileLogic.setAuthData(0, null);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                    }),
                    const SizedBox(width: 30),
                    _buildTopButton(Icons.person, userNickname,
                        onTap: onProfileTap),
                  ]
                : [
                    _buildTopButton(Icons.search, '검색', onTap: onSearchTap),
                    const SizedBox(width: 30),
                    _buildTopButton(Icons.login, '로그인', onTap: onLoginTap),
                    const SizedBox(width: 30),
                    _buildTopButton(Icons.person_add_alt_1, '회원가입'),
                  ],
          ),
        );

        return SizedBox(
          width: 1440,
          height: 225,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 142,
                left: 0,
                right: 0,
                child: Container(height: 1, color: const Color(0xFFE4E4E4)),
              ),
              Positioned(
                top: 224,
                left: 0,
                right: 0,
                child: Container(height: 1, color: const Color(0xFFE4E4E4)),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 142,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 164.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onLogoTap,
                        child: Image.asset('assets/images/StudyShare_Logo.png',
                            width: 280, height: 70),
                      ),
                      topRightButtons,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 143,
                left: 0,
                right: 0,
                height: 81,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 192.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildNavButton('StudyShare', onTap: onLogoTap),
                      _buildNavButton('북마크', onTap: onBookmarkTap),
                      _buildNavButton('노트 작성', onTap: onWriteNoteTap),
                      _buildNavButton('커뮤니티', onTap: onWriteCommunityTap),
                      _buildNavButton('프로필', onTap: onProfileTap),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopButton(IconData icon, String? text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 21),
            const SizedBox(width: 8),
            Text(
              text ?? '회원가입',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
