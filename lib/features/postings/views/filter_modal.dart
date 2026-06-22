import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/postings/models/filter_model.dart';
import 'package:jay/features/postings/view_models/posting_view_model.dart';
import 'package:jay/features/postings/widgets/birth_select.dart';
import 'package:jay/features/postings/widgets/disease_select.dart';
import 'package:jay/features/postings/widgets/family_select.dart';
import 'package:jay/features/postings/widgets/location_select.dart';
import 'package:jay/features/postings/view_models/filter_view_model.dart';
import 'package:jay/features/postings/widgets/terms_of_service_select.dart';

class FilterModal extends ConsumerStatefulWidget {
  const FilterModal({super.key});

  @override
  ConsumerState<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends ConsumerState<FilterModal> {
  void _onClosePressed() {
    Navigator.of(context).pop();
  }

  /// 필터설정 초기화 버튼
  void _onTapInitial() async {
    await ref.read(filterProvider.notifier).clearAllFilters();
    await ref.read(postingProvider.notifier).refreshWithFilter(null);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  /// 필터설정 저장 버튼
  void _onTapSave() async {
    final filter = ref.read(filterProvider);
    if (!filter.isPersonalInfoConsent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('개인정보 및 민감정보 수집·이용에 동의해 주세요.'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.fixed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      );
      return;
    }
    await ref.read(postingProvider.notifier).refreshWithFilter(filter);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final FilterModel filterModel = ref.watch(filterProvider);
    final bool consented = filterModel.isPersonalInfoConsent;
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.93,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.size16),
          color: Colors.grey.shade200),
      child: Scaffold(
        backgroundColor: const Color(0xffF3F4F8),
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: const Color(0xffF3F4F8),
          automaticallyImplyLeading: false,
          title: const Padding(
            padding: EdgeInsets.only(top: Sizes.size20),
            child: Text(
              '맞춤 정보 검색하기',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Sizes.size18,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                top: Sizes.size20,
                right: Sizes.size8,
              ),
              child: IconButton(
                  onPressed: _onClosePressed,
                  icon: SvgPicture.asset('assets/images/cancle_icon.svg')),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(Sizes.size10),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size8),
              child: Column(
                children: [
                  Gaps.v10,
                  DiseaseSelect(filterModel: filterModel),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 0,
                    thickness: 0.8,
                    indent: Sizes.size16,
                    endIndent: Sizes.size16,
                  ),
                  LocationSelect(filterModel: filterModel),
                  Gaps.v10,
                  BirthSelect(filterModel: filterModel),
                  Gaps.v10,
                  FamilySelect(filterModel: filterModel),
                  Gaps.v32,
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/detail_check.svg',
                        width: Sizes.size14,
                        height: Sizes.size14,
                        fit: BoxFit.scaleDown,
                        color: Theme.of(context).primaryColor,
                      ),
                      Gaps.h7,
                      Text(
                        '의료지원 정책 추천을 위해 동의해주세요.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Sizes.size14,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Gaps.v12,
                  const TermsOfServiceSelect(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.only(
            bottom: Sizes.size28,
            right: Sizes.size16,
            left: Sizes.size16,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Sizes.size12),
              topRight: Radius.circular(Sizes.size12),
            ),
          ),
          child: BottomAppBar(
            color: Colors.white,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _onTapInitial,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: Sizes.size10,
                      ),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.size9),
                        border: Border.all(
                          color: const Color(0xffE1E1E1),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '초기화',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.size16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Gaps.h8,
                Expanded(
                  child: GestureDetector(
                    onTap: _onTapSave,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: Sizes.size10,
                      ),
                      width: 175,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.size9),
                        color: consented
                            ? Theme.of(context).primaryColor
                            : const Color(0xffC0C0C0),
                      ),
                      child: const Center(
                        child: Text(
                          '저장하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Sizes.size16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
