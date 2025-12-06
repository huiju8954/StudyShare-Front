// lib/auth_manager/AuthService.dart

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _sessionKey = 'session_cookie';
  static String? _sessionCookie;

  // ⭐️ 세션 쿠키 저장
  static Future<void> saveSession(String cookie) async {
    final prefs = await SharedPreferences.getInstance();
    _sessionCookie = cookie;
    await prefs.setString(_sessionKey, cookie);
  }

  // ⭐️ 세션 쿠키 로드
  static Future<String?> loadSession() async {
    if (_sessionCookie != null) {
      return _sessionCookie;
    }
    final prefs = await SharedPreferences.getInstance();
    _sessionCookie = prefs.getString(_sessionKey);
    return _sessionCookie;
  }

  // ⭐️ 로그인 상태 확인
  static bool get isLoggedIn => _sessionCookie != null && _sessionCookie!.isNotEmpty;
  
  // ⭐️ 세션 쿠키를 HTTP 요청 헤더 형식으로 반환
  static String get sessionCookieHeader => _sessionCookie ?? '';

  // ⭐️ 로그아웃 (세션 쿠키 삭제)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _sessionCookie = null;
    await prefs.remove(_sessionKey);
  }
}