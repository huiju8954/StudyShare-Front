// lib/note/services/note_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io'; // SocketException 사용을 위해 추가
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/note_model.dart';
import 'package:studyshare/auth_manager/AuthService.dart'; // 인증 서비스 임포트

// 과목 이름과 DB ID 매핑 데이터
final Map<String, int> subjectToId = {
  '국어(공통)': 1,
  '화법과작문': 2,
  '독서': 3,
  '언어와 매체': 4,
  '문학': 5,
  '국어(기타)': 6,
  '수학(공통)': 7,
  '수학 I': 8,
  '수학 II': 9,
  '미적분': 10,
  '확률과 통계': 11,
  '기하': 12,
  '경제 수학': 13,
  '수학(기타)': 14,
  '영어(공통)': 15,
  '영어독해와 작문': 16,
  '영어회화': 17,
  '영어(기타)': 18,
  '한국사': 19,
  '통합사회': 20,
  '지리': 21,
  '역사': 22,
  '경제': 23,
  '정치와 법': 24,
  '윤리': 25,
  '사회(기타)': 26,
  '통합과학': 27,
  '물리학': 28,
  '화학': 29,
  '생명과학': 30,
  '지구과학': 31,
  '과학탐구실험': 32,
  '과학(기타)': 33,
};

class NoteService {
  static String get _baseUrl {
    const port = '8081'; // 백엔드 포트 8081

    if (kIsWeb) {
      return 'http://localhost:$port/notes';
    } else {
      // ⭐️ 고객님의 로컬 IP 주소로 변경: 192.168.199.1
      return 'http://192.168.199.1:$port/notes';
    }
  }

// 인증 쿠키를 포함하는 헤더 생성 함수
  Map<String, String> _getAuthHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final cookie = AuthService.sessionCookieHeader;
    if (cookie.isNotEmpty) {
      headers['Cookie'] = cookie;
    }
    return headers;
  }

  /// 서버의 상태를 확인합니다.
  Future<bool> checkServerStatus() async {
    try {
      final response = await http
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode >= 200 && response.statusCode < 500) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("서버 연결 실패 ($_baseUrl): $e");
      return false;
    }
  }

  /// 노트 등록 API (POST /notes)
  Future<bool> registerNote({
    required String title,
    required String bodyHtml,
    required String selectedSubject,
    required int userId,
    required int id2,
  }) async {
    final subjectId = subjectToId[selectedSubject] ?? 0;
    const fileUrl = '';

    final postData = {
      'title': title,
      'noteSubjectId': subjectId,
      'noteContent': bodyHtml,
      'noteFileUrl': fileUrl,
    };

    final url = Uri.parse(_baseUrl);
    print('================================================================');
    print('⭐️ [노트 등록] 요청 URL: $url');
    print('⭐️ [노트 등록] 요청 데이터: $postData');
    print('⭐️ [노트 등록] 요청 헤더: ${_getAuthHeaders()}');
    print('================================================================');

    try {
      final response = await http.post(
        url,
        headers: _getAuthHeaders(),
        body: jsonEncode(postData),
      );

      if (response.statusCode == 201) {
        print('✅ [노트 등록] 성공: 상태 코드 201');
        return true;
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // 401 Unauthorized 또는 403 Forbidden인 경우
        print('🚨 [노트 등록] 클라이언트 오류: 상태 코드 ${response.statusCode}');
        print('🚨 [노트 등록] 서버 응답 본문: ${response.body}');
        return false;
      } else {
        print('❌ [노트 등록] 서버 응답 실패: ${response.statusCode}, ${response.body}');
        return false;
      }
    } on TimeoutException {
      print('❌ [노트 등록] 네트워크 요청 시간 초과 (10초)');
      return false;
    } on SocketException catch (e) {
      // 연결 거부, 방화벽 차단 등 물리적 네트워크 오류
      print('❌ [노트 등록] 심각한 네트워크 오류 (SocketException)');
      print('❌ [노트 등록] 오류 메시지: ${e.message}');
      return false;
    } catch (e) {
      print('❌ [노트 등록] 기타 네트워크 통신 오류: ${e.runtimeType}');
      print('❌ [노트 등록] 오류 메시지: $e');
      return false;
    }
  }

  /// 모든 노트 조회 (GET /notes) - 인증 헤더 사용
  Future<List<NoteModel>> fetchAllNotes() async {
    try {
      final response = await http
          .get(
            Uri.parse(_baseUrl),
            headers: _getAuthHeaders(),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> notesJson =
            jsonDecode(utf8.decode(response.bodyBytes));

        return notesJson
            .map((json) {
              try {
                return NoteModel.fromJson(json);
              } catch (e) {
                print('JSON 변환 오류: $e');
                return null;
              }
            })
            .whereType<NoteModel>()
            .toList();
      } else {
        print('노트 조회 실패: ${response.statusCode}');
        return [];
      }
    } on TimeoutException {
      print('네트워크 요청 시간 초과');
      return [];
    } catch (e) {
      print('네트워크 통신 오류 (조회): $e');
      return [];
    }
  }

  /// 특정 사용자가 작성한 노트 조회 (GET /notes/user/{userId})
  Future<List<NoteModel>> getNotesByUserId(int userId) async {
    try {
      final url = Uri.parse('$_baseUrl/user/$userId');

      final response = await http
          .get(
            url,
            headers: _getAuthHeaders(),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> notesJson =
            jsonDecode(utf8.decode(response.bodyBytes));

        return notesJson.map((json) => NoteModel.fromJson(json)).toList();
      } else {
        print('유저별 노트 조회 실패: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('네트워크 통신 오류 (유저별 조회): $e');
      return [];
    }
  }

  /// 좋아요 요청 전송 (POST /notes/{id}/like)
  Future<bool> sendLikeRequest(int noteId, int userId) async {
    try {
      final url = Uri.parse('$_baseUrl/$noteId/like?userId=$userId');
      final response = await http.post(
        url,
        headers: _getAuthHeaders(),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("좋아요 요청 실패: $e");
      return false;
    }
  }

  /// 북마크 요청 전송 (POST /notes/{id}/bookmark)
  Future<bool> sendBookmarkRequest(int noteId, int userId) async {
    try {
      final url = Uri.parse('$_baseUrl/$noteId/bookmark?userId=$userId');
      final response = await http.post(
        url,
        headers: _getAuthHeaders(),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("북마크 요청 실패: $e");
      return false;
    }
  }

  /// 내가 좋아요한 노트 목록 가져오기 (GET /notes/user/{id}/likes)
  Future<List<NoteModel>> fetchLikedNotes(int userId) async {
    try {
      final url = Uri.parse('$_baseUrl/user/$userId/likes');
      final response = await http.get(
        url,
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> notesJson =
            jsonDecode(utf8.decode(response.bodyBytes));
        return notesJson.map((json) => NoteModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('좋아요 목록 조회 실패: $e');
      return [];
    }
  }

  /// 내가 북마크한 노트 목록 가져오기 (GET /notes/user/{id}/bookmarks)
  Future<List<NoteModel>> fetchBookmarkedNotes(int userId) async {
    try {
      final url = Uri.parse('$_baseUrl/user/$userId/bookmarks');
      final response = await http.get(
        url,
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> notesJson =
            jsonDecode(utf8.decode(response.bodyBytes));
        return notesJson.map((json) => NoteModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('북마크 목록 조회 실패: $e');
      return [];
    }
  }
}
