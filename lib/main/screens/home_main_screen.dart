// lib/main/screens/home_main_screen.dart (최종 병합 코드 - 오류 해결 완료)

import 'package:flutter/material.dart';

// [Import 통일 및 오류 수정]
import 'package:studyshare/community/screens/my_community_screen.dart';
import 'package:studyshare/Login/LoginScreen.dart';
// MyBookmarkScreen 충돌 방지 위해 hide 적용
import 'package:studyshare/profile/screens/profile_screen.dart'
    hide MyBookmarkScreen;
import 'package:studyshare/search/screens/search_screen.dart'
    hide MyBookmarkScreen;
import 'package:studyshare/widgets/header.dart';
import 'package:studyshare/note/screens/my_note_screen.dart';

// 💡 데이터 연동 및 기타 화면 import
import 'package:studyshare/bookmark/screens/my_bookmark_screen.dart';
import 'package:studyshare/community/screens/my_write_community_screen.dart';
import 'package:studyshare/note/screens/my_write_note_screen.dart';
import 'package:studyshare/note/services/note_service.dart';
import 'package:studyshare/note/models/note_model.dart';
import 'package:studyshare/note/screens/note_detail_screen.dart';

// -------------------------------------------------------------
// Entry Point (main.dart가 분리되어 있을 경우 이 부분은 삭제 필요)
// -------------------------------------------------------------
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
// -------------------------------------------------------------

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // 👈 [오류 해결] createSate() 괄호 안에 불필요한 인수가 없는지 확인
  State<MainScreen> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  final NoteService _noteService = NoteService();
  late Future<List<NoteModel>> _notesFuture;

  @override
  void initState() {
    super.initState();
    // 화면 시작 시 DB에서 모든 노트 가져오기 (userId=1 임시)
    _notesFuture = _noteService.fetchAllNotes();
  }

  // 과목 이름 변환
  String _getSubjectName(int id) {
    const subjects = {
      1: '국어(공통)',
      2: '화법과작문',
      3: '독서',
      4: '언어와 매체',
      5: '문학',
      7: '수학(공통)',
      8: '수학 I',
      9: '수학 II',
      10: '미적분',
      11: '확률과 통계',
      15: '영어(공통)',
      19: '한국사',
      27: '통합과학',
      20: '통합사회'
    };
    return subjects[id] ?? '기타';
  }

  // HTML 태그 제거 (미리보기용)
  String _stripHtml(String htmlString) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').replaceAll('&nbsp;', ' ').trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. 헤더
            AppHeader(
              onLogoTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainScreen())),
              onSearchTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen())),
              onProfileTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen())),
              onWriteNoteTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyNoteScreen())),
              onLoginTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen())),
              onWriteCommunityTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyCommunityScreen())),
              onBookmarkTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyBookmarkScreen())),
            ),

            // 2. 메인 이미지 (Hero)
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset(
                  'assets/images/StudyShare_Image1.png',
                  width: 1440,
                  height: 520,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xFFE4E4E4),
                          child: Icon(Icons.chevron_left,
                              color: Colors.black, size: 40)),
                      SizedBox(width: 15),
                      CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child:
                              Icon(Icons.pause, color: Colors.black, size: 35)),
                      SizedBox(width: 15),
                      CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xFFE4E4E4),
                          child: Icon(Icons.chevron_right,
                              color: Colors.black, size: 40)),
                    ],
                  ),
                ),
              ],
            ),

            // 3. 실시간 노트 & 메인 버튼들
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    const Text('실시간 노트를 확인해 보세요',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 30),

                    // 💡 [실시간 노트] DB 데이터 연동
                    FutureBuilder<List<NoteModel>>(
                      future: _notesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text("등록된 노트가 없습니다.");
                        }

                        // 최신순 정렬 -> 상위 3개
                        final notes = snapshot.data!;
                        notes.sort(
                            (a, b) => b.createDate.compareTo(a.createDate));
                        final recentNotes = notes.take(3).toList();

                        return Column(
                          children: recentNotes.map((note) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // 상세 화면 이동
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NoteDetailScreen(note: note)));
                                  },
                                  child: _buildNoteCard(
                                    title: note.title.isNotEmpty
                                        ? note.title
                                        : "(제목 없음)",
                                    subject:
                                        _getSubjectName(note.noteSubjectId),
                                    author: "User ${note.userId}",
                                    date: note.createDate.split(' ')[0],
                                    preview: _stripHtml(note.noteContent),
                                    likes: note.likesCount,
                                    comments: note.commentsCount,
                                  ),
                                ),
                                const SizedBox(height: 30),
                              ],
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 100),
                    const Center(
                        child: Text('내 공부 내용을 작성하고 공유해 보세요',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 36,
                                fontWeight: FontWeight.w700))),
                    const SizedBox(height: 80),
                    // CTA 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCtaItem(
                            'assets/images/mainpage_write.png',
                            '나만의 공부 노트를\n작성하세요',
                            '작성하기',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MyWriteNoteScreen()))),
                        _buildCtaItem(
                            'assets/images/mainpage_share.png',
                            '공부한 내용을 커뮤니티에\n공유 해보아요',
                            '공유하기',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MyWriteCommunityScreen()))),
                        _buildCtaItem(
                            'assets/images/mainpage_look.png',
                            '자유롭게 이야기하고\n질문해 보세요',
                            '둘러보기',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MyCommunityScreen()))),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // 4. 추천 학습 자료 (좋아요 순 1~5위)
            Container(
              color: const Color(0xFF9780A9),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        '다른 사용자들이 추천하는\n학습 자료를 확인하세요!',
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      flex: 3,
                      child: FutureBuilder<List<NoteModel>>(
                        future: _notesFuture,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text("데이터 없음",
                                    style: TextStyle(color: Colors.white)));
                          }

                          // 💡 [핵심] 좋아요(likesCount) 많은 순서로 정렬
                          final notes = List<NoteModel>.from(snapshot.data!);
                          notes.sort(
                              (a, b) => b.likesCount.compareTo(a.likesCount));
                          final topNotes = notes.take(5).toList(); // 상위 5개

                          return Column(
                            children: [
                              // 1, 2, 3위 (Row 1)
                              Row(
                                children: [
                                  if (topNotes.isNotEmpty)
                                    _buildRecommendationCard(topNotes[0], 1),
                                  const SizedBox(width: 20),
                                  if (topNotes.length > 1)
                                    _buildRecommendationCard(topNotes[1], 2)
                                  else
                                    const Expanded(child: SizedBox()),
                                  const SizedBox(width: 20),
                                  if (topNotes.length > 2)
                                    _buildRecommendationCard(topNotes[2], 3)
                                  else
                                    const Expanded(child: SizedBox()),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // 4, 5위 (Row 2)
                              Row(
                                children: [
                                  if (topNotes.length > 3)
                                    _buildRecommendationCard(topNotes[3], 4)
                                  else
                                    const Expanded(child: SizedBox()),
                                  const SizedBox(width: 20),
                                  if (topNotes.length > 4)
                                    _buildRecommendationCard(topNotes[4], 5)
                                  else
                                    const Expanded(child: SizedBox()),
                                  const Expanded(child: SizedBox()),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  // NoteCard를 Container로 감싸고 그림자/경계를 추가하는 부분
  Widget _buildNoteCard({
    required String title,
    required String subject,
    required String author,
    required String date,
    required String preview,
    required int likes,
    required int comments,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFCFCFCF)),
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
              color: Color(0x19000000), blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: NoteCardContent(
        title: title,
        subject: subject,
        author: author,
        date: date,
        preview: preview,
        likes: likes,
        comments: comments,
      ),
    );
  }

  // CTA 버튼 위젯
  Widget _buildCtaItem(String imagePath, String text, String buttonText,
      VoidCallback onPressed) {
    return Expanded(
      child: Column(
        children: [
          Image.asset(imagePath, width: 180, height: 200),
          const SizedBox(height: 30),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: onPressed, // 콜백 사용
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFCB30),
              minimumSize: const Size(200, 60),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            child: Text(buttonText,
                style: const TextStyle(color: Colors.white, fontSize: 26)),
          ),
        ],
      ),
    );
  }

  // 추천 카드 생성 (DB 데이터 사용)
  Widget _buildRecommendationCard(NoteModel note, int rank) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailScreen(note: note),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 320,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$rank',
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 32,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Text(
                note.title.isNotEmpty ? note.title : "(제목 없음)",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Chip(
                  label: Text(_getSubjectName(note.noteSubjectId)),
                  backgroundColor: const Color(0xFFEFEFEF)),
              const Spacer(),
              Text(
                _stripHtml(note.noteContent), // 미리보기
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  Text('${note.likesCount}',
                      style: const TextStyle(color: Colors.grey)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// NoteCardContent 클래스 (위젯 내용)
// -------------------------------------------------------------
class NoteCardContent extends StatelessWidget {
  final String title;
  final String subject;
  final String author;
  final String date;
  final String preview;
  final int likes;
  final int comments;

  const NoteCardContent({
    super.key,
    required this.title,
    required this.subject,
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
              radius: 18,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.person, size: 40, color: Colors.grey),
            ),
            SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black54, width: 1.0),
              ),
              child: Text(subject,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 8),
            Text(
              '$author · $date',
              style: const TextStyle(
                  color: Color(0xFFCFCFCF),
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          preview,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 47),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red, size: 30),
                const SizedBox(width: 5),
                Text(likes.toString(),
                    style: const TextStyle(
                        color: Color(0xFFCFCFCF),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700)),
                const SizedBox(width: 15),
                const Icon(Icons.comment_outlined,
                    color: Colors.black54, size: 25),
                const SizedBox(width: 5),
                Text(comments.toString(),
                    style: const TextStyle(
                        color: Color(0xFFCFCFCF),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700)),
              ],
            ),
            const Icon(Icons.bookmark_border_outlined,
                size: 30, color: Colors.black54),
          ],
        ),
      ],
    );
  }
}
