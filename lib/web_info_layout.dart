import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';

class WebInfoLayout extends StatelessWidget {
  const WebInfoLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Color(0xff838383),
          fontFamily: 'PretendardMedium',
        ),
        child: Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: Sizes.size24,
          runSpacing: Sizes.size16,
          children: [
            Gaps.v10,
            Image.asset(
              'assets/images/web_jay_img.png',
              width: 220,
              height: 270,
            ),
            Gaps.h1,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gaps.v20,
                SvgPicture.asset(
                  'assets/images/web_jay_logo.svg',
                  width: 30,
                  height: 40,
                ),
                Gaps.v24,
                const Text(
                  '꼭 필요한 의료지원 정보,',
                  style: TextStyle(
                    fontSize: Sizes.size20,
                  ),
                ),
                const Text(
                  'Jay에서 찾아요!',
                  style: TextStyle(
                    fontSize: Sizes.size20,
                  ),
                ),
                Gaps.v24,
                const Text(
                  '복잡하게 찾아 헤매지 않아도 돼요.',
                  style: TextStyle(
                    fontSize: Sizes.size14,
                    fontFamily: 'PretendardRegular',
                    height: 1.5,
                    color: Color(0xff737373),
                  ),
                ),
                const Text(
                  'Jay가 딱 맞는 정보를 알려드려요.',
                  style: TextStyle(
                    fontSize: Sizes.size14,
                    fontFamily: 'PretendardRegular',
                    height: 1.5,
                    color: Color(0xff737373),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
