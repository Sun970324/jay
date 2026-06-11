import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/community/models/community_post_model.dart';
import 'package:jay/features/community/repos/community_repo.dart';

class MyPostsScreen extends ConsumerStatefulWidget {
  static const routeURL = '/my-posts';
  static const routeName = 'myPosts';
  const MyPostsScreen({super.key});

  @override
  ConsumerState<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends ConsumerState<MyPostsScreen> {
  late Future<List<CommunityPostModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = ref.read(communityRepo).getMyPosts();
  }

  void _reload() {
    setState(() {
      _postsFuture = ref.read(communityRepo).getMyPosts();
    });
  }

  Future<void> _delete(int postId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('게시글 삭제'),
        content: const Text('이 게시글을 삭제하시겠어요?'),
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
    await ref.read(communityRepo).deletePost(postId);
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
          '내가 쓴 글',
          style: TextStyle(fontSize: Sizes.size18, fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<List<CommunityPostModel>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
          }
          final posts = snapshot.data ?? [];
          if (posts.isEmpty) {
            return const Center(
              child: Text(
                '아직 작성한 글이 없어요',
                style: TextStyle(fontSize: Sizes.size14, color: Color(0xff9EA7B2)),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(Sizes.size16),
            itemCount: posts.length,
            separatorBuilder: (_, __) => Gaps.v10,
            itemBuilder: (context, i) {
              final post = posts[i];
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
                            post.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Gaps.v6,
                          Text(
                            post.content,
                            style: const TextStyle(
                              fontSize: Sizes.size14,
                              color: Color(0xff747474),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Gaps.v8,
                          Text(
                            _formatDate(post.createdAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xff9EA7B2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await context.push('/community/write', extra: post);
                        _reload();
                      },
                      icon: const Icon(Icons.edit_outlined,
                          size: 20, color: Color(0xff9EA7B2)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _delete(post.id),
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
