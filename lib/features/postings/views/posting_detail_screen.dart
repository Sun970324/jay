import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/postings/models/posting_model.dart';
import 'package:jay/features/postings/widgets/posting_card.dart';
import 'package:jay/features/postings/widgets/posting_detail_description.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PostingDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "detail";
  static const String routeURL = "/detail/:postingId";
  const PostingDetailScreen({super.key, required this.item});
  final PostingModel item;

  @override
  ConsumerState<PostingDetailScreen> createState() =>
      _PostingDetailScreenState();
}

class _PostingDetailScreenState extends ConsumerState<PostingDetailScreen> {
  void _onTapShare() {
    final uri = Uri.base.replace(
      path: '/detail/${widget.item.id}',
      query: null,
      fragment: null,
    );
    final params = ShareParams(uri: uri);
    SharePlus.instance.share(params);
  }

  Future<void> _onTapSiteLink() async {
    final uri = Uri.tryParse(widget.item.siteLink);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => context.go('/'),
          child: SvgPicture.asset(
            'assets/images/chevron_left.svg',
            width: Sizes.size14,
            height: Sizes.size14,
            fit: BoxFit.scaleDown,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Sizes.size14),
            child: GestureDetector(
                onTap: () => _onTapShare(),
                child: SvgPicture.asset('assets/images/share.svg')),
          ),
          const SizedBox(width: Sizes.size10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PostingCard(
              item: widget.item,
              isDetailScreen: true,
            ),
            const SizedBox(height: Sizes.size10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size18),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: Sizes.size8,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/detail_screen_eye.svg',
                            width: Sizes.size24,
                          ),
                        ),
                        Text(
                          textAlign: TextAlign.left,
                          '지원 정보 한 눈에 보기',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.item.supportTarget.isNotEmpty) ...[
                    PostingDetailDescription(
                      title: '지원 대상',
                      items: widget.item.supportTarget,
                    ),
                    const SizedBox(height: Sizes.size14),
                  ],
                  if (widget.item.content.isNotEmpty) ...[
                    PostingDetailDescription(
                      title: '지원 혜택',
                      items: widget.item.content,
                    ),
                    const SizedBox(height: Sizes.size14),
                  ],
                  if (widget.item.receiptMethod.isNotEmpty) ...[
                    PostingDetailDescription(
                      title: '접수 방법',
                      items: widget.item.receiptMethod,
                    ),
                    const SizedBox(height: Sizes.size14),
                  ],
                  if (widget.item.institution.isNotEmpty) ...[
                    PostingDetailDescription(
                      title: '기관 정보',
                      items: widget.item.institution,
                    ),
                    const SizedBox(height: Sizes.size14),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Sizes.size8),
            topRight: Radius.circular(Sizes.size8),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Sizes.size8),
            topRight: Radius.circular(Sizes.size8),
          ),
          child: BottomAppBar(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size14,
              horizontal: Sizes.size24,
            ),
            height: Sizes.size80,
            color: Colors.white,
            elevation: 1,
            child: GestureDetector(
              onTap: _onTapSiteLink,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Center(
                  child: Text(
                    '사이트 바로가기',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PretendardSemiBold',
                      fontSize: Sizes.size16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
