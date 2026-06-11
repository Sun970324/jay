import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';

class PostingDetailDescription extends StatelessWidget {
  const PostingDetailDescription({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.size14,
        vertical: Sizes.size18,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontFamily: 'PretendardSemiBold',
            ),
          ),
          Gaps.v4,
          ...items.map((item) => _buildItem(item)),
        ],
      ),
    );
  }

  Widget _buildItem(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 14, 4, 4),
      child: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: Sizes.size3),
            child: SvgPicture.asset('assets/images/detail_check.svg'),
          ),
          Gaps.h8,
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14.5,
                fontFamily: 'PretendardRegular',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
