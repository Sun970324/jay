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

  static const _borderSide = BorderSide(color: Color(0xffE1E4EA));
  static const _focusedBorderSide = BorderSide(color: Color(0xff1154ED));
  static final _borderRadius = BorderRadius.circular(12);

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xffBEC5CC),
        fontFamily: 'PretendardRegular',
        fontSize: 14,
      ),
      counterText: '',
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
          borderRadius: _borderRadius, borderSide: _borderSide),
      enabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius, borderSide: _borderSide),
      focusedBorder: OutlineInputBorder(
          borderRadius: _borderRadius, borderSide: _focusedBorderSide),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          _isEditMode ? '글 수정' : '글쓰기',
          style: const TextStyle(
            fontSize: Sizes.size18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, size: 24),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: GestureDetector(
            onTap: _isSubmitting ? null : _onSubmit,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xff1154ED),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        _isEditMode ? '수정하기' : '등록하기',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'PretendardSemiBold',
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '제목',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'PretendardSemiBold',
                color: Color(0xff333333),
              ),
            ),
            Gaps.v8,
            TextField(
              controller: _titleCtrl,
              maxLength: 100,
              style:
                  const TextStyle(fontSize: 14, fontFamily: 'PretendardMedium'),
              decoration: _inputDecoration('최대 100자까지 입력 가능'),
            ),
            Gaps.v20,
            const Text(
              '내용',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'PretendardSemiBold',
                color: Color(0xff333333),
              ),
            ),
            Gaps.v8,
            TextField(
              controller: _contentCtrl,
              maxLength: 2000,
              minLines: 8,
              maxLines: null,
              style: const TextStyle(
                  fontSize: 14, fontFamily: 'PretendardMedium', height: 1.6),
              decoration: _inputDecoration('최대 2000자까지 입력 가능'),
            ),
          ],
        ),
      ),
    );
  }
}
