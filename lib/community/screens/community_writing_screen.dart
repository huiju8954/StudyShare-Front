// lib/community/screens/community_writing_screen.dart (최종 병합 코드)

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:studyshare/community/services/community_service.dart';
import 'package:provider/provider.dart';
import 'package:studyshare/profile/services/profile_logic.dart';
import 'package:studyshare/community/services/community_share_logic.dart';

// [File 2에서 추가] 작성 완료 후 이동할 목록 화면 import
import 'package:studyshare/community/screens/my_write_community_screen.dart';

class CommunityWritingScreen extends StatefulWidget {
  const CommunityWritingScreen({super.key});

  @override
  State<CommunityWritingScreen> createState() => _CommunityWritingScreenState();
}

class _CommunityWritingScreenState extends State<CommunityWritingScreen> {
  final CommunityService _communityService = CommunityService();

// --- 상태 변수 ---
  bool _isServerConnected = false;
  bool _isLoadingStatus = true;

  final HtmlEditorController _htmlController = HtmlEditorController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkInitialServerStatus();
  }

// 서버 상태 확인 로직
  void _checkInitialServerStatus() async {
    final isConnected = await _communityService.checkServerStatus();
    if (mounted) {
      setState(() {
        _isServerConnected = isConnected;
        _isLoadingStatus = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  /// 게시글 등록 버튼 클릭 시 호출되는 함수입니다. (Provider 로직 + 로그인 체크 통합)
  void _submitPost() async {
    final title = _titleController.text;
    final content = await _htmlController.getText();

// 1. Provider에서 사용자 ID와 로직 가져오기
    final profileLogic = Provider.of<ProfileLogic>(context, listen: false);
    final communityLogic =
        Provider.of<CommunityShareLogic>(context, listen: false);
    final int? userId = profileLogic.currentUserId; // 현재 로그인된 사용자 ID

// UI 유효성 검사
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 내용을 모두 입력해주세요.')),
      );
      return;
    }

// ⭐️ [File 1 핵심 기능] 로그인 상태 확인
    if (userId == null || userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🔒 게시글 등록: 로그인 후 이용해주세요.')),
      );
      return;
    }

// 서버 연결 상태 확인
    if (!_isServerConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🔴 서버에 연결되지 않아 등록할 수 없습니다.')),
      );
      return;
    }

// UI 로직: 로딩 상태 표시
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('게시글 등록 중...')),
    );

// 2. 비즈니스 로직 위임 (Logic Provider 호출)
    final success = await communityLogic.registerNewPost(
      title: title,
      content: content,
      category: '자유', // 단일 카테고리 '자유'로 고정
      userId: userId, // 로그인된 사용자 ID 전달
    );

// 3. UI 로직: 결과에 따른 피드백 제공
    if (mounted) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ 게시글이 성공적으로 등록되었습니다.')),
        );
        // 💡 [File 2 핵심 기능] 작성 완료 후 목록 화면으로 이동 (pushReplacement)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MyWriteCommunityScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ 게시글 등록에 실패했습니다. 서버/네트워크 오류 확인.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('자유 게시글 작성', // 타이틀 수정
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black), // 뒤로가기 아이콘 색상 보장
        actions: [
          TextButton(
            onPressed: _submitPost,
            child: const Text('등록하기',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        children: [
          // 서버 상태 표시 위젯 (주석 처리된 채로 유지)
          // _buildServerStatusWidget(),
          Expanded(
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 30.0), // File 1의 여유로운 패딩 사용
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. 상단 타이틀
                        const Text('자유 게시판 글쓰기',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 15),
                        Container(
                            width: double.infinity,
                            height: 4,
                            color: const Color(0xFFF4A908)),

                        // 2. 제목 입력 줄 (File 1의 Row/Text/TextField 구조 사용)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade300))),
                          child: Row(
                            children: [
                              const SizedBox(width: 20),
                              const Text('제목',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 40),
                              Expanded(
                                child: TextField(
                                  controller: _titleController,
                                  decoration: InputDecoration(
                                    hintText: '제목을 입력해 주세요 (자유 게시판)',
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade400),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // HTML Editor 적용 영역 (File 1의 크기 480 사용)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: SizedBox(
                            height: 480, // 480으로 통일
                            child: HtmlEditor(
                              key: UniqueKey(),
                              controller: _htmlController,
                              htmlEditorOptions: const HtmlEditorOptions(
                                hint: '내용을 입력하세요...',
                                initialText: '',
                                autoAdjustHeight: false,
                              ),
                              htmlToolbarOptions: const HtmlToolbarOptions(
                                toolbarPosition: ToolbarPosition.aboveEditor,
                                toolbarType: ToolbarType.nativeScrollable,
                              ),
                              otherOptions: const OtherOptions(
                                height: 480,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
                        const Divider(color: Colors.grey, thickness: 0.5),
                        const SizedBox(height: 40),

                        // 작성 팁 섹션 (File 1의 상세 위젯 사용)
                        _buildTipSection(),

                        const SizedBox(height: 50),

                        // 등록/취소 버튼 (File 1의 너비와 스타일 사용)
                        Center(
                          child: SizedBox(
                            width: 400,
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60,
                                    child: ElevatedButton(
                                      onPressed: _submitPost,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFF4A908),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                      ),
                                      child: const Text('등록하기',
                                          style: TextStyle(
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
                                      onPressed: () => Navigator.pop(context),
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
          )
        ],
      ),
    );
  }

// Helper Widget for Tip Section (File 1)
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
                  _tipTextRow(Icons.edit_note, '구조화된 작성'),
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
                  _tipTextRow(Icons.lightbulb_outline, '효과적인 학습',
                      color: const Color(0xFFD4AF37)),
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

// Helper Widget for Tip Text Row (File 1)
  Widget _tipTextRow(IconData icon, String text, {Color color = Colors.grey}) {
    return Row(children: [
      Icon(icon, size: 22, color: color),
      const SizedBox(width: 8),
      Text(text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    ]);
  }

// Helper Widget for Tip Text (File 1)
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

// 서버 상태를 시각적으로 보여주는 위젯 (File 1)
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
}
