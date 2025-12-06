// lib/like/screens/my_likes_list_screen.dart (최종 병합 코드)

import 'package:flutter/material.dart';

// ⭐️ [Import Fix] Ambiguous Import 방지 및 필요한 화면 임포트 통합
import 'package:studyshare/community/screens/my_community_screen.dart';
import 'package:studyshare/community/screens/my_write_community_screen.dart';
import 'package:studyshare/main/screens/home_main_screen.dart';
// MyBookmarkScreen 충돌 방지 위해 hide 적용 (File 1 반영)
import 'package:studyshare/profile/screens/profile_screen.dart'
    hide MyBookmarkScreen;
import 'package:studyshare/search/screens/search_screen.dart'
    hide MyBookmarkScreen;
import 'package:studyshare/widgets/header.dart';
import 'package:studyshare/Login/LoginScreen.dart'; // 이전 단계 병합 결과 따름
import 'package:studyshare/note/screens/my_note_screen.dart';
import 'package:studyshare/bookmark/screens/my_bookmark_screen.dart'; // 실제 북마크 화면

// 💡 서비스 & 모델 임포트
import 'package:studyshare/note/services/note_service.dart';
import 'package:studyshare/note/models/note_model.dart';
import 'package:studyshare/community/services/community_service.dart';
import 'package:studyshare/community/models/community_model.dart';

// 💡 상세 화면 임포트
import 'package:studyshare/note/screens/note_detail_screen.dart';
import 'package:studyshare/community/screens/community_detail_screen.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({super.key});

  @override
  State<LikesScreen> createState() =>
      _LikesScreenState(); // _LikesScreenState로 통일
}

class _LikesScreenState extends State<LikesScreen> {
  final NoteService _noteService = NoteService();
  final CommunityService _communityService = CommunityService();

  // 💡 노트와 커뮤니티 글을 섞어서 담을 리스트 (File 2 반영)
  List<dynamic> _allItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllLikes();
  }

  // 💡 좋아요한 노트 & 게시글 모두 가져와서 합치기 (File 2 반영)
  Future<void> _loadAllLikes() async {
    // 임시 유저 ID 1 (나중에 로그인 정보로 교체)
    const int userId = 1;

    final notes = await _noteService.fetchLikedNotes(userId);
    final communities = await _communityService.fetchLikedCommunities(userId);

    if (mounted) {
      setState(() {
        _allItems = [...notes, ...communities];
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });
    await _loadAllLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. 헤더 (모든 네비게이션 경로 포함)
            AppHeader(
              onLogoTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainScreen())),
              onSearchTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchScreen())),
              onProfileTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen())),
              onWriteNoteTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyNoteScreen())),
              onLoginTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen())),
              onWriteCommunityTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyWriteCommunityScreen())),
              onBookmarkTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyBookmarkScreen())),
            ),

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 40.0),
                  child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: Colors.red))
                        : _allItems.isEmpty
                            ? _buildEmptyState()
                            : _buildDataList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // 💡 데이터가 없을 때 (File 2 UI 반영 및 좋아요 테마 적용)
  Widget _buildEmptyState() {
    return Column(
      children: [
        Container(
          width: 120, height: 120,
          decoration: const ShapeDecoration(
              color: Color(0xFFFFE3E3), shape: OvalBorder()), // 연한 빨강
          child: const Center(
              child: Icon(Icons.favorite, color: Colors.red, size: 50)),
        ),
        const SizedBox(height: 30),
        const Text('좋아요',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400)),
        const SizedBox(height: 15),
        const Text('좋아요한 콘텐츠가 없습니다',
            style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 24)),
        const SizedBox(height: 100),
        Image.asset('assets/images/my_likes_list_gray.png',
            width: 100, height: 90),
        const SizedBox(height: 20),
        const Text('아직 좋아요한 게시글이 없습니다',
            style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 24)),
        const SizedBox(height: 25),
        ElevatedButton.icon(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MainScreen())),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFE3E3),
            foregroundColor: Colors.red,
            elevation: 0,
            minimumSize: const Size(220, 60),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.home, size: 28),
          label: const Text('콘텐츠 구경하러 가기',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
        ),
      ],
    );
  }

  // 💡 데이터 리스트 (File 2 UI 반영 및 상세 이동 기능 추가)
  Widget _buildDataList() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const ShapeDecoration(
              color: Color(0xFFFFE3E3), shape: OvalBorder()),
          child: const Center(
              child: Icon(Icons.favorite, color: Colors.red, size: 50)),
        ),
        const SizedBox(height: 30),
        const Text('좋아요',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400)),
        const SizedBox(height: 15),
        Text('좋아요한 ${_allItems.length}개의 콘텐츠를 확인해보세요',
            style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 24)),
        const SizedBox(height: 60),
        ..._allItems.map((item) {
          String title = '';
          String category = '';
          String author = '';
          String date = '';
          String preview = '';
          int likes = 0;
          int comments = 0;

          // 데이터 타입 확인 및 값 추출
          if (item is NoteModel) {
            title = item.title;
            category = "노트";
            author = "User ${item.userId}";
            date = item.createDate;
            preview = item.noteContent.replaceAll(RegExp(r'<[^>]*>'), '');
            likes = item.likesCount;
            comments = item.commentsCount;
          } else if (item is CommunityModel) {
            title = item.title;
            category = item.category;
            author = "User ${item.userId}";
            date = item.createDate;
            preview = item.content.replaceAll(RegExp(r'<[^>]*>'), '');
            likes = item.likesCount;
            comments = item.commentCount;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: GestureDetector(
                // 💡 [기능 추가] 상세 화면 이동
                onTap: () {
                  if (item is NoteModel) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NoteDetailScreen(note: item)));
                  } else if (item is CommunityModel) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CommunityDetailScreen(post: item)));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(35),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color(0xFFCFCFCF)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadows: const [
                      BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 12,
                          offset: Offset(0, 6))
                    ],
                  ),
                  child: LikesPostCardContent(
                    title: title.isNotEmpty ? title : "(제목 없음)",
                    category: category,
                    author: author,
                    date: date,
                    preview: preview.length > 100
                        ? "${preview.substring(0, 100)}..."
                        : preview,
                    likes: likes,
                    comments: comments,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 80),
      ],
    );
  }
}

// 💡 리스트 아이템 UI (File 2 반영)
class LikesPostCardContent extends StatelessWidget {
  final String title;
  final String category;
  final String author;
  final String date;
  final String preview;
  final int likes;
  final int comments;

  const LikesPostCardContent({
    super.key,
    required this.title,
    required this.category,
    required this.author,
    required this.date,
    required this.preview,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
                radius: 24,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.person, size: 48, color: Colors.grey)),
            SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 16),
        Text(title,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: Colors.red, width: 1.2), // 좋아요 테마: 빨간색 테두리
              ),
              child: Text(category,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 12),
            Text('$author · $date',
                style: const TextStyle(
                    color: Color(0xFFCFCFCF),
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 20),
        Text(preview,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.w500, height: 1.5),
            maxLines: 3,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 55),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite,
                    color: Colors.red, size: 36), // 좋아요 아이콘
                const SizedBox(width: 8),
                Text('$likes',
                    style: const TextStyle(
                        color: Color(0xFFCFCFCF),
                        fontSize: 22,
                        fontWeight: FontWeight.w700)),
                const SizedBox(width: 20),
                const Icon(Icons.comment_outlined,
                    color: Colors.black54, size: 32),
                const SizedBox(width: 8),
                Text('$comments',
                    style: const TextStyle(
                        color: Color(0xFFCFCFCF),
                        fontSize: 22,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            // 오른쪽 하단 아이콘: 좋아요 화면이므로 채워진 하트 아이콘 표시
            const Icon(Icons.favorite, size: 36, color: Colors.red),
          ],
        ),
      ],
    );
  }
}
