// lib/bookmark/services/bookmark_logic.dart

import 'package:flutter/material.dart';
import '../models/bookmark_model.dart';
import 'bookmark_service.dart';

class BookmarkLogic extends ChangeNotifier {
  final BookmarkService _bookmarkService = BookmarkService();

  // --- 상태 변수 ---
  bool _isServerConnected = false;
  bool _isLoadingStatus = true;
  List<BookmarkModel> _bookmarks = [];

  bool get isServerConnected => _isServerConnected;
  bool get isLoadingStatus => _isLoadingStatus;
  List<BookmarkModel> get bookmarks => _bookmarks;

  BookmarkLogic() {
    initializeData();
  }

  Future<void> initializeData() async {
    await _checkInitialServerStatus();
    await fetchUserBookmarks();
  }

  Future<void> _checkInitialServerStatus() async {
    final isConnected = await _bookmarkService.checkServerStatus();
    _isServerConnected = isConnected;
    _isLoadingStatus = false;
    notifyListeners();
  }

  Future<void> fetchUserBookmarks() async {
    // 💡 현재 로그인한 유저 ID를 넣어야 함 (임시로 1)
    final fetchedBookmarks = await _bookmarkService.getUserBookmarks(1);
    _bookmarks = fetchedBookmarks;
    notifyListeners();
  }

  Future<void> refreshData() async {
    await initializeData();
  }

  // 날짜 포맷팅 (CommunityLogic과 동일)
  String formatRelativeTime(String createDateString) {
    if (createDateString.isEmpty) return '날짜 정보 없음';

    final createdDate = DateTime.tryParse(createDateString);
    if (createdDate == null) return '날짜 형식 오류';

    final now = DateTime.now();
    final difference = now.difference(createdDate);

    if (difference.inSeconds < 60) {
      final seconds = difference.inSeconds;
      return '${seconds < 1 ? 1 : seconds}초 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays <= 31) {
      return '${difference.inDays}일 전';
    } else {
      final months = difference.inDays ~/ 30;
      return '$months달 전';
    }
  }
}