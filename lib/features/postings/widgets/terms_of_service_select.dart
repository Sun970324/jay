import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/postings/view_models/filter_view_model.dart';

class TermsOfServiceSelect extends ConsumerStatefulWidget {
  const TermsOfServiceSelect({super.key});

  @override
  ConsumerState<TermsOfServiceSelect> createState() =>
      _TermsOfServiceSelectState();
}

class _TermsOfServiceSelectState extends ConsumerState<TermsOfServiceSelect> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    // 저장된 동의 여부를 불러와 초기 상태를 설정
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(filterProvider.notifier).loadSavedPersonalInfoConsent();
      if (!mounted) return;
      final consent = ref.read(filterProvider).isPersonalInfoConsent;
      setState(() {
        _isSelected = consent;
      });
    });
  }

  void _selectBtn() async {
    if (_isSelected) {
      setState(() {
        _isSelected = false;
      });
      await ref.read(filterProvider.notifier).savePersonalInfoConsent(false);
    } else {
      _showModal(context);
      setState(() {
        _isSelected = true;
      });
      await ref.read(filterProvider.notifier).savePersonalInfoConsent(true);
    }
  }

  void _showModal(BuildContext context) async {
    final screenSize = MediaQuery.of(context).size;

    void onClosePressed() async {
      Navigator.of(context).pop();
    }

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            width: screenSize.width * 0.9,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size32,
              vertical: Sizes.size20,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '개인정보 및 민감정보 처리 방침',
                      style: TextStyle(
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: onClosePressed,
                      icon: SvgPicture.asset('assets/images/cancle_icon.svg'),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                Gaps.v24,
                const Text(
                  '제이는 맞춤형 의료지원 정책 추천 서비스 제공 및 개선을 위하여 다음과 같은 정보를 수집·이용합니다.',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                Gaps.v24,
                const Text(
                  '개인정보 수집 및 이용 동의',
                  style: TextStyle(
                    fontSize: Sizes.size12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gaps.v4,
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    '· 수집항목: 생년월일(또는 나이), 거주지(시·도), 소득구간',
                    style: TextStyle(
                      fontSize: Sizes.size12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Gaps.v4,
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    '· 이용목적:',
                    style: TextStyle(
                      fontSize: Sizes.size12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Gaps.v4,
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    '① 이용자에게 적합한 의료지원 정책 추천 결과 제공',
                    style: TextStyle(
                      fontSize: Sizes.size12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Gaps.v4,
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    '② 서비스 품질 개선',
                    style: TextStyle(
                      fontSize: Sizes.size12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Gaps.v4,
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    '· 보유기간: 수집일로부터 3개월 보관 후 파기',
                    style: TextStyle(
                      fontSize: Sizes.size12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Gaps.v24,
                const Text(
                  '민감정보 처리 동의',
                  style: TextStyle(
                    fontSize: Sizes.size12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gaps.v4,
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    '· 처리항목: 이용자가 입력한 질병정보',
                    style: TextStyle(
                      fontSize: Sizes.size12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Gaps.v4,
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    '· 처리목적: 의료지원 정책 추천 및 서비스 개선',
                    style: TextStyle(
                      fontSize: Sizes.size12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Gaps.v4,
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    '· 보유기간: 수집일로부터 3개월 보관 후 파기',
                    style: TextStyle(
                      fontSize: Sizes.size12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Gaps.v24,
                const Text(
                  '※ 3개월 경과 후에는 개인을 식별할 수 없도록 처리한 정보에 한하여 통계 분석 목적으로 최대 3년간 보관됩니다.',
                  style: TextStyle(
                    fontSize: Sizes.size12,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                Gaps.v4,
                const Text(
                  '※ 귀하는 동의를 거부할 권리가 있으며, 동의하지 않을 경우 맞춤형 기능 사용에 제한이 있을 수 있습니다.',
                  style: TextStyle(
                    fontSize: Sizes.size12,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                Gaps.v16,
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectBtn,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: Sizes.size40,
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(Sizes.size14),
          ),
          border: _isSelected
              ? Border.all(
                  color: Theme.of(context).primaryColor,
                )
              : Border.all(
                  color: Colors.white,
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  '개인정보 및 민감정보 수집 및 이용동의',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: Sizes.size12,
                  ),
                ),
                Gaps.h8,
                GestureDetector(
                  onTap: () => _showModal(context),
                  child: const Text(
                    '보기',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: Sizes.size10,
                      color: Color(0xff747474),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(
                        0xff747474,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SvgPicture.asset(
              'assets/images/detail_check.svg',
              width: Sizes.size14,
              height: Sizes.size14,
              fit: BoxFit.scaleDown,
              color: _isSelected
                  ? Theme.of(context).primaryColor
                  : const Color(0xffa8a8a8),
            ),
          ],
        ),
      ),
    );
  }
}
