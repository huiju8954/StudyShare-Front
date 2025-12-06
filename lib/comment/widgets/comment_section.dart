// lib/comment/widgets/comment_section.dart

import 'package:flutter/material.dart';
import '../services/comment_service.dart';
import '../models/comment_model.dart';

class CommentSection extends StatefulWidget {
  final int postId;        // 글 ID
  final String type;       // "note" 또는 "community"

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

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  // 댓글 목록 불러오기
  Future<void> _loadComments() async {
    final comments = await _commentService.getComments(widget.type, widget.postId);
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
    );

    if (success) {
      _controller.clear(); // 입력창 비우기
      FocusScope.of(context).unfocus(); // 키보드 내리기
      await _loadComments(); // 목록 새로고침
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('댓글 작성에 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

        // 2. 댓글 리스트
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_comments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text("아직 댓글이 없습니다. 첫 댓글을 남겨보세요!",
                style: TextStyle(color: Colors.grey)),
          )
        else
          ListView.separated(
            shrinkWrap: true, // Column 안에서 리스트 쓸 때 필수
            physics: const NeverScrollableScrollPhysics(), // 전체 스크롤 사용
            itemCount: _comments.length,
            separatorBuilder: (c, i) => const SizedBox(height: 15),
            itemBuilder: (context, index) {
              final comment = _comments[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
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
                  ],
                ),
              );
            },
          ),

        const SizedBox(height: 20),

        // 3. 댓글 입력창
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: '댓글을 입력하세요...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                backgroundColor: const Color(0xFFF4A908), // 커뮤니티 색상 (노트면 바꿀 수 있음)
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