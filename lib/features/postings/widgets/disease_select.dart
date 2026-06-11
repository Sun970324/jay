import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/postings/models/filter_model.dart';
import 'package:jay/features/postings/models/posting_model.dart';
import 'package:jay/features/postings/view_models/filter_view_model.dart';
import 'package:jay/features/postings/widgets/filter_button.dart';

class DiseaseSelect extends ConsumerStatefulWidget {
  const DiseaseSelect({super.key, required this.filterModel});
  final FilterModel filterModel;

  @override
  ConsumerState<DiseaseSelect> createState() => _DiseaseSelectState();
}

class _DiseaseSelectState extends ConsumerState<DiseaseSelect> {
  final _diseaseList = diseaseList;
  bool _isExpanded = false;

  // 선택된 질병 항목을 관리하는 List
  List<int> selectedDiseases = [];

  @override
  void initState() {
    super.initState();
    // 이미 저장된 질병 정보가 있으면 초기 선택값으로 세팅
    if (widget.filterModel.disease.isNotEmpty) {
      selectedDiseases =
          widget.filterModel.disease.map((el) => int.parse(el)).toList();
    }
  }

  void _closeButton() async {
    final parseIntToStringList =
        selectedDiseases.map((el) => el.toString()).toList();
    // 선택된 질병 정보를 FilterViewModel에 저장
    await ref.read(filterProvider.notifier).saveDisease(parseIntToStringList);
    // 완료 후 접기
    setState(() {
      _isExpanded = false;
    });
  }

  void _clickDiseaseBtn(int value) {
    setState(() {
      if (value == 0) {
        // 전체 선택: 이미 선택됐으면 전체 해제, 아니면 전체 선택
        if (selectedDiseases.contains(0)) {
          selectedDiseases.clear();
        } else {
          selectedDiseases = List.generate(_diseaseList.length, (i) => i);
        }
      } else {
        // 개별 선택: 0(전체)이 있으면 제거 후 개별 토글
        selectedDiseases.remove(0);
        if (selectedDiseases.contains(value)) {
          selectedDiseases.remove(value);
        } else {
          selectedDiseases.add(value);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isExpanded ? 480 : Sizes.size56,
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size16,
          vertical: Sizes.size16,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Sizes.size14),
            topRight: Radius.circular(Sizes.size14),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '질병 정보',
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    fontFamily: 'PretendardMedium',
                  ),
                ),
                Gaps.h20,
                Expanded(
                  child: selectedDiseases.isEmpty
                      ? const SizedBox.shrink()
                      : Text(
                          selectedDiseases.contains(0)
                              ? '전체 선택'
                              : selectedDiseases
                                  .map((i) => _diseaseList[i])
                                  .join(', '),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 15.5,
                            color: Color(0xff747474),
                            fontFamily: 'PretendardMedium',
                          ),
                        ),
                ),
                Gaps.h10,
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
            if (_isExpanded)
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Sizes.size10),
                          child: Text(
                            '중복 선택 가능합니다.',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: Sizes.size12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: Sizes.size14,
                          crossAxisSpacing: Sizes.size16,
                          childAspectRatio: 3.7,
                        ),
                        itemCount: _diseaseList.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () => _clickDiseaseBtn(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.size2,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedDiseases.contains(index)
                                    ? Theme.of(context).primaryColor
                                    : const Color(0xffDAE1E9),
                              ),
                              borderRadius: BorderRadius.circular(Sizes.size7),
                              color: selectedDiseases.contains(index)
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _diseaseList[index],
                                    style: TextStyle(
                                      color: selectedDiseases.contains(index)
                                          ? Colors.white
                                          : const Color(0xff747474),
                                      fontFamily: 'PretendardMedium',
                                      fontSize: Sizes.size14,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/detail_check.svg',
                                    width: Sizes.size14,
                                    height: Sizes.size14,
                                    fit: BoxFit.scaleDown,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gaps.v10,
                    FilterButton(callbackFn: _closeButton),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
