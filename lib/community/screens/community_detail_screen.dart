// lib/community/screens/community_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../models/community_model.dart';
// 💡 댓글 위젯 임포트
import 'package:studyshare/comment/widgets/comment_section.dart';

class CommunityDetailScreen extends StatelessWidget {
  final CommunityModel post;

  const CommunityDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("게시글 상세", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 카테고리 태그
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFF4A908)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                post.category,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),

            // 2. 제목
            Text(
              post.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 3. 작성자 및 날짜
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text("User ${post.userId}", style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 15),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text(post.createDate, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const Divider(height: 30, thickness: 1),

            // 4. 본문 내용 (HTML 뷰어)
            HtmlWidget(
              post.content,
              textStyle: const TextStyle(fontSize: 16, height: 1.5),
              customStylesBuilder: (element) {
                if (element.localName == 'img') {
                  return {'max-width': '100%', 'height': 'auto'};
                }
                return null;
              },
            ),

            const SizedBox(height: 50),

            // 5. 💡 [추가] 댓글 영역
            CommentSection(
              postId: post.id,
              type: 'community', // 백엔드 API 구분용 (community)
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}