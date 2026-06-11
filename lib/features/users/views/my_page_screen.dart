import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/users/repos/auth_repo.dart';
import 'package:jay/features/users/view_models/auth_view_model.dart';
import 'package:jay/features/legal/views/privacy_policy_screen.dart';
import 'package:jay/features/users/views/edit_profile_screen.dart';
import 'package:jay/features/users/views/login_screen.dart';

class MyPageScreen extends ConsumerWidget {
  static const routeURL = '/my-page';
  static const routeName = 'myPage';
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).valueOrNull;
    final isLoggedIn = ref.watch(authRepo).currentUser != null;

    return Scaffold(
      backgroundColor: const Color(0xffF3F4F8),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xffF3F4F8),
        title: const Text(
          '마이페이지',
          style: TextStyle(
            fontSize: Sizes.size18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isLoggedIn ? _LoggedInBody(user: user, ref: ref) : const _GuestBody(),
    );
  }
}

class _LoggedInBody extends StatelessWidget {
  final dynamic user;
  final WidgetRef ref;
  const _LoggedInBody({required this.user, required this.ref});

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('회원탈퇴'),
        content: const Text('정말 탈퇴하시겠어요?\n작성한 게시글과 댓글이 모두 삭제됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('탈퇴', style: TextStyle(color: Color(0xffE53935))),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(authRepo).deleteAccount();
    if (context.mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.size16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => context.push(EditProfileScreen.routeURL),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Sizes.size20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Sizes.size14),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xffF3F4F8),
                    child: Icon(Icons.person, size: 28, color: Color(0xff747474)),
                  ),
                  Gaps.h16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.userMetadata?['nickname'] ??
                              '이름 없음',
                          style: const TextStyle(
                            fontSize: Sizes.size16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gaps.v4,
                        Text(
                          user?.email ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xff747474),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      size: 20, color: Color(0xff9EA7B2)),
                ],
              ),
            ),
          ),
          Gaps.v12,
          GestureDetector(
            onTap: () => context.push('/my-posts'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size20, vertical: Sizes.size16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Sizes.size14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.edit_note_outlined,
                      size: 22, color: Color(0xff444444)),
                  Gaps.h12,
                  Expanded(
                    child: Text(
                      '내가 쓴 글 관리',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      size: 20, color: Color(0xff9EA7B2)),
                ],
              ),
            ),
          ),
          Gaps.v12,
          GestureDetector(
            onTap: () => context.push('/my-comments'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size20, vertical: Sizes.size16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Sizes.size14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 22, color: Color(0xff444444)),
                  Gaps.h12,
                  Expanded(
                    child: Text(
                      '내가 쓴 댓글 관리',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      size: 20, color: Color(0xff9EA7B2)),
                ],
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => ref.read(authProvider.notifier).signOut(),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Sizes.size12),
                border: Border.all(color: const Color(0xffE1E1E1)),
              ),
              child: const Center(
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffE53935),
                  ),
                ),
              ),
            ),
          ),
          Gaps.v12,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => context.push(PrivacyPolicyScreen.routeURL),
                child: const Text(
                  '개인정보 처리방침',
                  style: TextStyle(fontSize: 12, color: Color(0xff9EA7B2)),
                ),
              ),
              const Text('  ·  ',
                  style: TextStyle(fontSize: 12, color: Color(0xff9EA7B2))),
              GestureDetector(
                onTap: () => context.push(TermsOfServiceScreen.routeURL),
                child: const Text(
                  '서비스 이용약관',
                  style: TextStyle(fontSize: 12, color: Color(0xff9EA7B2)),
                ),
              ),
            ],
          ),
          Gaps.v12,
          GestureDetector(
            onTap: () => _deleteAccount(context),
            child: const Text(
              '회원탈퇴',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xff9EA7B2),
                decoration: TextDecoration.underline,
                decorationColor: Color(0xff9EA7B2),
              ),
            ),
          ),
          Gaps.v32,
        ],
      ),
    );
  }
}

class _GuestBody extends StatelessWidget {
  const _GuestBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_outline, size: 64, color: Color(0xffDAE1E9)),
          Gaps.v16,
          const Text(
            '로그인이 필요해요',
            style: TextStyle(
              fontSize: Sizes.size18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gaps.v8,
          const Text(
            '로그인하고 맞춤 정보를 받아보세요',
            style: TextStyle(fontSize: Sizes.size14, color: Color(0xff747474)),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () => context.push(LoginScreen.routeURL),
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(Sizes.size12),
              ),
              child: const Center(
                child: Text(
                  '로그인',
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => context.push(PrivacyPolicyScreen.routeURL),
                child: const Text(
                  '개인정보 처리방침',
                  style: TextStyle(fontSize: 12, color: Color(0xff9EA7B2)),
                ),
              ),
              const Text('  ·  ',
                  style: TextStyle(fontSize: 12, color: Color(0xff9EA7B2))),
              GestureDetector(
                onTap: () => context.push(TermsOfServiceScreen.routeURL),
                child: const Text(
                  '서비스 이용약관',
                  style: TextStyle(fontSize: 12, color: Color(0xff9EA7B2)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
