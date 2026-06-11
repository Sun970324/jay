import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/postings/models/filter_model.dart';
import 'package:jay/features/postings/view_models/filter_view_model.dart';

class _BirthDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('.', '');
    if (digits.length > 6) return oldValue;

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2 || i == 4) buffer.write('.');
      buffer.write(digits[i]);
    }

    final text =
        digits.length == 6 ? '${buffer.toString()}.' : buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class BirthSelect extends ConsumerStatefulWidget {
  const BirthSelect({super.key, required this.filterModel});
  final FilterModel filterModel;

  @override
  ConsumerState<BirthSelect> createState() => _BirthSelectState();
}

class _BirthSelectState extends ConsumerState<BirthSelect> {
  late final TextEditingController _ctrl;

  int _toFullYear(int yy) {
    final currentYY = DateTime.now().year % 100;
    return yy <= currentYY ? 2000 + yy : 1900 + yy;
  }

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initFromSaved());
  }

  Future<void> _initFromSaved() async {
    await ref.read(filterProvider.notifier).loadSavedBirth();
    if (!mounted) return;

    final birth = ref.read(filterProvider).birth;
    if (birth != null) {
      final yy = (birth.year % 100).toString().padLeft(2, '0');
      final mm = birth.month.toString().padLeft(2, '0');
      final dd = birth.day.toString().padLeft(2, '0');
      _ctrl.text = '$yy.$mm.$dd.';
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onChanged(String value) async {
    if (value.length != 9) return; // YY.MM.DD. = 9자

    final parts = value.replaceAll(RegExp(r'\.$'), '').split('.');
    final yy = int.tryParse(parts[0]);
    final mm = int.tryParse(parts[1]);
    final dd = int.tryParse(parts[2]);

    if (yy == null || mm == null || dd == null) return;
    if (mm < 1 || mm > 12) return;
    final year = _toFullYear(yy);
    final lastDay = DateTime(year, mm + 1, 0).day;
    if (dd < 1 || dd > lastDay) return;

    await ref.read(filterProvider.notifier).saveBirth(DateTime(year, mm, dd));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.size16,
        vertical: Sizes.size10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(Sizes.size14)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '생년월일',
            style: TextStyle(
              fontSize: Sizes.size16,
              fontFamily: 'PretendardMedium',
            ),
          ),
          SizedBox(
            height: Sizes.size36,
            width: 140,
            child: TextField(
              controller: _ctrl,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _BirthDateFormatter(),
              ],
              textAlign: TextAlign.right,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(
                fontSize: Sizes.size14,
                letterSpacing: 1.5,
              ),
              onChanged: _onChanged,
              decoration: const InputDecoration(
                hintText: '예) 991231',
                hintStyle: TextStyle(
                  color: Color(0xff747474),
                  fontSize: 14,
                  fontFamily: 'PretendardRegular',
                ),
                counterText: '',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Sizes.size10,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffDAE1E9)),
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffDAE1E9)),
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff1154ED)),
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
