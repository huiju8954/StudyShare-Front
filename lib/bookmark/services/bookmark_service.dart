// lib/bookmark/services/bookmark_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/bookmark_model.dart';

class BookmarkService {

  // 💡 [설정] 백엔드 포트 8081과 /bookmarks 엔드포인트 사용
  static String get _baseUrl {
    const port = '8081';
    if (kIsWeb) {
      return 'http://localhost:$port/bookmarks';
    } else {
      // 안드로이드 에뮬레이터 IP
      return 'http://10.0.2.2:$port/bookmarks';
    }
  }

  // 서버 상태 체크
  Future<bool> checkServerStatus() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl)).timeout(const Duration(seconds: 3));
      return response.statusCode >= 200 && response.statusCode < 500;
    } catch (e) {
      print("서버 연결 실패 ($_baseUrl): $e");
      return false;
    }
  }

  // 특정 사용자의 북마크 목록 조회 (GET /bookmarks/user/{id})
  Future<List<BookmarkModel>> getUserBookmarks(int userId) async {
    try {
      // 예: http://localhost:8081/bookmarks/user/1
      final url = '$_baseUrl/user/$userId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => BookmarkModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('네트워크 통신 오류 (북마크 조회): $e');
      return [];
    }
  }

// 북마크 추가/삭제 기능은 필요시 추가 (POST/DELETE)
}