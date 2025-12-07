import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyshare/bookmark/screens/my_bookmark_screen.dart';
import 'package:studyshare/community/screens/my_community_screen.dart';
// ✅ [통합] 친구 버전의 Login_UI.dart를 사용하고, 다른 스크린 임포트 경로를 수정했습니다.
import 'package:studyshare/community/screens/my_write_community_screen.dart';
import 'package:studyshare/Login/LoginScreen.dart';
import 'package:studyshare/main/screens/home_main_screen.dart';
import 'package:studyshare/profile/screens/profile_screen.dart';
import 'package:studyshare/search/screens/search_screen.dart';
import 'package:studyshare/widgets/header.dart';
import 'package:studyshare/note/services/note_share_logic.dart';
import 'package:studyshare/note/models/note_model.dart';
import '../screens/my_write_note_screen.dart';
import 'package:studyshare/note/screens/note_detail_screen.dart';

class MyNoteScreen extends StatelessWidget {
  const MyNoteScreen({super.key});

  // ✅ [통합] HTML 태그 제거 및 텍스트 정리 함수 추가 (NoteCardContent가 아닌 여기서 처리)
  String _stripHtml(String htmlString) {
    // 1. <...> 태그 제거
    String text = htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
    // 2. &nbsp; 등 특수문자 공백 처리
    text = text.replaceAll('&nbsp;', ' ');
    // 3. 앞뒤 공백 제거 및 연속 공백 정리
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  @override
  Widget build(BuildContext context) {
    // Logic 객체를 Provider를 통해 구독하여 상태를 받아옵니다.
    return Consumer<StudyShareLogic>(
      builder: (context, logic, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          // Scaffold body를 SingleChildScrollView로 감싸서 전체 스크롤 가능하게 합니다.
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Header (메뉴 버튼)
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
                          builder: (context) => const MyWriteNoteScreen())),
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
                  // ConstrainedBox로 최대 너비 1200px 설정 (디자인 통일)
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      // 수직 패딩과 내부 여백만 유지
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 40.0),
                      child: RefreshIndicator(
                        onRefresh: logic.refreshData,
                        child: _buildContent(context, logic),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 데이터 상태에 따라 Empty State 또는 List State를 반환하는 빌더 함수
  Widget _buildContent(BuildContext context, StudyShareLogic logic) {
    // 1. 로딩 중
    if (logic.isLoadingStatus) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.only(top: 80.0),
        child: CircularProgressIndicator(),
      ));
    }

    // 2. 데이터가 없을 때
    if (logic.notes.isEmpty) {
      return _buildEmptyState(context);
    }

    // 3. 데이터가 있을 때
    return _buildDataList(context, logic.notes);
  }

  // 데이터가 없을 때의 UI (확대된 UI 반영)
  Widget _buildEmptyState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 120, height: 120, // 아이콘 박스 크기 확대
          decoration: const ShapeDecoration(
              color: Color(0x3310595F), shape: OvalBorder()),
          child: Center(
              child: Image.asset('assets/images/my_write_note_green.png',
                  width: 64, height: 58)),
        ),
        const SizedBox(height: 30),
        const Text('내가 작성한 노트',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.w400)), // 36 -> 40
        const SizedBox(height: 15),
        const Text('지금까지 작성한 0개의 노트를 확인해보세요',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Color(0xFFB3B3B3), fontSize: 24)), // 20 -> 24
        const SizedBox(height: 100),
        Image.asset('assets/images/my_write_note_gray.png',
            width: 100, height: 90), // 이미지 크기 확대
        const SizedBox(height: 20),
        const Text('아직 작성한 노트가 없습니다',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Color(0xFFB3B3B3), fontSize: 24)), // 20 -> 24
        const SizedBox(height: 10),
        const Text('첫 번째 노트를 작성해보세요',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Color(0xFFB3B3B3), fontSize: 18)), // 16 -> 18
        const SizedBox(height: 30), // 25 -> 30

        // '새 노트 작성' 버튼 (확대된 UI 반영)
        ElevatedButton.icon(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyWriteNoteScreen())),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0x3310595F),
            foregroundColor: const Color(0xFF10595F),
            elevation: 0,
            minimumSize: const Size(200, 60), // 버튼 크기 확대
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.add, size: 28), // 아이콘 크기 확대
          label: const Text('새 노트 작성',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w400)), // 폰트 크기 확대
        ),
      ],
    );
  }

  // 데이터가 있을 때의 UI (확대된 UI 및 기능 반영)
  Widget _buildDataList(BuildContext context, List<NoteModel> notes) {
    final logic = Provider.of<StudyShareLogic>(context, listen: false);
    final noteCount = notes.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 상단 제목 및 카운트
        Container(
          width: 100,
          height: 100,
          decoration: const ShapeDecoration(
              color: Color(0x3310595F), shape: OvalBorder()),
          child: Center(
              child: Image.asset('assets/images/my_write_note_green.png',
                  width: 55, height: 50)),
        ),
        const SizedBox(height: 30),
        const Text('내가 작성한 노트',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400)),
        const SizedBox(height: 15),
        Text('지금까지 작성한 $noteCount개의 노트를 확인해보세요',
            style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 24)),
        const SizedBox(height: 60), // 50 -> 60

        // 노트 데이터 목록 (카드 반복)
        ...notes.map((note) {
          final subjectName = logic.getSubjectNameById(note.noteSubjectId);
          final displayDate = logic.formatRelativeTime(note.createDate);

          // ✅ [통합] 미리보기 텍스트 생성 (HTML 태그 제거 및 내용 검사 로직 추가)
          String previewText = _stripHtml(note.noteContent);
          if (previewText.isEmpty && note.noteContent.contains('<img')) {
            previewText = "📷 (이미지 파일 포함)";
          } else if (previewText.isEmpty) {
            previewText = "(내용 없음)";
          } else if (previewText.length > 100) {
            previewText = "${previewText.substring(0, 100)}...";
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0), // 30 -> 40
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000), // 700 -> 1000
              child: GestureDetector(
                // 💡 [기능 추가] 상세 화면 이동 및 새로고침
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailScreen(note: note),
                    ),
                  );
                  logic.refreshData();
                },
                child: Container(
                  padding: const EdgeInsets.all(35), // 20 -> 35
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color(0xFFCFCFCF)),
                      borderRadius: BorderRadius.circular(15), // 10 -> 15
                    ),
                    shadows: const [
                      BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 12,
                          offset: Offset(0, 6))
                    ],
                  ),
                  child: NoteCardContent(
                    title: note.title.isNotEmpty ? note.title : "(제목 없음)",
                    subject: subjectName,
                    author: "User ${note.userId}",
                    date: displayDate,
                    preview: previewText, // ✅ 수정된 미리보기 텍스트 사용
                    likes: note.likesCount,
                    comments: note.commentsCount,
                    // 💡 [기능 통합] 카드에 좋아요/북마크 상태 및 콜백 전달
                    isLiked: note.isLiked,
                    isBookmarked: note.isBookmarked,
                    onLikeTap: () => logic.toggleLike(note.id),
                    onBookmarkTap: () => logic.toggleBookmark(note.id),
                    onCommentTap: () {}, // 주석/댓글 기능용 (현재는 빈 콜백)
                  ),
                ),
              ),
            ),
          );
        }).toList(),

        const SizedBox(height: 60),
        // '새 노트 작성' 버튼 (확대된 UI 반영)
        Center(
          child: ElevatedButton.icon(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyWriteNoteScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF4C542),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(220, 65), // 버튼 크기 증가
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add, size: 30),
            label: const Text('새 노트 작성',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}

// =================================================================
// NoteCardContent 클래스 (UI 및 기능 확대 반영)
// =================================================================
// NoteCardContent 클래스는 필드 및 UI는 유지하되,
// preview를 받을 때 HTML 태그 제거 로직을 제거하고 그대로 출력하도록 수정했습니다.
class NoteCardContent extends StatelessWidget {
  final String title;
  final String subject;
  final String author;
  final String date;
  final String preview; // 이미 _stripHtml이 적용된 텍스트
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isBookmarked;
  final VoidCallback onLikeTap;
  final VoidCallback onBookmarkTap;
  final VoidCallback onCommentTap;

  const NoteCardContent({
    super.key,
    required this.title,
    required this.subject,
    required this.author,
    required this.date,
    required this.preview,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.isBookmarked,
    required this.onLikeTap,
    required this.onBookmarkTap,
    required this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 💡 아이콘 크기 확대
            const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.person, size: 48, color: Colors.grey)),
            const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 16),
        // 💡 제목 크기 확대 (26 -> 32)
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6), // 패딩 확대
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border:
                      Border.all(color: Colors.black54, width: 1.2)), // 테두리 확대
              child: Text(subject,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700)), // 18 -> 20
            ),
            const SizedBox(width: 12), // 간격 확대
            Text('$author · $date',
                style: const TextStyle(
                    color: Color(0xFFCFCFCF),
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700)), // 18 -> 20
          ],
        ),
        const SizedBox(height: 20), // 15 -> 20
        // 💡 본문 미리보기 확대 (22 -> 24) 및 줄간격 추가
        // ✅ [수정] 이미 정리된 preview 텍스트를 그대로 출력
        Text(preview,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.5),
            maxLines: 3,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 55), // 47 -> 55
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // 💡 좋아요 토글 버튼
                InkWell(
                  onTap: onLikeTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                            size: 36), // 30 -> 36
                        const SizedBox(width: 8),
                        Text(likes.toString(),
                            style: const TextStyle(
                                color: Color(0xFFCFCFCF),
                                fontSize: 22,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700)), // 18 -> 22
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // 💡 댓글 수 (클릭 가능)
                InkWell(
                  onTap: onCommentTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        const Icon(Icons.comment_outlined,
                            color: Colors.black54, size: 32), // 25 -> 32
                        const SizedBox(width: 8),
                        Text(comments.toString(),
                            style: const TextStyle(
                                color: Color(0xFFCFCFCF),
                                fontSize: 22,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700)), // 18 -> 22
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // 💡 북마크 토글 버튼
            IconButton(
              onPressed: onBookmarkTap,
              icon: Icon(
                  isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_border_outlined,
                  size: 36,
                  color: isBookmarked
                      ? const Color(0xFF10595F)
                      : Colors.black54), // 30 -> 36, 노트 테마색상
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }
}
