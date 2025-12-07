class NoteModel {
  final int id;
  final int noteSubjectId;
  final int userId;
  final String title;
  final String noteContent;
  final String noteFileUrl;
  final int likesCount;
  final int commentsCount;
  final int commentsLikesCount;
  final String createDate;
  final int bookmarksCount; 

  // ✅ [필수 통합] 좋아요 및 북마크 상태 필드
  final bool isLiked; 
  final bool isBookmarked; 

  NoteModel({
    required this.id,
    required this.noteSubjectId,
    required this.userId,
    required this.title,
    required this.noteContent,
    required this.noteFileUrl,
    required this.likesCount,
    required this.commentsCount,
    required this.commentsLikesCount,
    required this.createDate,
    required this.bookmarksCount,
    this.isLiked = false, // 기본값 설정
    this.isBookmarked = false, // 기본값 설정
  });

  // ✅ [필수 통합] JSON Map을 Dart 객체로 변환하는 팩토리 생성자
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      // ID
      id: (json['id'] as num?)?.toInt() ?? 0,

      // 과목 ID (다중 필드명 처리)
      noteSubjectId: (json['noteSubjectId'] as num?)?.toInt() ??
          (json['note_subject_id'] as num?)?.toInt() ??
          0,

      // 유저 ID (다중 필드명 처리)
      userId: (json['userId'] as num?)?.toInt() ??
          (json['noteUserId'] as num?)?.toInt() ??
          (json['user_id'] as num?)?.toInt() ??
          0,

      // 제목 (다중 필드명 처리)
      title: json['title'] as String? ??
          json['noteTitle'] as String? ??
          json['note_title'] as String? ??
          '',

      // 내용 (다중 필드명 처리)
      noteContent: json['noteContent'] as String? ??
          json['note_content'] as String? ??
          '',

      // 파일 URL (다중 필드명 처리)
      noteFileUrl: json['noteFileUrl'] as String? ??
          json['note_file_url'] as String? ??
          '',

      // 좋아요 수 (다중 필드명 처리)
      likesCount: (json['likesCount'] as num?)?.toInt() ??
          (json['noteLikesCount'] as num?)?.toInt() ??
          (json['note_likes_count'] as num?)?.toInt() ??
          0,

      // 댓글 수 (다중 필드명 처리)
      commentsCount: (json['commentsCount'] as num?)?.toInt() ??
          (json['noteCommentsCount'] as num?)?.toInt() ??
          (json['note_comments_count'] as num?)?.toInt() ??
          0,

      // 댓글 좋아요 수 (다중 필드명 처리)
      commentsLikesCount: (json['commentsLikesCount'] as num?)?.toInt() ??
          (json['noteCommentsLikesCount'] as num?)?.toInt() ??
          (json['note_comments_likes_count'] as num?)?.toInt() ??
          0,

      // 북마크 수 (다중 필드명 처리)
      bookmarksCount: (json['bookmarksCount'] as num?)?.toInt() ??
          (json['noteBookmarksCount'] as num?)?.toInt() ??
          (json['note_bookmarks_count'] as num?)?.toInt() ??
          0,

      // 날짜 (다중 필드명 처리)
      createDate: json['createDate'] as String? ??
          json['noteCreateDate'] as String? ??
          json['note_create_date'] as String? ??
          '',

      // ✅ [필수 통합] 좋아요/북마크 상태값 (백엔드의 NoteResponseDto에 포함됨)
      isLiked: json['isLiked'] ?? false,
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }

  // ✅ [필수 통합] 상태 관리를 위한 copyWith 메소드 (Provider 로직에서 상태 업데이트에 사용됨)
  NoteModel copyWith({
    int? id,
    int? noteSubjectId,
    int? userId,
    String? title,
    String? noteContent,
    String? noteFileUrl,
    int? likesCount,
    int? commentsCount,
    int? commentsLikesCount,
    String? createDate,
    int? bookmarksCount,
    bool? isLiked,
    bool? isBookmarked,
  }) {
    return NoteModel(
      id: id ?? this.id,
      noteSubjectId: noteSubjectId ?? this.noteSubjectId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      noteContent: noteContent ?? this.noteContent,
      noteFileUrl: noteFileUrl ?? this.noteFileUrl,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      commentsLikesCount: commentsLikesCount ?? this.commentsLikesCount,
      createDate: createDate ?? this.createDate,
      bookmarksCount: bookmarksCount ?? this.bookmarksCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}