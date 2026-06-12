import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jay/features/community/models/community_comment_model.dart';
import 'package:jay/features/community/models/community_post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommunityRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<CommunityPostModel>> getPosts({
    String sort = 'latest',
    int offset = 0,
    int limit = 10,
    String query = '',
  }) async {
    final column = sort == 'popular' ? 'likes_count' : 'created_at';
    var req = _client.from('community_posts').select('*, profiles(nickname)');
    if (query.isNotEmpty) req = req.ilike('title', '%$query%');
    final response = await req
        .order(column, ascending: false)
        .range(offset, offset + limit - 1);
    final posts = (response as List)
        .map((e) => CommunityPostModel.fromMap(e as Map<String, dynamic>))
        .toList();

    final userId = _client.auth.currentUser?.id;
    if (userId == null || posts.isEmpty) return posts;

    final postIds = posts.map((p) => p.id).toList();
    final liked = await _client
        .from('community_likes')
        .select('post_id')
        .eq('user_id', userId)
        .inFilter('post_id', postIds);
    final likedIds = {for (final r in liked as List) r['post_id'] as int};

    return posts
        .map((p) => likedIds.contains(p.id)
            ? CommunityPostModel(
                id: p.id,
                userId: p.userId,
                authorName: p.authorName,
                title: p.title,
                content: p.content,
                likesCount: p.likesCount,
                commentsCount: p.commentsCount,
                createdAt: p.createdAt,
                isLiked: true,
              )
            : p)
        .toList();
  }

  Future<List<CommunityPostModel>> getMyPosts() async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('community_posts')
        .select('*, profiles(nickname)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (response as List)
        .map((e) => CommunityPostModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CommunityPostModel>> getLikedPosts() async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('community_likes')
        .select('community_posts(*, profiles(nickname))')
        .eq('user_id', userId);
    return (response as List)
        .where((e) => e['community_posts'] != null)
        .map((e) {
          final p = CommunityPostModel.fromMap(
              e['community_posts'] as Map<String, dynamic>);
          return CommunityPostModel(
            id: p.id,
            userId: p.userId,
            authorName: p.authorName,
            title: p.title,
            content: p.content,
            likesCount: p.likesCount,
            commentsCount: p.commentsCount,
            viewCount: p.viewCount,
            createdAt: p.createdAt,
            isLiked: true,
          );
        })
        .toList();
  }

  Future<CommunityPostModel?> getPostById(int id) async {
    final response = await _client
        .from('community_posts')
        .select('*, profiles(nickname)')
        .eq('id', id)
        .maybeSingle();
    if (response == null) return null;
    return CommunityPostModel.fromMap(response);
  }

  Future<void> createPost({
    required String title,
    required String content,
  }) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('community_posts').insert({
      'user_id': userId,
      'title': title,
      'content': content,
    });
  }

  Future<void> updatePost({
    required int id,
    required String title,
    required String content,
  }) async {
    await _client
        .from('community_posts')
        .update({'title': title, 'content': content})
        .eq('id', id);
  }

  Future<void> deletePost(int postId) async {
    await _client.from('community_posts').delete().eq('id', postId);
  }

  Future<bool> isLiked(int postId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client
        .from('community_likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', userId)
        .maybeSingle();
    return response != null;
  }

  Future<void> toggleLike(int postId) async {
    final userId = _client.auth.currentUser!.id;
    final liked = await isLiked(postId);
    if (liked) {
      await _client
          .from('community_likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', userId);
    } else {
      await _client.from('community_likes').insert({
        'post_id': postId,
        'user_id': userId,
      });
    }
  }

  Future<List<CommunityCommentModel>> getComments(int postId) async {
    final response = await _client
        .from('community_comments')
        .select('*, profiles(nickname)')
        .eq('post_id', postId)
        .order('created_at', ascending: true);
    return (response as List)
        .map((e) => CommunityCommentModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createComment({
    required int postId,
    required String content,
  }) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('community_comments').insert({
      'post_id': postId,
      'user_id': userId,
      'content': content,
    });
  }

  Future<void> deleteComment(int commentId) async {
    await _client.from('community_comments').delete().eq('id', commentId);
  }

  Future<List<CommunityCommentModel>> getMyComments() async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('community_comments')
        .select('*, profiles(nickname)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (response as List)
        .map((e) => CommunityCommentModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> incrementViewCount(int id) async {
    await _client.rpc('increment_community_post_view', params: {'p_id': id});
  }

  Future<void> updateComment({required int id, required String content}) async {
    await _client
        .from('community_comments')
        .update({'content': content})
        .eq('id', id);
  }

}

final communityRepo = Provider<CommunityRepository>((ref) => CommunityRepository());
