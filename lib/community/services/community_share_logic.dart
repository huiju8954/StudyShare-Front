// lib/community/services/community_share_logic.dart (최종 병합 코드)

import 'package:flutter/material.dart';
import '../models/community_model.dart';
import 'community_service.dart';

class CommunityShareLogic extends ChangeNotifier {
  final CommunityService _communityService = CommunityService();

  // 💡 [핵심] 현재 로그인한 유저 ID (임시 1) - 인증 구현 후 실제 ID로 교체 필요
  final int currentUserId = 1;

  // --- 상태 변수 ---
  bool _isServerConnected = false;
  bool _isLoadingStatus = true;
  List<CommunityModel> _posts = [];

  bool get isServerConnected => _isServerConnected;
  bool get isLoadingStatus => _isLoadingStatus;
  List<CommunityModel> get posts => _posts;

  CommunityShareLogic() {
    initializeData();
  }

  Future<void> initializeData() async {
    await _checkInitialServerStatus();
    await fetchPosts();
  }

  Future<void> _checkInitialServerStatus() async {
    final isConnected = await _communityService.checkServerStatus();
    _isServerConnected = isConnected;
    _isLoadingStatus = false;
    notifyListeners();
  }

  // 게시글 목록 조회 (정렬 로직 추가)
  Future<void> fetchPosts() async {
    // Service 시그니처에 맞춰 userId를 파라미터 없이 호출 (인증 헤더로 사용자 상태 전달)
    final fetchedPosts = await _communityService.fetchAllPosts();

    // [File 2] 최신순(날짜 내림차순) 정렬 적용
    fetchedPosts.sort((a, b) {
      DateTime dateA = DateTime.tryParse(a.createDate) ?? DateTime(2000);
      DateTime dateB = DateTime.tryParse(b.createDate) ?? DateTime(2000);
      return dateB.compareTo(dateA); // 최신 날짜가 먼저 오도록
    });

    _posts = fetchedPosts;
    notifyListeners();
  }

  Future<void> refreshData() async {
    await initializeData();
  }

  // ⭐️ 새 게시글 등록 메서드 (File 1의 구현 유지)
  Future<bool> registerNewPost({
    required String title,
    required String content,
    required String category,
    required int userId, // Service에서 인증 기반으로 사용해야 함
  }) async {
    final success = await _communityService.registerPost(
      title: title,
      content: content,
      category: category,
      userId: userId,
    );

    if (success) {
      await refreshData(); // 성공 시 목록 새로고침
    }
    return success;
  }

  // 💡 좋아요 토글 (copyWith를 사용한 Optimistic Update)
  Future<void> toggleLike(int postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    // 1. 좋아요 상태 반전 및 숫자 조정
    final newIsLiked = !post.isLiked;
    final newCount = newIsLiked ? post.likesCount + 1 : post.likesCount - 1;

    // 2. 화면 먼저 갱신 (Optimistic Update) - [File 2의 copyWith 사용]
    _posts[index] = post.copyWith(
      isLiked: newIsLiked,
      likesCount: newCount < 0 ? 0 : newCount, // 음수 방지
    );
    notifyListeners();

    // 3. 서버로 전송
    final success =
        await _communityService.sendLikeRequest(postId, currentUserId);

    // 4. 실패 시 롤백
    if (!success) {
      print("서버 통신 실패: 좋아요 롤백");
      _posts[index] = post; // 원래 객체로 복구
      notifyListeners();
    }
  }

  // 💡 북마크 토글 (copyWith를 사용한 Optimistic Update)
  Future<void> toggleBookmark(int postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    final newIsBookmarked = !post.isBookmarked;
    final newCount =
        newIsBookmarked ? post.bookmarksCount + 1 : post.bookmarksCount - 1;

    // 화면 먼저 갱신 (Optimistic Update) - [File 2의 copyWith 사용]
    _posts[index] = post.copyWith(
      isBookmarked: newIsBookmarked,
      bookmarksCount: newCount < 0 ? 0 : newCount, // 음수 방지
    );
    notifyListeners();

    // 서버로 전송
    final success =
        await _communityService.sendBookmarkRequest(postId, currentUserId);

    // 실패 시 롤백
    if (!success) {
      print("서버 통신 실패: 북마크 롤백");
      _posts[index] = post;
      notifyListeners();
    }
  }

  // 💡 [File 2에서 추가] 검색 기능
  List<CommunityModel> searchPosts(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    return _posts.where((post) {
      return post.title.toLowerCase().contains(q) ||
          post.content.toLowerCase().contains(q);
    }).toList();
  }

  // 상대 시간 포매팅 함수
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

// -------------------------------------------------------------
// Model Extension (copyWith 메서드 추가 - File 2)
// -------------------------------------------------------------
extension CommunityModelExtension on CommunityModel {
  CommunityModel copyWith({
    bool? isLiked,
    int? likesCount,
    bool? isBookmarked,
    int? bookmarksCount,
  }) {
    return CommunityModel(
      id: id,
      userId: userId,
      title: title,
      category: category,
      content: content,
      likesCount: likesCount ?? this.likesCount,
      commentCount: commentCount,
      commentLikeCount: commentLikeCount,
      createDate: createDate,
      bookmarksCount: bookmarksCount ?? this.bookmarksCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
