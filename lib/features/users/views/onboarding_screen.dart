import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/users/view_models/auth_view_model.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  static const routeURL = '/onboarding';
  static const routeName = 'onboarding';
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _nicknameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).updateProfile(name: nickname);
      if (mounted) context.go('/');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _nicknameController.text.trim().isNotEmpty && !_isLoading;

    return Scaffold(
      backgroundColor: const Color(0xffF3F4F8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xffF3F4F8),
        title: const Text(
          '프로필 설정',
          style: TextStyle(
            fontSize: Sizes.size18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.size24),
        child: Column(
          children: [
            Gaps.v24,
            TextField(
              controller: _nicknameController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: '닉네임 (필수)',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: canSubmit ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1154ED),
                  disabledBackgroundColor: const Color(0xffDAE1E9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.size12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        '시작하기',
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            Gaps.v32,
          ],
        ),
      ),
    );
  }
}
