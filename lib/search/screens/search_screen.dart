// lib/search/screens/search_screen.dart (최종 병합 코드 - 최근/인기 검색어 제거)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // [제거]

// 로직 및 모델
import 'package:studyshare/note/services/note_share_logic.dart';
import 'package:studyshare/community/services/community_share_logic.dart';
import 'package:studyshare/note/models/note_model.dart';
import 'package:studyshare/community/models/community_model.dart';
import 'package:studyshare/note/screens/note_detail_screen.dart';
import 'package:studyshare/community/screens/community_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // List<String> _recentSearches = []; // [제거]
  String _currentQuery = '';
  // bool _isSearching = false; // _currentQuery.isEmpty로 대체

  // [제거] 인기 검색어 (정적 데이터)
  /*
  final List<Map<String, String>> _popularSearches = const [
    {'rank': '1', 'term': '공부 잘하는 법'},
    {'rank': '2', 'term': '자격증 시험 일정'},
    {'rank': '3', 'term': '집중력 높이는 방법'},
    {'rank': '4', 'term': '미적분 기본'},
    {'rank': '5', 'term': '글쓰기 팁'},
  ];
  */

  @override
  void initState() {
    super.initState();
    // _loadRecentSearches(); // [제거]
    // 텍스트 필드 변경 감지 리스너 추가
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // [제거] 최근 검색어 불러오기/저장/삭제 관련 모든 메서드
  /*
  Future<void> _loadRecentSearches() async { ... }
  Future<void> _saveRecentSearch(String query) async { ... }
  Future<void> _removeRecentSearch(String query) async { ... }
  Future<void> _clearAllRecentSearches() async { ... }
  */

  // 검색 실행
  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    // _saveRecentSearch(query); // [제거]
    setState(() {
      _currentQuery = query;
      // _isSearching = true; // [제거]
    });
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // Provider 로직 가져오기
    final noteLogic = Provider.of<StudyShareLogic>(context);
    final communityLogic = Provider.of<CommunityShareLogic>(context);

    // 검색 결과 가져오기
    final searchNotes = noteLogic.searchNotes(_currentQuery);
    final searchPosts = communityLogic.searchPosts(_currentQuery);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // 뒤로가기 버튼
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        // 검색 입력 필드
        title: Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            textInputAction: TextInputAction.search,
            onSubmitted: _performSearch,
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: '검색어를 입력하세요',
              hintStyle:
                  const TextStyle(color: Color(0xFFB3B3B3), fontSize: 20),
              border: InputBorder.none,
              prefixIcon:
                  const Icon(Icons.search, color: Color(0xFFB3B3B3), size: 28),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              // X 버튼
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _currentQuery = '';
                          // _isSearching = false; // [제거]
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),
      // 💡 [수정] _currentQuery.isEmpty에 따라 안내 메시지 또는 결과 표시
      body: _currentQuery.isEmpty
          ? _buildSimpleSearchPrompt()
          : _buildSearchResults(searchNotes, searchPosts),
    );
  }

  // 💡 [추가] 초기 검색 화면 대체 위젯
  Widget _buildSimpleSearchPrompt() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Color(0xFFB3B3B3)),
          SizedBox(height: 16),
          Text(
            '검색어를 입력하고 결과를 확인하세요.',
            style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 24),
          ),
        ],
      ),
    );
  }

  // [제거] _buildInitialSearchView
  // [제거] _buildRecentSearches
  // [제거] _buildStaticPopularSearches
  // [제거] _buildRankedSearchTerm

  // 검색 결과 화면 (기존 로직 유지)
  Widget _buildSearchResults(
      List<NoteModel> notes, List<CommunityModel> posts) {
    if (notes.isEmpty && posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 100, color: Color(0xFFB3B3B3)),
            const SizedBox(height: 30),
            Text(
              '"$_currentQuery" 검색 결과가 없습니다',
              style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 24),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (notes.isNotEmpty) ...[
                  const Text('노트 검색 결과',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  ...notes.map((note) => _buildNoteItem(note)),
                  const SizedBox(height: 60),
                ],
                if (posts.isNotEmpty) ...[
                  if (notes.isNotEmpty)
                    const Divider(
                        thickness: 1, height: 60, color: Color(0xFFEEEEEE)),
                  const Text('커뮤니티 검색 결과',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  ...posts.map((post) => _buildCommunityItem(post)),
                  const SizedBox(height: 100),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 노트 아이템 (MyNoteScreen 디자인 적용)
  Widget _buildNoteItem(NoteModel note) {
    final logic = Provider.of<StudyShareLogic>(context, listen: false);
    final subjectName = logic.getSubjectNameById(note.noteSubjectId);
    final displayDate = logic.formatRelativeTime(note.createDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteDetailScreen(note: note)));
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
            child: _buildCardContent(
              title: note.title,
              category: subjectName,
              author: "User ${note.userId}",
              date: displayDate,
              preview: note.noteContent,
              likes: note.likesCount,
              comments: note.commentsCount,
              categoryColor: Colors.black54, // 노트 테마색상
            ),
          ),
        ),
      ),
    );
  }

  // 커뮤니티 아이템 (MyCommunityScreen 디자인 적용)
  Widget _buildCommunityItem(CommunityModel post) {
    final logic = Provider.of<CommunityShareLogic>(context, listen: false);
    final displayDate = logic.formatRelativeTime(post.createDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommunityDetailScreen(post: post)));
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
            child: _buildCardContent(
              title: post.title,
              category: post.category,
              author: "User ${post.userId}",
              date: displayDate,
              preview: post.content,
              likes: post.likesCount,
              comments: post.commentCount,
              categoryColor: const Color(0xFFF4A908), // 커뮤니티 테마색상
            ),
          ),
        ),
      ),
    );
  }

  // 공통 카드 내용 위젯 (디자인 통일)
  Widget _buildCardContent({
    required String title,
    required String category,
    required String author,
    required String date,
    required String preview,
    required int likes,
    required int comments,
    required Color categoryColor,
  }) {
    // HTML 태그 제거 로직
    final cleanedPreview = preview.replaceAll(RegExp(r'<[^>]*>'), '');
    final shortPreview = cleanedPreview.length > 100
        ? "${cleanedPreview.substring(0, 100)}..."
        : cleanedPreview;

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
                fontSize: 32, fontFamily: 'Inter', fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: categoryColor, width: 1.2),
              ),
              child: Text(category,
                  style: const TextStyle(
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
        Text(
          shortPreview,
          style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.5),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 55),
        Row(
          children: [
            const Icon(Icons.favorite_border, color: Colors.grey, size: 36),
            const SizedBox(width: 8),
            Text('$likes',
                style: const TextStyle(
                    color: Color(0xFFCFCFCF),
                    fontSize: 22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700)),
            const SizedBox(width: 20),
            const Icon(Icons.comment_outlined, color: Colors.black54, size: 32),
            const SizedBox(width: 8),
            Text('$comments',
                style: const TextStyle(
                    color: Color(0xFFCFCFCF),
                    fontSize: 22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }
}
