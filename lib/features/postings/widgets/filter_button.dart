import 'package:flutter/material.dart';
import 'package:jay/constants/sizes.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    required this.callbackFn,
    super.key,
  });
  final VoidCallback callbackFn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callbackFn,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.size16),
          color: Theme.of(context).primaryColor,
        ),
        child: const Center(
          child: Text(
            '선택 완료',
            style: TextStyle(
                color: Colors.white, fontFamily: 'PretendardSemiBold'),
          ),
        ),
      ),
    );
  }
}
