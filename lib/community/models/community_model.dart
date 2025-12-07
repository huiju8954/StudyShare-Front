// lib/community/models/community_model.dart (최종 병합 코드)

class CommunityModel {
  final int id;
  final int userId;
  final String title;
  final String category;
  final String content;
  final int likesCount;
  final int commentCount;
  final int commentLikeCount;
  final String createDate;

  // 💡 추가된 필드: 북마크 수, 좋아요 상태, 북마크 상태
  final int bookmarksCount;
  final bool isLiked;
  final bool isBookmarked;

  CommunityModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.content,
    required this.likesCount,
    required this.commentCount,
    required this.commentLikeCount,
    required this.createDate,
    required this.bookmarksCount,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  // JSON 데이터를 Dart 객체로 변환하는 안전한 Factory 생성자
  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      // id가 null이면 0이 되므로, 서버에서 id를 보내는지 확인 필수
      id: (json['id'] as num?)?.toInt() ?? 0,

      userId: (json['userId'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      content: json['content'] as String? ?? '',

      // 서버 DTO의 likesCount와 일치해야 함
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,

      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      commentLikeCount: (json['commentLikeCount'] as num?)?.toInt() ?? 0,

      // 서버 DTO의 bookmarksCount와 일치해야 함
      bookmarksCount: (json['bookmarksCount'] as num?)?.toInt() ?? 0,

      createDate: json['createDate'] as String? ?? '',

      // 서버 DTO의 isLiked와 일치해야 함
      isLiked: json['isLiked'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }
}
