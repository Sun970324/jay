import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/postings/models/posting_model.dart';

class PostingCard extends StatelessWidget {
  const PostingCard(
      {super.key, required this.item, required this.isDetailScreen});
  final PostingModel item;
  final bool isDetailScreen;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final endDateOnly =
        DateTime(item.endDate.year, item.endDate.month, item.endDate.day);
    final todayOnly = DateTime(now.year, now.month, now.day);
    final daysLeft = endDateOnly.difference(todayOnly).inDays;
    final formatter = DateFormat('yyyy-MM-dd');

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Sizes.size8,
        horizontal: isDetailScreen ? 0 : Sizes.size2,
      ),
      constraints: const BoxConstraints(maxHeight: 250),
      height: isDetailScreen ? 200 : 140,
      decoration: BoxDecoration(
        color: isDetailScreen ? const Color(0xffF3F4F8) : Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: isDetailScreen
            ? BorderRadius.circular(0)
            : BorderRadius.circular(Sizes.size8),
        boxShadow: isDetailScreen
            ? []
            : [
                BoxShadow(
                  color: const Color(0XFF000066).withOpacity(0.06),
                  blurRadius: 1,
                  spreadRadius: 2,
                  offset: const Offset(0, 0),
                ),
              ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: isDetailScreen ? Sizes.size18 : Sizes.size12,
          right: isDetailScreen ? Sizes.size18 : Sizes.size12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth * 0.8),
                        child: Text(
                          item.title,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontFamily: 'PretendardSemiBold',
                            fontSize: isDetailScreen ? 18 : 15.5,
                          ),
                        ),
                      ),
                      _buildDdayTag(daysLeft),
                    ],
                  );
                },
              ),
            ),
            Column(
              children: [
                Divider(
                  height: 18,
                  color: Colors.grey.shade300,
                ),
                if (isDetailScreen) ...[
                  _buildInfoRow('지원 혜택', item.contentSummary),
                  _buildInfoRow(
                    '대상 질병',
                    item.targetDisease
                        .map((el) => el == 0 ? '모든 질병' : diseaseList[el])
                        .join(', '),
                  ),
                  _buildInfoRow(
                    '신청 기간',
                    item.endDate == DateTime(9999, 12, 31)
                        ? '상시모집'
                        : '~ ${formatter.format(item.endDate)}',
                  ),
                  _buildInfoRow('지원 기관', item.institution[0]),
                ] else ...[
                  _buildInfoRow('지원 혜택', item.contentSummary),
                  _buildInfoRow(
                      '대상 질병',
                      item.targetDisease
                          .map((el) => el == 0 ? '모든 질병' : diseaseList[el])
                          .join(', ')),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 정보 한 줄 위젯
Widget _buildInfoRow(String label, String value) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                  color: Color(0xff747474),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
            Gaps.h10,
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.7),
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xff222222),
                  fontFamily: 'PretendardRegular',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// D-day 태그: 10일 이내 빨간색, 30일 이내 노란색, 그 이상 파란색
Widget _buildDdayTag(int daysLeft) {
  String label;
  Color bgColor;
  Color textColor;
  if (daysLeft < 0) {
    label = '마감';
    bgColor = Colors.grey.shade300;
    textColor = Colors.grey.shade700;
  } else if (daysLeft == 0) {
    label = 'D-day';
    bgColor = const Color(0xffFFEFEF);
    textColor = const Color(0xffFF6868);
  } else if (daysLeft <= 10) {
    label = 'D-$daysLeft';
    bgColor = const Color(0xffFFEFEF);
    textColor = const Color(0xffFF6868);
  } else if (daysLeft <= 30) {
    label = 'D-$daysLeft';
    bgColor = const Color(0xffFDF4D2);
    textColor = const Color(0xffFF9D00);
  } else if (daysLeft <= 365) {
    label = 'D-$daysLeft';
    bgColor = const Color(0xffE8F6F0);
    textColor = const Color(0xff17A34A);
  } else {
    label = '상시모집';
    bgColor = const Color(0xffE8F6F0);
    textColor = const Color(0xff17A34A);
  }

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: Sizes.size8,
      vertical: Sizes.size3,
    ),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(Sizes.size3),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 11.5,
      ),
    ),
  );
}
