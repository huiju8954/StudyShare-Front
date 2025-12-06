// lib/services/comment_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/comment_model.dart';
import 'package:studyshare/auth_manager/AuthService.dart'; // AuthManager 임포트 추가

class CommentService {
  // ⭐️ [수정] 모든 포트를 백엔드 서버 포트인 8081로 통일
  final String baseUrl = kIsWeb
      ? 'http://localhost:8081/comments' // 웹 환경
      : Platform.isAndroid
          ? 'http://10.0.2.2:8081/comments' // 안드로이드 에뮬레이터
          : 'http://localhost:8081/comments'; // iOS 시뮬레이터, 데스크톱 등

  // 1. 댓글 작성 (POST)
  // noteId나 communityId 중 하나만 값을 넣고, 나머지는 null로 보내면 됩니다.
  Future<bool> writeComment(
      {int? noteId, int? communityId, required String content}) async {
    final url = Uri.parse(baseUrl);

    // 세션 쿠키 로드 및 체크
    final sessionCookie = await AuthService.loadSession();
    if (sessionCookie == null || sessionCookie.isEmpty) {
      print('댓글 작성 실패: 로그인 세션이 없습니다.');
      return false;
    }

    // 보낼 데이터 (JSON)
    final Map<String, dynamic> bodyData = {
      'content': content,
    };
    if (noteId != null) bodyData['noteId'] = noteId;
    if (communityId != null) bodyData['communityId'] = communityId;

    try {
      // HTTP 요청 헤더에 세션 쿠키 추가
      final headers = {
        'Content-Type': 'application/json',
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
        // 응답 상태 코드가 201이 아닐 경우 (예: 401 Unauthorized, 403 Forbidden)
        print(
            '댓글 작성 실패: Status ${response.statusCode}, Body: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');
        return false;
      }
    } catch (e) {
      print('에러 발생: $e');
      return false;
    }
  }

  // 2. 댓글 목록 조회 (GET)
  // type: "note" 또는 "community"
  Future<List<CommentModel>> getComments(String type, int id) async {
    // 예: /comments/note/1 또는 /comments/community/1
    final url = Uri.parse('$baseUrl/$type/$id');

    // 세션 쿠키 로드 및 체크
    final sessionCookie = await AuthService.loadSession();
    if (sessionCookie == null || sessionCookie.isEmpty) {
      print('댓글 조회 실패: 로그인 세션이 없습니다.');
      return [];
    }

    // HTTP 요청 헤더에 세션 쿠키 추가
    final headers = {'Cookie': sessionCookie};

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
        print('댓글 조회 실패: Status ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('에러 발생: $e');
      return [];
    }
  }
}
