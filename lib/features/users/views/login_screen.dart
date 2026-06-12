import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/logo.svg', height: 52),
              Gaps.v12,
              const Text(
                '필요한 도움이 닿기를',
                style: TextStyle(
                  fontFamily: 'PretendardMedium',
                  fontSize: Sizes.size18,
                  color: Color(0xff747474),
                ),
              ),
              const SizedBox(height: 120),
              if (isLoading)
                const CircularProgressIndicator()
              else ...[
                _LoginButton(
                  label: 'Kakao 계정으로 계속하기',
                  backgroundColor: const Color(0xFFFEE500),
                  textColor: Colors.black87,
                  icon: SvgPicture.asset('assets/images/kakao_logo.svg',
                      width: 20, height: 20),
                  onTap: () =>
                      ref.read(authProvider.notifier).signInWithKakao(),
                ),
                Gaps.v12,
                _LoginButton(
                  label: 'Google 계정으로 계속하기',
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  icon: SvgPicture.asset('assets/images/google_logo.svg',
                      width: 20, height: 20),
                  onTap: () =>
                      ref.read(authProvider.notifier).signInWithGoogle(),
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
          border: Border.all(color: const Color(0xffE1E1E1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'PretendardMedium',
                color: textColor,
              ),
            ),
            Positioned(
              left: 20,
              child: icon,
            ),
          ],
        ),
      ),
    );
  }
}
