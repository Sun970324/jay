import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/community/models/community_post_model.dart';
import 'package:jay/features/community/repos/community_repo.dart';
import 'package:jay/features/community/widgets/community_post_card.dart';

class MyLikesScreen extends ConsumerStatefulWidget {
  static const routeURL = '/my-likes';
  static const routeName = 'myLikes';
  const MyLikesScreen({super.key});

  @override
  ConsumerState<MyLikesScreen> createState() => _MyLikesScreenState();
}

class _MyLikesScreenState extends ConsumerState<MyLikesScreen> {
  late Future<List<CommunityPostModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = ref.read(communityRepo).getLikedPosts();
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
          '좋아요한 글',
          style: TextStyle(
              fontSize: Sizes.size18, fontWeight: FontWeight.w600),
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
                '좋아요한 게시글이 없어요',
                style: TextStyle(
                    fontSize: Sizes.size14, color: Color(0xff9EA7B2)),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(Sizes.size16),
            itemCount: posts.length,
            separatorBuilder: (_, __) => Gaps.v10,
            itemBuilder: (context, i) {
              final post = posts[i];
              return CommunityPostCard(
                post: post,
                onTap: () =>
                    context.push('/community/${post.id}', extra: post),
              );
            },
          );
        },
      ),
    );
  }
}
