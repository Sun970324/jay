import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/community/models/community_post_model.dart';
import 'package:jay/features/community/repos/community_repo.dart';
import 'package:jay/features/community/view_models/community_view_model.dart';

class CommunityWriteScreen extends ConsumerStatefulWidget {
  static const routeURL = '/community/write';
  static const routeName = 'communityWrite';

  final CommunityPostModel? post;
  const CommunityWriteScreen({super.key, this.post});

  @override
  ConsumerState<CommunityWriteScreen> createState() =>
      _CommunityWriteScreenState();
}

class _CommunityWriteScreenState extends ConsumerState<CommunityWriteScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  bool _isSubmitting = false;

  bool get _isEditMode => widget.post != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _titleCtrl.text = widget.post!.title;
      _contentCtrl.text = widget.post!.content;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_titleCtrl.text.trim().isEmpty || _contentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 내용을 모두 입력해주세요.')),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      if (_isEditMode) {
        await ref.read(communityRepo).updatePost(
              id: widget.post!.id,
              title: _titleCtrl.text.trim(),
              content: _contentCtrl.text.trim(),
            );
      } else {
        await ref.read(communityRepo).createPost(
              title: _titleCtrl.text.trim(),
              content: _contentCtrl.text.trim(),
            );
      }
      await ref.read(communityProvider.notifier).refresh();
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F8),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xffF3F4F8),
        title: Text(
          _isEditMode ? '글 수정' : '글쓰기',
          style: const TextStyle(
            fontSize: Sizes.size18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Sizes.size16),
            child: TextButton(
              onPressed: _isSubmitting ? null : _onSubmit,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _isEditMode ? '수정' : '등록',
                      style: const TextStyle(
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1154ED),
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.size16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Sizes.size14),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _titleCtrl,
                    style: const TextStyle(
                      fontSize: Sizes.size16,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      hintText: '제목',
                      hintStyle: TextStyle(
                        color: Color(0xffDAE1E9),
                        fontWeight: FontWeight.w600,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Sizes.size16,
                        vertical: Sizes.size14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xffF3F4F8)),
                  TextField(
                    controller: _contentCtrl,
                    minLines: 10,
                    maxLines: null,
                    style: const TextStyle(fontSize: Sizes.size14, height: 1.6),
                    decoration: const InputDecoration(
                      hintText: '내용을 입력해주세요.',
                      hintStyle: TextStyle(color: Color(0xffDAE1E9)),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Sizes.size16,
                        vertical: Sizes.size14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.v16,
          ],
        ),
      ),
    );
  }
}
