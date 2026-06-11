import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/community/models/community_comment_model.dart';
import 'package:jay/features/community/models/community_post_model.dart';
import 'package:jay/features/community/repos/community_repo.dart';
import 'package:jay/features/community/view_models/community_view_model.dart';
import 'package:jay/features/users/repos/auth_repo.dart';
import 'package:jay/features/users/views/login_screen.dart';
import 'package:go_router/go_router.dart';

class CommunityDetailScreen extends ConsumerStatefulWidget {
  static const routeName = 'communityDetail';
  final CommunityPostModel post;

  const CommunityDetailScreen({super.key, required this.post});

  @override
  ConsumerState<CommunityDetailScreen> createState() =>
      _CommunityDetailScreenState();
}

class _CommunityDetailScreenState
    extends ConsumerState<CommunityDetailScreen> {
  final _commentCtrl = TextEditingController();
  late bool _isLiked;
  late int _likesCount;
  List<CommunityCommentModel> _comments = [];
  bool _loadingComments = true;
  bool _submittingComment = false;

  @override
  void initState() {
    super.initState();
    _isLiked = false;
    _likesCount = widget.post.likesCount;
    _loadInitialData();
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final repo = ref.read(communityRepo);
    repo.incrementViewCount(widget.post.id);
    final results = await Future.wait([
      repo.isLiked(widget.post.id),
      repo.getComments(widget.post.id),
    ]);
    if (!mounted) return;
    setState(() {
      _isLiked = results[0] as bool;
      _comments = results[1] as List<CommunityCommentModel>;
      _loadingComments = false;
    });
  }

  Future<void> _onLikeTap() async {
    final isLoggedIn = ref.read(authRepo).currentUser != null;
    if (!isLoggedIn) {
      context.push(LoginScreen.routeURL);
      return;
    }
    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });
    await ref.read(communityRepo).toggleLike(widget.post.id);
  }

  Future<void> _loadComments() async {
    final comments =
        await ref.read(communityRepo).getComments(widget.post.id);
    if (!mounted) return;
    setState(() => _comments = comments);
  }

  Future<void> _deleteComment(int commentId) async {
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
            child:
                const Text('삭제', style: TextStyle(color: Color(0xffE53935))),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(communityRepo).deleteComment(commentId);
    _loadComments();
    ref.read(communityProvider.notifier).refresh();
  }

  Future<void> _editComment(CommunityCommentModel comment) async {
    final ctrl = TextEditingController(text: comment.content);
    final saved = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('댓글 수정'),
        content: TextField(
          controller: ctrl,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('저장',
                style: TextStyle(color: Color(0xff1154ED))),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (saved == null || saved.isEmpty) return;
    await ref.read(communityRepo).updateComment(id: comment.id, content: saved);
    _loadComments();
  }

  Future<void> _onCommentSubmit() async {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;

    final isLoggedIn = ref.read(authRepo).currentUser != null;
    if (!isLoggedIn) {
      context.push(LoginScreen.routeURL);
      return;
    }

    setState(() => _submittingComment = true);
    await ref.read(communityRepo).createComment(
          postId: widget.post.id,
          content: text,
        );
    _commentCtrl.clear();
    final comments = await ref.read(communityRepo).getComments(widget.post.id);
    if (!mounted) return;
    setState(() {
      _comments = comments;
      _submittingComment = false;
    });
    ref.read(communityProvider.notifier).refresh();
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Sizes.size16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 게시글 본문
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Sizes.size20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Sizes.size14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.authorName,
                          style: const TextStyle(
                            fontSize: Sizes.size14,
                            color: Color(0xff747474),
                          ),
                        ),
                        Gaps.v10,
                        Text(
                          widget.post.title,
                          style: const TextStyle(
                            fontSize: Sizes.size18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Gaps.v12,
                        Text(
                          widget.post.content,
                          style: const TextStyle(
                            fontSize: Sizes.size14,
                            height: 1.7,
                            color: Color(0xff333333),
                          ),
                        ),
                        Gaps.v20,
                        Row(
                          children: [
                            Text(
                              _formatDate(widget.post.createdAt),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xff9EA7B2),
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.remove_red_eye_outlined,
                                size: 16, color: Color(0xff9EA7B2)),
                            Gaps.h4,
                            Text(
                              '${widget.post.viewCount}',
                              style: const TextStyle(
                                  fontSize: 13, color: Color(0xff9EA7B2)),
                            ),
                            Gaps.h12,
                            GestureDetector(
                              onTap: _onLikeTap,
                              child: Row(
                                children: [
                                  Icon(
                                    _isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 18,
                                    color: _isLiked
                                        ? const Color(0xffE53935)
                                        : const Color(0xff9EA7B2),
                                  ),
                                  Gaps.h4,
                                  Text(
                                    '$_likesCount',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _isLiked
                                          ? const Color(0xffE53935)
                                          : const Color(0xff9EA7B2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Gaps.v12,
                  // 댓글 목록
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Sizes.size20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Sizes.size14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '댓글 ${_comments.length}',
                          style: const TextStyle(
                            fontSize: Sizes.size14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_loadingComments)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: Sizes.size20),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (_comments.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: Sizes.size20),
                            child: Center(
                              child: Text(
                                '첫 번째 댓글을 남겨보세요.',
                                style: TextStyle(
                                  fontSize: Sizes.size14,
                                  color: Color(0xff9EA7B2),
                                ),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _comments.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 24,
                              color: Color(0xffF3F4F8),
                            ),
                            itemBuilder: (context, i) {
                              final c = _comments[i];
                              final myId =
                                  ref.read(authRepo).currentUser?.id;
                              final isMine = c.userId == myId;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        c.authorName,
                                        style: const TextStyle(
                                          fontSize: Sizes.size14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Gaps.h8,
                                      Text(
                                        _formatDate(c.createdAt),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff9EA7B2),
                                        ),
                                      ),
                                      if (isMine) ...[
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () => _editComment(c),
                                          child: const Icon(
                                              Icons.edit_outlined,
                                              size: 16,
                                              color: Color(0xff9EA7B2)),
                                        ),
                                        Gaps.h8,
                                        GestureDetector(
                                          onTap: () => _deleteComment(c.id),
                                          child: const Icon(
                                              Icons.delete_outline,
                                              size: 16,
                                              color: Color(0xff9EA7B2)),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Gaps.v6,
                                  Text(
                                    c.content,
                                    style: const TextStyle(
                                      fontSize: Sizes.size14,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  Gaps.v80,
                ],
              ),
            ),
          ),
          // 댓글 입력창
          Container(
            padding: EdgeInsets.only(
              left: Sizes.size16,
              right: Sizes.size16,
              top: Sizes.size10,
              bottom: MediaQuery.of(context).viewInsets.bottom + Sizes.size16,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xffF0F0F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentCtrl,
                    decoration: const InputDecoration(
                      hintText: '댓글을 입력하세요.',
                      hintStyle: TextStyle(color: Color(0xffDAE1E9)),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Sizes.size12,
                        vertical: Sizes.size10,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffDAE1E9)),
                        borderRadius: BorderRadius.all(Radius.circular(Sizes.size20)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffDAE1E9)),
                        borderRadius: BorderRadius.all(Radius.circular(Sizes.size20)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff1154ED)),
                        borderRadius: BorderRadius.all(Radius.circular(Sizes.size20)),
                      ),
                    ),
                  ),
                ),
                Gaps.h8,
                GestureDetector(
                  onTap: _submittingComment ? null : _onCommentSubmit,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xff1154ED),
                      shape: BoxShape.circle,
                    ),
                    child: _submittingComment
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
