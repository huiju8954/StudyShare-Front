// lib/note/screens/note_writing_screen.dart (서버 상태 로직 주석 처리 완료)

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:studyshare/note/services/note_service.dart';
import 'package:studyshare/note/models/note_model.dart'; // ✅ NoteModel 임포트

// [Header 및 화면 이동 임포트] - 사용자님 버전과 친구분 버전을 모두 포함
import 'package:studyshare/main/screens/home_main_screen.dart';
import 'package:studyshare/profile/screens/profile_screen.dart';
import 'package:studyshare/search/screens/search_screen.dart';
import 'package:studyshare/widgets/header.dart';
import 'package:studyshare/community/screens/my_community_screen.dart';
import 'package:studyshare/community/screens/my_write_community_screen.dart';
import 'package:studyshare/Login/LoginScreen.dart'; // ✅ 사용자님의 로그인 화면
import 'package:studyshare/bookmark/screens/my_bookmark_screen.dart';
import 'my_write_note_screen.dart'; // 내 노트 목록 화면

class NoteWritingScreen extends StatefulWidget {
  // ✅ [통합] 수정 기능을 위한 note 필드 추가
  final NoteModel? note;

  const NoteWritingScreen({super.key, this.note});

  @override
  State<NoteWritingScreen> createState() => _NoteWritingScreenState();
}

class _NoteWritingScreenState extends State<NoteWritingScreen> {
  // UI 표시를 위한 과목 데이터
  final Map<String, List<String>> subjectData = {
    '국어': ['국어(공통)', '화법과작문', '독서', '언어와 매체', '문학', '국어(기타)'],
    '수학': ['수학(공통)', '수학 I', '수학 II', '미적분', '확률과 통계', '기하', '경제 수학', '수학(기타)'],
    '영어': ['영어(공통)', '영어독해와 작문', '영어회화', '영어(기타)'],
    '한국사': ['한국사'],
    '사회': ['통합사회', '지리', '역사', '경제', '정치와 법', '윤리', '사회(기타)'],
    '과학': ['통합과학', '물리학', '화학', '생명과학', '지구과학', '과학탐구실험', '과학(기타)'],
  };

  final NoteService _noteService = NoteService();

  // ✅ [통합] 컨트롤러 정의
  final MenuController _menuController = MenuController();
  final HtmlEditorController _htmlController = HtmlEditorController();
  final TextEditingController _titleController = TextEditingController();

  // 서버 상태 관련 상태 변수
  /* // [주석 처리]: 서버 연결 상태 변수
  bool _isServerConnected = false;
  bool _isLoadingStatus = true;
  */

  // 드롭다운 선택 값
  String _selectedSubject = '국어(공통)';

  // ✅ [통합] 메뉴 열림 상태 감지
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    // 서버 상태 확인
    // [주석 처리]: 서버 상태 확인 로직 호출
    // _checkInitialServerStatus();

    // ✅ [통합] 수정 모드 초기화 로직
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      // TODO: noteSubjectId를 과목명으로 변환하는 정확한 로직 필요 (임시로 '국어(공통)' 사용)
      _selectedSubject = '국어(공통)';
      // HTML 에디터 내용 로드
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _htmlController.setText(widget.note!.noteContent);
        }
      });
    } else {
      // 신규 작성 모드 초기화
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _htmlController.setText('');
      });
    }
  }

  // 서버 상태 확인 로직
  /*
  // [주석 처리]: 서버 상태 확인 로직
  void _checkInitialServerStatus() async {
    final isConnected = await _noteService.checkServerStatus();
    if (mounted) {
      setState(() {
        _isServerConnected = isConnected;
        _isLoadingStatus = false;
      });
    }
  }
  */

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  /// 노트 등록/수정 버튼 클릭 시 호출되는 함수입니다.
  void _submitNote() async {
    final title = _titleController.text;
    final bodyHtml = await _htmlController.getText();

    // 1. 유효성 검사
    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('제목을 입력해주세요.')));
      return;
    }

    /*
    // [주석 처리]: 서버 연결 상태 확인 로직
    if (!_isServerConnected) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🔴 서버에 연결되지 않아 등록할 수 없습니다.')),
      );
      return;
    }
    */

    // UI 로직: 로딩 상태 표시
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    bool success;

    // ✅ [통합] 수정 로직
    if (widget.note != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('노트 수정 중...')));
      success = await _noteService.updateNote(
        noteId: widget.note!.id,
        title: title,
        bodyHtml: bodyHtml,
        selectedSubject: _selectedSubject,
        userId: 1, // 임시 userId
      );
    }
    // ✅ [통합] 등록 로직
    else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('노트 등록 중...')));
      success = await _noteService.registerNote(
        title: title,
        bodyHtml: bodyHtml,
        selectedSubject: _selectedSubject,
        userId: 1, // 임시 userId
        id2: 1,
      );
    }

    // 3. UI 로직: 결과에 따른 피드백 제공 및 화면 이동
    if (mounted) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      if (success) {
        String msg = widget.note != null
            ? '✅ 노트가 성공적으로 수정되었습니다.'
            : '✅ 노트가 성공적으로 등록되었습니다.';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));

        if (widget.note != null) {
          // 수정 성공 시 상세 화면을 닫고 목록으로 돌아가도록 true 반환
          Navigator.pop(context, true);
        } else {
          // 등록 성공 시 내 노트 목록 화면으로 이동 (현재 화면 대체)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyWriteNoteScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ 작업에 실패했습니다. 서버/네트워크 오류 확인.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String pageTitle = widget.note != null ? '노트 수정하기' : '노트 글쓰기';
    final String buttonText = widget.note != null ? '수정완료' : '등록하기';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // 1. 헤더 영역
              AppHeader(
                onLogoTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainScreen())),
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
                        builder: (context) => const MyWriteNoteScreen())),
                onLoginTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen())),
                onWriteCommunityTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyWriteCommunityScreen())),
                onBookmarkTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyBookmarkScreen())),
              ),
              // [주석 처리]: 서버 상태 표시 위젯
              // _buildServerStatusWidget(), // 서버 상태 표시 위젯

              Expanded(
                child: SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 30.0), // 패딩 통일
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. 페이지 타이틀
                            Text(pageTitle,
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 15),
                            Container(
                                width: double.infinity,
                                height: 4,
                                color: const Color(0xFFF4C542)), // 노트 테마색

                            // 2. 제목 및 과목 선택 줄
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade300))),
                              child: Row(
                                children: [
                                  const SizedBox(width: 20),
                                  const Text('제목',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 40),

                                  // 제목 입력창
                                  Expanded(
                                    child: TextField(
                                      controller: _titleController,
                                      decoration: InputDecoration(
                                        hintText: '제목을 입력해 주세요',
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),

                                  // 3. 계층형 메뉴 (Nested Menu) - MenuAnchor
                                  MenuAnchor(
                                    controller: _menuController,
                                    alignmentOffset: const Offset(0, 5),
                                    onOpen: () =>
                                        setState(() => _isMenuOpen = true),
                                    onClose: () =>
                                        setState(() => _isMenuOpen = false),
                                    style: MenuStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all(Colors.white),
                                      elevation: WidgetStateProperty.all(4),
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                    ),
                                    builder: (context, controller, child) {
                                      return InkWell(
                                        onTap: () {
                                          if (controller.isOpen) {
                                            controller.close();
                                          } else {
                                            controller.open();
                                          }
                                        },
                                        child: Container(
                                          width: 180,
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  _selectedSubject,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: _selectedSubject ==
                                                            '선택'
                                                        ? Colors.grey.shade500
                                                        : Colors.black87,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const Icon(Icons.arrow_drop_down,
                                                  color: Colors.black54),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    menuChildren:
                                        subjectData.entries.map((entry) {
                                      final String category = entry.key;
                                      final List<String> subjects = entry.value;

                                      return SubmenuButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.resolveWith(
                                                    (states) => states.contains(
                                                            WidgetState.hovered)
                                                        ? Colors.grey.shade100
                                                        : Colors.white)),
                                        menuChildren: subjects.map((subject) {
                                          return MenuItemButton(
                                            onPressed: () {
                                              setState(() {
                                                _selectedSubject = subject;
                                              });
                                              _menuController.close();
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty
                                                        .resolveWith((states) =>
                                                            states.contains(
                                                                    WidgetState
                                                                        .hovered)
                                                                ? Colors.grey
                                                                    .shade100
                                                                : Colors
                                                                    .white)),
                                            child: Container(
                                                width: 150,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: Text(subject,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            _selectedSubject ==
                                                                    subject
                                                                ? FontWeight
                                                                    .bold
                                                                : FontWeight
                                                                    .normal))),
                                          );
                                        }).toList(),
                                        child: Container(
                                            width: 120,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(category,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500))
                                                ])),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // 💡 [핵심 통합] 메뉴가 열리면 공간을 벌려서 에디터를 아래로 밀어버림 (오버랩 방지)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: _isMenuOpen ? 300 : 0,
                            ),

                            // HTML Editor 적용 영역
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: SizedBox(
                                height: 480,
                                child: HtmlEditor(
                                  key: UniqueKey(),
                                  controller: _htmlController,
                                  htmlEditorOptions: const HtmlEditorOptions(
                                    hint: '내용을 입력하세요...',
                                    initialText: '',
                                    autoAdjustHeight: false,
                                  ),
                                  htmlToolbarOptions: const HtmlToolbarOptions(
                                    toolbarPosition:
                                        ToolbarPosition.aboveEditor,
                                    toolbarType: ToolbarType.nativeScrollable,
                                  ),
                                  otherOptions: const OtherOptions(height: 480),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),
                            const Divider(color: Colors.grey, thickness: 0.5),
                            const SizedBox(height: 40),

                            // 작성 팁 섹션
                            _buildTipSection(),

                            const SizedBox(height: 50),

                            // 버튼
                            Center(
                              child: SizedBox(
                                width: 400,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 60,
                                        child: ElevatedButton(
                                          onPressed: _submitNote,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFF4C542),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          child: Text(buttonText,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: SizedBox(
                                        height: 60,
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFAAAAAA),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          child: const Text('취소',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 4. 메뉴 닫기용 투명 배경 (메뉴 열렸을 때만 활성화)
          if (_isMenuOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _menuController.close();
                },
                child: Container(color: Colors.transparent),
              ),
            ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  // 서버 상태를 시각적으로 보여주는 위젯
  /*
  // [주석 처리]: 서버 상태 표시 위젯
  Widget _buildServerStatusWidget() {
    Color color;
    String message;
    IconData icon;

    if (_isLoadingStatus) {
      color = Colors.blueGrey;
      message = '서버 연결 상태 확인 중...';
      icon = Icons.sync;
    } else if (_isServerConnected) {
      color = Colors.green.shade700;
      message = '🟢 서버 연결됨: API 호출 준비 완료 (localhost:8081)';
      icon = Icons.check_circle;
    } else {
      color = Colors.red.shade700;
      message = '🔴 서버 연결 실패: Spring Boot 서버(8081)를 실행하세요.';
      icon = Icons.warning;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      color: color.withOpacity(0.1),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                message,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  */

  Widget _buildTipSection() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('작성 팁',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: const [
                    Icon(Icons.edit_note, size: 22, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('구조화된 작성',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ]),
                  const SizedBox(height: 15),
                  _tipText('제목과 소제목을 활용하세요'),
                  _tipText('번호나 불릿 포인트로 정리하세요'),
                  _tipText('예제와 설명을 분리하세요'),
                ],
              )),
              const SizedBox(width: 40),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: const [
                    Icon(Icons.lightbulb_outline,
                        size: 22, color: Color(0xFFD4AF37)),
                    SizedBox(width: 8),
                    Text('효과적인 학습',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ]),
                  const SizedBox(height: 15),
                  _tipText('핵심 개념을 명확히 하세요'),
                  _tipText('실제 예제를 포함하세요'),
                  _tipText('자신만의 이해 방법을 추가하세요'),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tipText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 15, height: 1.2)),
          const SizedBox(width: 5),
          Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 15, height: 1.2))),
        ],
      ),
    );
  }
}
