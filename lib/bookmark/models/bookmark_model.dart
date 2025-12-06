// lib/bookmark/models/bookmark_model.dart

class BookmarkModel {
  final int bookmarkId; // 북마크 자체의 ID
  final int postId;     // 북마크된 원본 게시글 ID
  final int userId;     // 작성자 ID (혹은 북마크한 사람)
  final String title;
  final String category;
  final String content;
  final int likesCount;
  final int commentCount;
  final String createDate; // 북마크한 날짜 혹은 원본 글 날짜

  BookmarkModel({
    required this.bookmarkId,
    required this.postId,
    required this.userId,
    required this.title,
    required this.category,
    required this.content,
    required this.likesCount,
    required this.commentCount,
    required this.createDate,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      bookmarkId: (json['id'] as num?)?.toInt() ?? 0,
      postId: (json['postId'] as num?)?.toInt() ?? (json['post_id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? (json['user_id'] as num?)?.toInt() ?? 0,

      // JSON 키값은 백엔드 응답에 따라 유동적으로 처리
      title: json['title'] as String? ?? json['community_title'] as String? ?? '',
      category: json['category'] as String? ?? json['community_category'] as String? ?? '',
      content: json['content'] as String? ?? json['community_content'] as String? ?? '',

      likesCount: (json['likesCount'] as num?)?.toInt() ?? (json['community_likes_count'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? (json['community_comment_count'] as num?)?.toInt() ?? 0,

      createDate: json['createDate'] as String? ?? json['bookmark_date'] as String? ?? '',
    );
  }
}