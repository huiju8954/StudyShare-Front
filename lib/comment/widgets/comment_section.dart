import 'package:flutter/material.dart';
import '../services/comment_service.dart';
import '../models/comment_model.dart';

class CommentSection extends StatefulWidget {
  final int postId; // 글 ID
  final String type; // "note" 또는 "community"

  const CommentSection({
    super.key,
    required this.postId,
    required this.type,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final CommentService _commentService = CommentService();
  final TextEditingController _controller = TextEditingController();
  List<CommentModel> _comments = [];
  bool _isLoading = true;

  // ✅ [통합] 현재 답글을 달고 있는 대상 댓글 ID (없으면 null)
  int? _replyingToId;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  // 댓글 목록 불러오기
  Future<void> _loadComments() async {
    final comments =
        await _commentService.getComments(widget.type, widget.postId);
    if (mounted) {
      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    }
  }

  // 댓글 작성하기
  Future<void> _submitComment() async {
    if (_controller.text.trim().isEmpty) return;

    final success = await _commentService.writeComment(
      content: _controller.text,
      noteId: widget.type == 'note' ? widget.postId : null,
      communityId: widget.type == 'community' ? widget.postId : null,
      // ✅ [통합] 답글이면 부모 ID 전송
      parentCommentId: _replyingToId,
    );

    if (success) {
      _controller.clear(); // 입력창 비우기
      FocusScope.of(context).unfocus(); // 키보드 내리기
      // ✅ [통합] 답글 모드 초기화
      setState(() {
        _replyingToId = null;
      });
      await _loadComments(); // 목록 새로고침
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('댓글 작성에 실패했습니다.')),
      );
    }
  }

  // 💡 댓글 아이템 위젯 (재사용)
  Widget _buildCommentItem(CommentModel comment, {required bool isReply}) {
    return Container(
      width: double.infinity, // 꽉 차게
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        // 대댓글은 배경색 살짝 다르게
        color: isReply ? Colors.grey[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('User ${comment.userId}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(comment.createDate.split('T')[0], // 날짜만 표시 (임시)
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 5),
          Text(comment.content, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 8),

          // ✅ [통합] 답글 달기 버튼 (대댓글에는 답글 버튼 안 보이게 함 - 1depth 제한)
          if (!isReply)
            InkWell(
              onTap: () {
                setState(() {
                  _replyingToId = comment.id; // 답글 대상 설정
                });
              },
              child: const Text("답글 달기",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ [통합] 댓글 정렬 로직: 부모 댓글을 먼저 찾음
    List<CommentModel> rootComments =
        _comments.where((c) => c.parentCommentId == null).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 1, height: 40),

        // 1. 헤더 (댓글 개수)
        Text(
          '댓글 ${_comments.length}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        // 2. 댓글 리스트 (계층적으로 렌더링)
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_comments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text("아직 댓글이 없습니다. 첫 댓글을 남겨보세요!",
                style: TextStyle(color: Colors.grey)),
          )
        else
          // ✅ [통합] 부모 댓글 기준으로 리스트를 빌드
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rootComments.length,
            itemBuilder: (context, index) {
              final root = rootComments[index];
              // 이 부모 댓글에 달린 대댓글 찾기
              final replies =
                  _comments.where((c) => c.parentCommentId == root.id).toList();

              return Column(
                children: [
                  // 1. 부모 댓글 표시
                  _buildCommentItem(root, isReply: false),

                  // 2. 자식 댓글들 표시 (Padding으로 들여쓰기)
                  ...replies.map((reply) => Padding(
                        padding: const EdgeInsets.only(left: 40.0), // 💡 들여쓰기
                        child: _buildCommentItem(reply, isReply: true),
                      )),
                  const SizedBox(height: 15), // 그룹 간 간격
                ],
              );
            },
          ),

        const SizedBox(height: 20),

        // 3. 댓글 입력창

        // ✅ [통합] "답글 작성 중" 배너
        if (_replyingToId != null)
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: Row(
              children: [
                const Icon(Icons.subdirectory_arrow_right, size: 16),
                const SizedBox(width: 8),
                const Text("답글 작성 중...",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => setState(() => _replyingToId = null),
                )
              ],
            ),
          ),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  // 힌트 텍스트 변경
                  hintText:
                      _replyingToId != null ? '답글을 입력하세요...' : '댓글을 입력하세요...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _submitComment,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(15),
                backgroundColor: const Color(0xFFF4A908),
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 30), // 하단 여백
      ],
    );
  }
}
