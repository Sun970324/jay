import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/legal/views/privacy_policy_screen.dart';
import 'package:jay/features/users/repos/auth_repo.dart';
import 'package:jay/features/users/view_models/auth_view_model.dart';

class ServiceInfoScreen extends ConsumerWidget {
  static const routeURL = '/service-info';
  static const routeName = 'serviceInfo';
  const ServiceInfoScreen({super.key});

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
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

  Widget _item(String label, VoidCallback onTap, {Color? textColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'PretendardMedium',
                  color: textColor ?? const Color(0xff333333),
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
  Widget build(BuildContext context, WidgetRef ref) {
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
          '이용 정보',
          style: TextStyle(
            fontSize: Sizes.size18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Sizes.size14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _item('이용약관', () => context.push(TermsOfServiceScreen.routeURL)),
              const Divider(
                  height: 1,
                  color: Color(0xffECF0F7),
                  indent: 20,
                  endIndent: 20),
              _item('개인정보 처리방침',
                  () => context.push(PrivacyPolicyScreen.routeURL)),
              const Divider(
                  height: 1,
                  color: Color(0xffECF0F7),
                  indent: 20,
                  endIndent: 20),
              _item('로그아웃', () {
                ref.read(authProvider.notifier).signOut().then((_) {
                  if (context.mounted) context.go('/');
                });
              }),
              const Divider(
                  height: 1,
                  color: Color(0xffECF0F7),
                  indent: 20,
                  endIndent: 20),
              _item('회원탈퇴', () => _deleteAccount(context, ref),
                  textColor: const Color(0xff9EA7B2)),
            ],
          ),
        ),
      ),
    );
  }
}
