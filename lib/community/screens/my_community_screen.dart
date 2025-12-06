// lib/community/screens/my_community_screen.dart (최종 병합 코드 - 오류 수정 완료)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyshare/community/screens/my_write_community_screen.dart';
import 'package:studyshare/main/screens/home_main_screen.dart';
import 'package:studyshare/profile/screens/profile_screen.dart'
    hide MyBookmarkScreen;
import 'package:studyshare/search/screens/search_screen.dart'
    hide MyBookmarkScreen;
import 'package:studyshare/widgets/header.dart';

import 'package:studyshare/Login/LoginScreen.dart';

import 'package:studyshare/community/services/community_share_logic.dart';
import 'package:studyshare/community/models/community_model.dart';

import 'package:studyshare/note/screens/my_note_screen.dart';
import 'package:studyshare/bookmark/screens/my_bookmark_screen.dart';
import 'package:studyshare/community/screens/community_detail_screen.dart';

class MyCommunityScreen extends StatelessWidget {
  const MyCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityShareLogic>(
      builder: (context, logic, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Header
                AppHeader(
                  onLogoTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen())),
                  onSearchTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchScreen())),
                  onProfileTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen())),
                  onWriteNoteTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyNoteScreen())),
                  onLoginTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen())),
                  onWriteCommunityTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MyWriteCommunityScreen())),
                  onBookmarkTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyBookmarkScreen())),
                ),

                // 2. [핵심 콘텐츠] 상태에 따른 내용 표시
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 40.0),
                      child: RefreshIndicator(
                        onRefresh: logic.refreshData,
                        child: _buildContent(context, logic),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  // 데이터 상태에 따라 Empty State 또는 List State를 반환하는 빌더 함수
  Widget _buildContent(BuildContext context, CommunityShareLogic logic) {
    if (logic.isLoadingStatus) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.only(top: 80.0),
        child: CircularProgressIndicator(),
      ));
    }

    if (logic.posts.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildDataList(context, logic.posts);
  }

  // 데이터가 없을 때의 UI (Empty State)
  Widget _buildEmptyState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: const ShapeDecoration(
              color: Color(0xFFFFF2CB), shape: OvalBorder()),
          child: Center(
            child: Image.asset('assets/images/my_write_post_yellow.png',
                width: 64, height: 58),
          ),
        ),
        const SizedBox(height: 30),
        const Text('커뮤니티',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400)),
        const SizedBox(height: 15),
        const Text('등록된 게시글이 없습니다',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 24)),
        const SizedBox(height: 100),
        Image.asset('assets/images/my_write_post_gray.png',
            width: 100, height: 90),
        const SizedBox(height: 20),
        const Text('아직 작성된 글이 없습니다',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 24)),
        const SizedBox(height: 25),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyWriteCommunityScreen()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFF2CB),
            foregroundColor: const Color(0xFFF4A908),
            elevation: 0,
            minimumSize: const Size(200, 60),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.add, size: 28),
          label: const Text('새 게시글 작성',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
        ),
      ],
    );
  }

  // 데이터가 있을 때의 UI (카드 리스트)
  Widget _buildDataList(BuildContext context, List<CommunityModel> posts) {
    final logic = Provider.of<CommunityShareLogic>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 상단 제목 및 카운트
        Container(
          width: 100,
          height: 100,
          decoration: const ShapeDecoration(
              color: Color(0xFFFFF2CB), shape: OvalBorder()),
          child: Center(
            child: Image.asset('assets/images/my_write_post_yellow.png',
                width: 55, height: 50),
          ),
        ),
        const SizedBox(height: 30),
        const Text('커뮤니티',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400)),
        const SizedBox(height: 15),
        Text('${posts.length}개의 게시글을 확인해보세요',
            style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 24)),
        const SizedBox(height: 60),

        // 노트 데이터 목록 (카드 반복)
        ...posts.map((post) {
          final displayDate = logic.formatRelativeTime(post.createDate);

          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunityDetailScreen(post: post),
                    ),
                  );
                  logic.refreshData();
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
                  child: PostCardContent(
                    title: post.title.isNotEmpty ? post.title : "(제목 없음)",
                    category: post.category,
                    author: "User ${post.userId}",
                    date: displayDate,
                    preview: post.content.length > 100
                        ? "${post.content.substring(0, 100)}..."
                        : post.content,
                    likes: post.likesCount,
                    comments: post.commentCount,
                    isLiked: post.isLiked,
                    isBookmarked: post.isBookmarked,
                    onLikeTap: () => logic.toggleLike(post.id),
                    onBookmarkTap: () => logic.toggleBookmark(post.id),
                  ),
                ),
              ),
            ),
          );
        }).toList(),

        // 하단 '새 게시글 작성' 버튼
        const SizedBox(height: 60),
        Center(
          child: ElevatedButton.icon(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyWriteCommunityScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF4C542),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(220, 65),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add, size: 30),
            label: const Text('새 게시글 작성',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}

// =================================================================
// PostCardContent 클래스 (오타 수정: FontWeight.w50 -> FontWeight.w500)
// =================================================================
class PostCardContent extends StatelessWidget {
  final String title;
  final String category;
  final String author;
  final String date;
  final String preview;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isBookmarked;
  final VoidCallback onLikeTap;
  final VoidCallback onBookmarkTap;

  const PostCardContent({
    super.key,
    required this.title,
    required this.category,
    required this.author,
    required this.date,
    required this.preview,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.isBookmarked,
    required this.onLikeTap,
    required this.onBookmarkTap,
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
            style: const TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFF4A908), width: 1.2),
              ),
              child: Text(category,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 12),
            Text('$author · $date',
                style: const TextStyle(
                    color: Color(0xFFCFCFCF),
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 20),
        Text(preview.replaceAll(RegExp(r'<[^>]*>'), ''),
            style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight
                    .w500, // 👈 FIX: FontWeight.w50 -> FontWeight.w500
                height: 1.5),
            maxLines: 3,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 55),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: onLikeTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                            size: 36),
                        const SizedBox(width: 8),
                        Text('$likes',
                            style: const TextStyle(
                                color: Color(0xFFCFCFCF),
                                fontSize: 22,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        const Icon(Icons.comment_outlined,
                            color: Colors.black54, size: 32),
                        const SizedBox(width: 8),
                        Text('$comments',
                            style: const TextStyle(
                                color: Color(0xFFCFCFCF),
                                fontSize: 22,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: onBookmarkTap,
              child: Icon(
                  isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_border_outlined,
                  size: 36,
                  color:
                      isBookmarked ? const Color(0xFFF4A908) : Colors.black54),
            ),
          ],
        ),
      ],
    );
  }
}
