// lib/comment/models/comment_model.dart (최종 병합 코드)

class CommentModel {
  final int id;
  final int userId;
  final String content;
  final String createDate;
  final int? parentCommentId; // 대댓글용

  CommentModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.createDate,
    this.parentCommentId,
  });

  // JSON 데이터를 Dart 객체로 변환하는 안전한 Factory 생성자
  // (두 번째 코드의 안전한 형변환 및 null 체크 로직을 채택)
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      // id, userId: num? 타입으로 안전하게 변환 후, null이면 0으로 기본값 설정
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,

      // content, createDate: String? 타입으로 변환 후, null이면 빈 문자열로 기본값 설정
      content: json['content'] as String? ?? '',

      // 날짜가 null일 경우 대비해 빈 문자열로 처리 (두 번째 코드의 의도 반영)
      createDate: json['createDate'] as String? ?? '',

      // parentCommentId: num? 타입으로 변환 후, null이면 그대로 null 유지
      parentCommentId: (json['parentCommentId'] as num?)?.toInt(),
    );
  }
}
