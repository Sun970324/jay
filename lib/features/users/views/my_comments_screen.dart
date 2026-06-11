import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/community/models/community_comment_model.dart';
import 'package:jay/features/community/repos/community_repo.dart';

class MyCommentsScreen extends ConsumerStatefulWidget {
  static const routeURL = '/my-comments';
  static const routeName = 'myComments';
  const MyCommentsScreen({super.key});

  @override
  ConsumerState<MyCommentsScreen> createState() => _MyCommentsScreenState();
}

class _MyCommentsScreenState extends ConsumerState<MyCommentsScreen> {
  late Future<List<CommunityCommentModel>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = ref.read(communityRepo).getMyComments();
  }

  void _reload() {
    setState(() {
      _commentsFuture = ref.read(communityRepo).getMyComments();
    });
  }

  Future<void> _delete(int commentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('댓글 삭제'),
        content: const Text('이 댓글을 삭제하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('삭제', style: TextStyle(color: Color(0xffE53935))),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(communityRepo).deleteComment(commentId);
    _reload();
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}년 ${dt.month.toString().padLeft(2, '0')}월 ${dt.day.toString().padLeft(2, '0')}일';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F8),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xffF3F4F8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '내가 쓴 댓글',
          style: TextStyle(fontSize: Sizes.size18, fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<List<CommunityCommentModel>>(
        future: _commentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
          }
          final comments = snapshot.data ?? [];
          if (comments.isEmpty) {
            return const Center(
              child: Text(
                '아직 작성한 댓글이 없어요',
                style: TextStyle(fontSize: Sizes.size14, color: Color(0xff9EA7B2)),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(Sizes.size16),
            itemCount: comments.length,
            separatorBuilder: (_, __) => Gaps.v10,
            itemBuilder: (context, i) {
              final comment = comments[i];
              return Container(
                padding: const EdgeInsets.all(Sizes.size16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Sizes.size14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.content,
                            style: const TextStyle(fontSize: Sizes.size14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Gaps.v8,
                          Text(
                            _formatDate(comment.createdAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xff9EA7B2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _delete(comment.id),
                      icon: const Icon(Icons.delete_outline,
                          size: 20, color: Color(0xff9EA7B2)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
