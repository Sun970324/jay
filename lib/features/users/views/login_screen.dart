import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/users/view_models/auth_view_model.dart';

class LoginScreen extends ConsumerWidget {
  static const routeURL = '/login';
  static const routeName = 'login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authProvider).isLoading;

    ref.listen(authProvider, (_, next) {
      if (next.valueOrNull != null && context.mounted) {
        Navigator.of(context).pop();
      }
      if (next.hasError && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인에 실패했습니다. 다시 시도해 주세요.')),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xffF3F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xffF3F4F8),
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/jay_img.png', width: 72),
              Gaps.v16,
              const Text(
                '제이',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              Gaps.v8,
              const Text(
                '나에게 맞는 의료 복지 혜택을 찾아드려요',
                style: TextStyle(
                  fontSize: Sizes.size14,
                  color: Color(0xff747474),
                ),
              ),
              const SizedBox(height: 56),
              if (isLoading)
                const CircularProgressIndicator()
              else ...[
                _LoginButton(
                  label: 'Google로 계속하기',
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  icon: _GoogleIcon(),
                  onTap: () =>
                      ref.read(authProvider.notifier).signInWithGoogle(),
                ),
                Gaps.v12,
                _LoginButton(
                  label: '카카오로 계속하기',
                  backgroundColor: const Color(0xFFFEE500),
                  textColor: Colors.black87,
                  icon: const Icon(Icons.chat_bubble, size: 20),
                  onTap: () =>
                      ref.read(authProvider.notifier).signInWithKakao(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Widget icon;
  final VoidCallback onTap;

  const _LoginButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Sizes.size12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'G',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xff4285F4),
            ),
          ),
        ],
      ),
    );
  }
}
