// lib/profile/services/profile_logic.dart (최종 병합 코드)

import 'package:flutter/material.dart';
import 'package:studyshare/note/services/note_service.dart';
import 'package:studyshare/community/services/community_service.dart';
import 'package:studyshare/auth_manager/AuthService.dart'; // [인증 로직 유지]

class ProfileLogic extends ChangeNotifier {
  final NoteService _noteService = NoteService();
  final CommunityService _communityService = CommunityService();

  // --- 상태 변수 ---
  bool _isLoading = true;
  int _noteCount = 0;
  int _postCount = 0;
  int _likeCount = 0;
  int _bookmarkCount = 0; // 💡 [통합] 북마크 개수 추가

  // ⭐️ 인증된 사용자 상태 변수 (File 1 유지)
  String? _userNickname;
  int? _currentUserId;

  // --- Getter ---
  String? get userNickname => _userNickname;
  int? get currentUserId => _currentUserId;
  bool get isLoading => _isLoading;

  // 로그인 상태 판단: userId가 null이 아니고 0보다 클 때만 로그인 상태로 간주
  bool get isLoggedIn {
    return _currentUserId != null && _currentUserId! > 0;
  }

  // UI 표시용: 닉네임이 없으면 '회원가입' 표시
  String get displayNickname => _userNickname ?? '회원가입';

  int get noteCount => _noteCount;
  int get postCount => _postCount;
  int get likeCount => _likeCount;
  int get bookmarkCount => _bookmarkCount; // 💡 [통합] Getter 추가

  // --- 초기화 ---
  ProfileLogic() {
    initializeProfile();
  }

  /// ⭐️ 초기화 로직 (File 1 유지):
  /// 1. AuthService를 통해 세션을 로드하고
  /// 2. 로그인 상태에 따라 프로필 데이터를 가져옵니다.
  Future<void> initializeProfile() async {
    // AuthService를 통해 세션을 로드
    await AuthService.loadSession();

    // 💡 임시: AuthService의 isLoggedIn 상태를 바탕으로 데이터 설정
    if (AuthService.isLoggedIn) {
      // 🚨 실제로는 AuthService에서 현재 로그인된 사용자의 ID와 닉네임을 가져와야 함
      _currentUserId = 1;
      _userNickname = "로그인 사용자"; // 예시 닉네임 (AuthService에서 가져와야 함)
      await fetchProfileData();
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ⭐️ 로그인/로그아웃 등 인증 상태 변경 시 호출 (File 1 유지)
  void setAuthData(int? userId, String? nickname) {
    _currentUserId = userId;
    _userNickname = nickname;
    notifyListeners();
    fetchProfileData();
  }

  /// ⭐️ 로그아웃 처리 (File 1 유지):
  /// AuthService를 통해 세션을 삭제하고 상태를 초기화합니다.
  Future<void> logout() async {
    // 1. AuthService 로그아웃 호출
    await AuthService.logout();

    // 2. ProfileLogic 상태 초기화
    _currentUserId = null;
    _userNickname = null;
    _noteCount = 0;
    _postCount = 0;
    _likeCount = 0;
    _bookmarkCount = 0;
    _isLoading = false;

    // 3. UI 업데이트 알림
    notifyListeners();
  }

  /// ⭐️ 프로필 데이터(노트 수, 게시글 수, 좋아요 수, 북마크 수)를 백엔드에서 가져오는 로직
  /// (File 2의 상세 로직을 File 1의 인증 구조에 통합)
  Future<void> fetchProfileData() async {
    _isLoading = true;
    notifyListeners();

    // 로그아웃 상태라면 로딩을 중단하고 0으로 초기화
    if (!isLoggedIn) {
      _noteCount = 0;
      _postCount = 0;
      _likeCount = 0;
      _bookmarkCount = 0;
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final userId = _currentUserId!; // 로그인 상태이므로 non-null 보장

      // 1. 작성한 노트 & 커뮤니티 글 가져오기
      final notes = await _noteService.getNotesByUserId(userId);
      final posts = await _communityService.getPostsByUserId(userId);

      // 2. 좋아요한 노트 & 커뮤니티 글 가져오기
      final likedNotes = await _noteService.fetchLikedNotes(userId);
      final likedCommunities =
          await _communityService.fetchLikedCommunities(userId);

      // 3. 북마크한 노트 & 커뮤니티 글 가져오기
      final bookmarkedNotes = await _noteService.fetchBookmarkedNotes(userId);
      final bookmarkedCommunities =
          await _communityService.fetchBookmarkedCommunities(userId);

      // 개수 업데이트 (노트 + 커뮤니티 합산)
      _noteCount = notes.length;
      _postCount = posts.length;
      _likeCount = likedNotes.length + likedCommunities.length;
      _bookmarkCount = bookmarkedNotes.length + bookmarkedCommunities.length;
    } catch (e) {
      print('Profile data fetch error: $e');
    } finally {
      // 데이터 로딩 완료
      _isLoading = false;
      notifyListeners();
    }
  }
}
