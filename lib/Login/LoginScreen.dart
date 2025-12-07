// LoginScreen.dart (최종 1단계 로그인 통합 코드)

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON 디코딩을 위해 추가
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart'; // ⭐️ 추가: Provider 임포트

import 'package:studyshare/Login/SignupScreen.dart';
import 'package:studyshare/main/screens/home_main_screen.dart';
import 'package:studyshare/auth_manager/AuthService.dart'; // ⭐️ 추가: AuthService 임포트
import 'package:studyshare/profile/services/profile_logic.dart'; // ⭐️ 추가: ProfileLogic 임포트

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;

  // ⭐️ [수정] 백엔드 서버의 포트 8081로 다시 설정
  static const String _loginBaseUrl = 'http://localhost:8081/member/login';
// 🚨 _profileUrl은 더 이상 필요 없음

  @override
  void initState() {
    super.initState();
    _loadUserCredentials();
  }

  void _loadUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? rememberMe = prefs.getBool('remember_me');
    final String? savedUsername = prefs.getString('username');
    final String? savedPassword = prefs.getString('password');

    if (rememberMe ?? false) {
      setState(() {
        _rememberMe = true;
        _usernameController.text = savedUsername ?? '';
        _passwordController.text = savedPassword ?? '';
      });
    }
  }

  void _saveUserCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      prefs.setBool('remember_me', true);
      prefs.setString('username', username);
      prefs.setString('password', password);
    } else {
      prefs.remove('remember_me');
      prefs.remove('username');
      prefs.remove('password');
    }
  }

// 🚨 [제거] _fetchAndSetProfile 함수는 제거됨

  Future<void> _signInWithStudyShare() async {
    final profileLogic = Provider.of<ProfileLogic>(context, listen: false);

    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnackBar('아이디와 비밀번호를 모두 입력해주세요.');
      return;
    }

// GET 요청 URL에 쿼리 파라미터 추가
    final Uri loginUri = Uri.parse(_loginBaseUrl).replace(queryParameters: {
      'username': username,
      'password': password,
    });

    try {
// 1. 로그인 요청 (Client가 세션 쿠키와 DTO를 함께 받습니다)
      final response = await http.get(
        loginUri,
        headers: {
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
// 1-1. 세션 쿠키 추출 및 저장 (다른 API 요청 시 필요)
        String? rawCookie = response.headers['set-cookie'];
        String sessionCookie = '';
        if (rawCookie != null) {
          final match = RegExp(r'(JSESSIONID=[^;]+)').firstMatch(rawCookie);
          if (match != null) {
            sessionCookie = match.group(0)!;
          }
        }

        if (sessionCookie.isNotEmpty) {
          await AuthService.saveSession(sessionCookie);
        }

// 2. 응답 본문에서 프로필 DTO를 바로 파싱하여 사용자 정보 획득
        final Map<String, dynamic> profileJson =
            jsonDecode(utf8.decode(response.bodyBytes));
        final int userId = profileJson['id'] ?? 0;
        final String? nickname = profileJson['nickname'];

// 3. ProfileLogic 업데이트 및 상태 저장
        profileLogic.setAuthData(userId, nickname);

        _saveUserCredentials(username, password);
        _showSnackBar('로그인 성공!');

// 4. MainScreen으로 이동
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()));
      } else if (response.statusCode == 401) {
        print('--- ❌ 로그인 실패 (Status: 401 Unauthorized) ---');
        _showSnackBar('로그인 실패: 아이디 또는 비밀번호를 확인해주세요.');
      } else {
        print('--- ❌ 로그인 실패 (Status: ${response.statusCode}) ---');
        _showSnackBar('로그인 실패: 서버 오류');
      }
    } catch (e) {
      print('--- ❌ 네트워크 오류 발생: $e ---');
      // ⭐️ 안내 메시지 포트 8081로 다시 수정
      _showSnackBar('네트워크 오류가 발생했습니다. 서버가 8081 포트에서 실행 중인지 확인하세요.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateToSignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  Widget _buildLinkText(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            decoration: TextDecoration.underline,
            decorationColor: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String hint,
      {bool obscureText = false, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500]),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.black54, width: 1.0),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    const Color buttonColor = Color(0xFFFFC107);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
// ⭐️ [수정] 최종 로고 경로 반영
          Image.asset('assets/images/StudyShare_Logo.png', height: 60),
          const SizedBox(height: 50),
          _buildInputField('스터디쉐어 ID (아이디 또는 이메일)',
              controller: _usernameController),
          const SizedBox(height: 10),
          _buildInputField('비밀번호',
              obscureText: true, controller: _passwordController),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                height: 20.0,
                width: 20.0,
                child: Checkbox(
                  value: _rememberMe,
                  onChanged: (val) {
                    setState(() {
                      _rememberMe = val ?? false;
                    });
                  },
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '로그인 상태 유지',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _signInWithStudyShare,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 0,
            ),
            child: const Text(
              '스터디쉐어 ID 로그인',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLinkText('회원가입', onTap: _navigateToSignup),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_buildLoginForm(context)],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
