import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/users/repos/auth_repo.dart';
import 'package:jay/features/users/view_models/auth_view_model.dart';
import 'package:jay/features/legal/views/privacy_policy_screen.dart';
import 'package:jay/features/users/views/login_screen.dart';
import 'package:jay/features/users/views/service_info_screen.dart';

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
      ),
      body: isLoggedIn ? _LoggedInBody(user: user) : const _GuestBody(),
    );
  }
}

class _LoggedInBody extends StatelessWidget {
  final dynamic user;
  const _LoggedInBody({required this.user});

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xff555555)),
            Gaps.h12,
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'PretendardMedium',
                  color: textColor ?? const Color(0xff3E3E3E),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xff9EA7B2)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user?.userMetadata?['nickname'] ?? '이름 없음',
            style: const TextStyle(
              fontSize: Sizes.size18,
              fontFamily: 'PretendardSemiBold',
              color: Color(0xff1154ED),
            ),
          ),
          Gaps.v4,
          Text(
            user?.email ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'PretendardRegular',
              color: Color(0xff9EA7B2),
            ),
          ),
          Gaps.v24,
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Sizes.size14),
            ),
            child: Column(
              children: [
                _menuItem(
                  context,
                  icon: Icons.edit_note_outlined,
                  label: '내가 쓴 글 관리',
                  onTap: () => context.push('/my-posts'),
                ),
                const Divider(
                    height: 1,
                    color: Color(0xffECF0F7),
                    indent: 20,
                    endIndent: 20),
                _menuItem(
                  context,
                  icon: Icons.chat_bubble_outline,
                  label: '내가 쓴 댓글 관리',
                  onTap: () => context.push('/my-comments'),
                ),
                const Divider(
                    height: 1,
                    color: Color(0xffECF0F7),
                    indent: 20,
                    endIndent: 20),
                _menuItem(
                  context,
                  icon: Icons.favorite_border,
                  label: '좋아요',
                  onTap: () => context.push('/my-likes'),
                ),
              ],
            ),
          ),
          Gaps.v12,
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Sizes.size14),
            ),
            child: _menuItem(
              context,
              icon: Icons.info_outline,
              label: '이용 정보',
              onTap: () => context.push(ServiceInfoScreen.routeURL),
            ),
          ),
          const Spacer(),
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
