import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/comment_model.dart';
import 'package:studyshare/auth_manager/AuthService.dart'; // 💡 [유지] 인증 서비스 임포트

class CommentService {
  // ⭐️ [유지] 환경별 베이스 URL 설정 (8081 포트 통일)
  final String baseUrl = kIsWeb
      ? 'http://localhost:8081/comments' // 웹 환경
      : Platform.isAndroid
          ? 'http://10.0.2.2:8081/comments' // 안드로이드 에뮬레이터
          : 'http://localhost:8081/comments'; // iOS 시뮬레이터, 데스크톱 등

  // 1. 댓글 작성 (POST)
  Future<bool> writeComment({
    int? noteId,
    int? communityId,
    required String content,
    int? parentCommentId, // ✅ [통합] 대댓글용 부모 ID 파라미터 추가
  }) async {
    final url = Uri.parse(baseUrl);

    // ✅ [유지] 세션 쿠키 로드 및 체크 (인증 로직)
    final sessionCookie = await AuthService.loadSession();
    if (sessionCookie == null || sessionCookie.isEmpty) {
      if (kDebugMode) print('댓글 작성 실패: 로그인 세션이 없습니다.');
      return false;
    }

    // 보낼 데이터 (JSON)
    final Map<String, dynamic> bodyData = {
      'content': content,
    };
    if (noteId != null) bodyData['noteId'] = noteId;
    if (communityId != null) bodyData['communityId'] = communityId;

    // ✅ [통합] 대댓글이면 부모 ID 포함
    if (parentCommentId != null) bodyData['parentCommentId'] = parentCommentId;

    try {
      // ✅ [통합] HTTP 요청 헤더에 세션 쿠키 및 UTF-8 인코딩 추가
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': sessionCookie, // 인증 정보 (세션 쿠키) 추가
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 201) {
        return true; // 성공
      } else {
        if (kDebugMode) {
          print(
              '댓글 작성 실패: Status ${response.statusCode}, Body: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) print('에러 발생: $e');
      return false;
    }
  }

  // 2. 댓글 목록 조회 (GET)
  Future<List<CommentModel>> getComments(String type, int id) async {
    final url = Uri.parse('$baseUrl/$type/$id');

    // ✅ [유지] 세션 쿠키 로드 및 체크 (인증 로직)
    final sessionCookie = await AuthService.loadSession();
    if (sessionCookie == null || sessionCookie.isEmpty) {
      if (kDebugMode) print('댓글 조회 실패: 로그인 세션이 없습니다.');
      return [];
    }

    // ✅ [통합] HTTP 요청 헤더에 세션 쿠키 및 UTF-8 인코딩 추가
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Cookie': sessionCookie,
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        // 한글 깨짐 방지 (utf8.decode)
        final List<dynamic> jsonData =
            jsonDecode(utf8.decode(response.bodyBytes));
        return jsonData.map((json) => CommentModel.fromJson(json)).toList();
      } else {
        if (kDebugMode) print('댓글 조회 실패: Status ${response.statusCode}');
        return [];
      }
    } catch (e) {
      if (kDebugMode) print('에러 발생: $e');
      return [];
    }
  }
}
