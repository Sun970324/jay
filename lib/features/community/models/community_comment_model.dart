class CommunityCommentModel {
  final int id;
  final int postId;
  final String userId;
  final String authorName;
  final String content;
  final DateTime createdAt;

  const CommunityCommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  factory CommunityCommentModel.fromMap(Map<String, dynamic> map) {
    return CommunityCommentModel(
      id: map['id'],
      postId: map['post_id'],
      userId: map['user_id'],
      authorName: (map['profiles'] as Map<String, dynamic>?)?['nickname'] ?? '',
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
