class CommunityPostModel {
  final int id;
  final String userId;
  final String authorName;
  final String title;
  final String content;
  final int likesCount;
  final int commentsCount;
  final int viewCount;
  final DateTime createdAt;
  final bool isLiked;

  const CommunityPostModel({
    required this.id,
    required this.userId,
    required this.authorName,
    required this.title,
    required this.content,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    this.viewCount = 0,
    this.isLiked = false,
  });

  factory CommunityPostModel.fromMap(Map<String, dynamic> map) {
    return CommunityPostModel(
      id: map['id'],
      userId: map['user_id'],
      authorName: (map['profiles'] as Map<String, dynamic>?)?['nickname'] ?? '',
      title: map['title'],
      content: map['content'],
      likesCount: map['likes_count'] ?? 0,
      commentsCount: map['comments_count'] ?? 0,
      viewCount: (map['view_count'] as int?) ?? 0,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
