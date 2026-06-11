import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/postings/models/filter_model.dart';
import 'package:jay/features/postings/view_models/filter_view_model.dart';

class FamilySelect extends ConsumerStatefulWidget {
  const FamilySelect({super.key, required this.filterModel});
  final FilterModel filterModel;

  @override
  ConsumerState<FamilySelect> createState() => _FamilySelectState();
}

class _FamilySelectState extends ConsumerState<FamilySelect> {
  late final TextEditingController _familyController;
  late final TextEditingController _incomeController;

  @override
  void initState() {
    super.initState();
    _familyController = TextEditingController();
    _incomeController = TextEditingController();

    // 초기값: 이미 Provider 또는 Preference에 값이 있으면 해당 값으로 세팅
    // build 완료 후에 provider 수정 (위젯 생명주기 중 provider 수정 방지)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFromSaved();
    });
  }

  Future<void> _initFromSaved() async {
    // SharedPreferences에서 저장된 값 로드 후 상태에 반영
    await ref.read(filterProvider.notifier).loadSavedIncomeAndFamily();
    if (!mounted) return;

    final filter = ref.read(filterProvider);
    if (filter.familyCount > 0) {
      _familyController.text = filter.familyCount.toString();
    } else if (widget.filterModel.familyCount > 0) {
      _familyController.text = widget.filterModel.familyCount.toString();
    }

    if (filter.income > 0) {
      _incomeController.text = filter.income.toString();
    } else if (widget.filterModel.income > 0) {
      _incomeController.text = widget.filterModel.income.toString();
    }
  }

  Future<void> _onFamilyChanged(String value) async {
    final family = int.tryParse(value) ?? 0;
    final income = int.tryParse(_incomeController.text) ?? 0;
    await ref
        .read(filterProvider.notifier)
        .saveIncomeAndFamily(income: income, familyCount: family);
  }

  Future<void> _onIncomeChanged(String value) async {
    final income = int.tryParse(value) ?? 0;
    final family = int.tryParse(_familyController.text) ?? 0;
    await ref
        .read(filterProvider.notifier)
        .saveIncomeAndFamily(income: income, familyCount: family);
  }

  @override
  void dispose() {
    _familyController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final incomeRate = ref.watch(filterProvider).incomeRate;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.size16,
        vertical: Sizes.size10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(Sizes.size14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '가구원 수',
                style: TextStyle(
                  fontSize: Sizes.size16,
                  fontFamily: 'PretendardMedium',
                ),
              ),
              SizedBox(
                height: Sizes.size36,
                width: 140,
                child: TextField(
                  controller: _familyController,
                  style: const TextStyle(fontSize: Sizes.size14),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: _onFamilyChanged,
                  decoration: const InputDecoration(
                    counterText: '',
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        widthFactor: 1.0,
                        child: Text(
                          '명',
                          style: TextStyle(
                            color: Color(0xff747474),
                            fontSize: 14,
                            fontFamily: 'PretendardRegular',
                          ),
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffDAE1E9)),
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffDAE1E9)),
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Sizes.size10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: 0.8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '가구 월소득',
                style: TextStyle(
                  fontSize: Sizes.size16,
                  fontFamily: 'PretendardMedium',
                ),
              ),
              SizedBox(
                height: Sizes.size36,
                width: 140,
                child: TextField(
                  controller: _incomeController,
                  style: const TextStyle(fontSize: Sizes.size14),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  onChanged: _onIncomeChanged,
                  textAlign: TextAlign.right,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: const InputDecoration(
                    counterText: '',
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        widthFactor: 1.0,
                        child: Text(
                          '만원',
                          style: TextStyle(
                              color: Color(0xff747474),
                              fontSize: 14,
                              fontFamily: 'PretendardRegular'),
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffDAE1E9)),
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffDAE1E9)),
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Sizes.size10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (incomeRate > 0) ...[
            // const Divider(thickness: 0.8),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '기준 중위소득 약 $incomeRate%',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xff4A7CFE),
                      fontFamily: 'PretendardMedium',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
