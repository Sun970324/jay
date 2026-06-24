import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/postings/models/posting_model.dart';
import 'package:jay/features/postings/view_models/filter_view_model.dart';
import 'package:jay/features/users/view_models/auth_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  static const routeURL = '/onboarding';
  static const routeName = 'onboarding';
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _nicknameController = TextEditingController();
  final _pageController = PageController();
  List<int> _selectedDiseases = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep2() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finishOnboarding({bool skipped = false}) async {
    setState(() => _isLoading = true);
    try {
      if (!skipped && _selectedDiseases.isNotEmpty) {
        final diseases = _selectedDiseases.map((i) => i.toString()).toList();
        await ref.read(filterProvider.notifier).saveDisease(diseases);
        await ref.read(filterProvider.notifier).savePersonalInfoConsent(true);
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_shown_initial_filter_modal', true);
      await ref
          .read(authProvider.notifier)
          .updateProfile(name: _nicknameController.text.trim());
      if (mounted) context.go('/');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _toggleDisease(int index) {
    setState(() {
      if (index == 0) {
        if (_selectedDiseases.contains(0)) {
          _selectedDiseases.clear();
        } else {
          _selectedDiseases = List.generate(diseaseList.length, (i) => i);
        }
      } else {
        _selectedDiseases.remove(0);
        if (_selectedDiseases.contains(index)) {
          _selectedDiseases.remove(index);
        } else {
          _selectedDiseases.add(index);
        }
      }
    });
  }

  Widget _buildStep1() {
    final canNext =
        _nicknameController.text.trim().isNotEmpty && !_isLoading;
    return Padding(
      padding: const EdgeInsets.all(Sizes.size24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.v24,
          const Text(
            '닉네임을 입력해주세요',
            style: TextStyle(
              fontSize: Sizes.size18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gaps.v16,
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
              onPressed: canNext ? _goToStep2 : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1154ED),
                disabledBackgroundColor: const Color(0xffDAE1E9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.size12),
                ),
              ),
              child: const Text(
                '다음',
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
    );
  }

  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Sizes.size24, Sizes.size24, Sizes.size24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.v24,
          const Text(
            '관심 질병을 알려주세요',
            style: TextStyle(
              fontSize: Sizes.size18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gaps.v4,
          const Text(
            '선택 사항이에요. 나중에 필터에서 변경할 수 있어요.',
            style: TextStyle(fontSize: Sizes.size12, color: Color(0xff9EA7B2)),
          ),
          Gaps.v16,
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: Sizes.size10,
                crossAxisSpacing: Sizes.size10,
                childAspectRatio: 3.5,
              ),
              itemCount: diseaseList.length,
              itemBuilder: (context, i) {
                final selected = _selectedDiseases.contains(i);
                return GestureDetector(
                  onTap: () => _toggleDisease(i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.size8),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xff1154ED)
                          : Colors.white,
                      border: Border.all(
                        color: selected
                            ? const Color(0xff1154ED)
                            : const Color(0xffDAE1E9),
                      ),
                      borderRadius: BorderRadius.circular(Sizes.size8),
                    ),
                    child: Center(
                      child: Text(
                        diseaseList[i],
                        style: TextStyle(
                          fontSize: Sizes.size12,
                          fontWeight: FontWeight.w500,
                          color: selected ? Colors.white : const Color(0xff747474),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Gaps.v16,
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _isLoading ? null : () => _finishOnboarding(skipped: true),
                  child: const Text(
                    '건너뛰기',
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      color: Color(0xff9EA7B2),
                    ),
                  ),
                ),
              ),
              Gaps.h8,
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _finishOnboarding(),
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
              ),
            ],
          ),
          Gaps.v32,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildStep1(),
          _buildStep2(),
        ],
      ),
    );
  }
}
