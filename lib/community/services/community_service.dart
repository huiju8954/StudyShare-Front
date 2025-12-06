// lib/community/services/community_service.dart (최종 병합 코드)

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/community_model.dart';
import 'package:studyshare/auth_manager/AuthService.dart'; // [File 1] AuthService 임포트

class CommunityService {
  static String get _baseUrl {
    const port = '8081';
    if (kIsWeb) {
      return 'http://localhost:$port/communities';
    } else {
      // [File 2의 에뮬레이터 IP 주소 채택] 10.0.2.2는 안드로이드 에뮬레이터 루프백 주소입니다.
      // ⭐️ 물리 기기 테스트 시 'http://192.168.x.x:$port/communities' (File 1)로 변경 필요
      return 'http://10.0.2.2:$port/communities';
    }
  }

  // [File 1] 인증 쿠키를 포함하는 헤더 생성 함수
  Map<String, String> _getAuthHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final cookie = AuthService.sessionCookieHeader;
    if (cookie.isNotEmpty) {
      headers['Cookie'] = cookie; // 세션 쿠키 추가
    }
    return headers;
  }

  // 서버 상태 체크 (File 2의 정확한 상태 코드 범위 및 디버깅 메시지 사용)
  Future<bool> checkServerStatus() async {
    try {
      final response = await http
          .get(Uri.parse(_baseUrl), headers: _getAuthHeaders())
          .timeout(const Duration(seconds: 3));
      // 2xx ~ 4xx 상태 코드를 성공으로 간주
      return response.statusCode >= 200 && response.statusCode < 500;
    } catch (e) {
      print("❌ 서버 연결 실패 ($_baseUrl): $e"); // [File 2의 메시지]
      return false;
    }
  }

  // 모든 게시글 조회 (GET /communities) - [File 1] userId 파라미터 없이 인증 헤더 사용
  Future<List<CommunityModel>> fetchAllPosts() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: _getAuthHeaders(), // 인증 헤더 사용
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            jsonDecode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => CommunityModel.fromJson(json)).toList();
      }
      // [File 2의 상세 응답 실패 출력 추가]
      print('❌ 전체 조회 실패: ${response.statusCode}');
      return [];
    } catch (e) {
      print('❌ 전체 조회 오류 (커뮤니티 조회): $e');
      return [];
    }
  }

  // 사용자별 게시글 조회 (GET /communities/user/{userId}) - [File 2의 디버깅 추가]
  Future<List<CommunityModel>> getPostsByUserId(int userId) async {
    final url = '$_baseUrl/user/$userId';
    print("🔍 [요청 시작] 내 작성글 조회 URL: $url"); // [File 2]

    try {
      final response = await http.get(Uri.parse(url),
          headers: _getAuthHeaders()); // [File 1] 인증 헤더 사용

      print("🔍 [응답 코드] ${response.statusCode}"); // [File 2]

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            jsonDecode(utf8.decode(response.bodyBytes));
        print("✅ [데이터 수신] ${jsonList.length}개의 게시글 발견"); // [File 2]
        return jsonList.map((json) => CommunityModel.fromJson(json)).toList();
      }
      // [File 2의 상세 서버 응답 오류 출력 추가]
      print("❌ [서버 응답 오류] 상태 코드: ${response.statusCode}");
      print("❌ [서버 메시지] ${response.body}");
      return [];
    } catch (e) {
      print('❌ [앱 내부 오류] 네트워크 통신 오류 (사용자 게시글 조회): $e'); // 메시지 통합
      return [];
    }
  }

  // 게시글 등록 (POST /communities) - [File 1의 인증 기반 로직 채택]
  Future<bool> registerPost({
    required String title,
    required String content,
    required String category,
    int userId = 1, // 클라이언트에서 보내지 않으나, 함수 시그니처는 유지
  }) async {
    final postData = {
      // 'user_id': userId, // [File 1] 서버에서 인증 기반으로 처리하므로 클라이언트에서 보낼 필요 없음
      'title': title,
      'content': content,
      'category': category,
    };

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _getAuthHeaders(), // 인증 헤더 사용
        body: jsonEncode(postData),
      );

      // [File 2의 상세 오류 출력 추가]
      if (response.statusCode != 201 && response.statusCode != 200) {
        print("❌ [서버 응답 오류] 게시글 등록 실패 상태 코드: ${response.statusCode}");
        print("❌ [서버 메시지] ${response.body}");
      }

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('❌ 게시글 등록 오류: $e');
      return false;
    }
  }

  // 좋아요 요청 (POST /communities/{id}/like)
  Future<bool> sendLikeRequest(int id, int userId) async {
    try {
      // userId를 쿼리 파라미터로 보냄 (API 명세 준수)
      final url = Uri.parse('$_baseUrl/$id/like?userId=$userId');
      final response = await http.post(
        url,
        headers: _getAuthHeaders(), // 인증 헤더 사용
      );
      // [File 2의 간단한 반환값과 File 1의 상세 출력 통합]
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('❌ 좋아요 요청 실패 상태 코드: ${response.statusCode}');
      }
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('❌ 좋아요 요청 실패: $e'); // [File 1]
      return false;
    }
  }

  // 북마크 요청 (POST /communities/{id}/bookmark)
  Future<bool> sendBookmarkRequest(int id, int userId) async {
    try {
      // userId를 쿼리 파라미터로 보냄 (API 명세 준수)
      final url = Uri.parse('$_baseUrl/$id/bookmark?userId=$userId');
      final response = await http.post(
        url,
        headers: _getAuthHeaders(), // 인증 헤더 사용
      );
      // [File 2의 간단한 반환값과 File 1의 상세 출력 통합]
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('❌ 북마크 요청 실패 상태 코드: ${response.statusCode}');
      }
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('❌ 북마크 요청 실패: $e'); // [File 1]
      return false;
    }
  }

  // 내가 북마크한 커뮤니티 글 목록 가져오기 (GET /communities/user/{id}/bookmarks)
  Future<List<CommunityModel>> fetchBookmarkedCommunities(int userId) async {
    final url = Uri.parse('$_baseUrl/user/$userId/bookmarks'); // [File 2]
    try {
      final response = await http.get(
        url,
        headers: _getAuthHeaders(), // 인증 헤더 사용
      );

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));
        print("✅ [북마크] ${list.length}개 발견"); // [File 2]
        return list.map((json) => CommunityModel.fromJson(json)).toList();
      }
      print('❌ 북마크 목록 조회 실패: ${response.statusCode}');
      return [];
    } catch (e) {
      print('❌ 북마크 목록 조회 실패: $e');
      return [];
    }
  }

  // 내가 좋아요한 커뮤니티 글 목록 가져오기 (GET /communities/user/{id}/likes)
  Future<List<CommunityModel>> fetchLikedCommunities(int userId) async {
    final url = Uri.parse('$_baseUrl/user/$userId/likes'); // [File 2]
    try {
      final response = await http.get(
        url,
        headers: _getAuthHeaders(), // 인증 헤더 사용
      );

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));
        print("✅ [좋아요] ${list.length}개 발견"); // [File 2]
        return list.map((json) => CommunityModel.fromJson(json)).toList();
      }
      print('❌ 좋아요 목록 조회 실패: ${response.statusCode}');
      return [];
    } catch (e) {
      print('❌ 좋아요 목록 조회 실패: $e');
      return [];
    }
  }
}
