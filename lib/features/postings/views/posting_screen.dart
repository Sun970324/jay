import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/postings/models/posting_model.dart';
import 'package:jay/features/postings/view_models/filter_view_model.dart';
import 'package:jay/features/postings/view_models/posting_view_model.dart';
import 'package:jay/features/postings/views/posting_detail_screen.dart';
import 'package:jay/features/postings/views/filter_modal.dart';
import 'package:jay/features/postings/widgets/posting_card.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/features/postings/widgets/search_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _postingScrollOffsetProvider = StateProvider<double>((ref) => 0.0);
final postingScrollToTopProvider = StateProvider<int>((ref) => 0);

class PostingScreen extends ConsumerStatefulWidget {
  static const routeURL = "/";
  static const routeName = "posting";
  const PostingScreen({super.key});

  @override
  ConsumerState<PostingScreen> createState() => _PostingScreenState();
}

class _PostingScreenState extends ConsumerState<PostingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final savedOffset = ref.read(_postingScrollOffsetProvider);
      if (savedOffset > 0 && _scrollController.hasClients) {
        _scrollController.jumpTo(savedOffset);
      }
      _checkAndShowInitialFilterModal();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);
    await ref.read(postingProvider.notifier).loadMore();
    if (mounted) setState(() => _isLoadingMore = false);
  }

  Future<void> _checkAndShowInitialFilterModal() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final hasShownBefore =
        prefs.getBool('has_shown_initial_filter_modal') ?? false;
    if (hasShownBefore) return;

    await prefs.setBool('has_shown_initial_filter_modal', true);

    if (mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => const FilterModal(),
      );
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Color(0xffDAE1E9),
          ),
          const SizedBox(height: Sizes.size16),
          const Text(
            '맞는 공고가 없어요',
            style: TextStyle(
              fontSize: Sizes.size18,
              fontWeight: FontWeight.w600,
              color: Color(0xff747474),
            ),
          ),
          const SizedBox(height: Sizes.size8),
          const Text(
            '필터나 검색어를 변경해보세요',
            style: TextStyle(
              fontSize: Sizes.size14,
              color: Color(0xffA0A0A0),
            ),
          ),
          const SizedBox(height: Sizes.size32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => _openFilterModal(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xff1154ED)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.size8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size20,
                    vertical: Sizes.size12,
                  ),
                ),
                child: const Text(
                  '필터 변경하기',
                  style: TextStyle(
                    color: Color(0xff1154ED),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: Sizes.size12),
              ElevatedButton(
                onPressed: () {
                  ref.read(postingProvider.notifier).searchByTitle('');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1154ED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.size8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size20,
                    vertical: Sizes.size12,
                  ),
                ),
                child: const Text(
                  '검색 초기화',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onTapCard(PostingModel item) {
    ref.read(_postingScrollOffsetProvider.notifier).state =
        _scrollController.offset;
    context.goNamed(
      PostingDetailScreen.routeName,
      pathParameters: {
        "postingId": "${item.id}",
      },
      extra: item,
    );
  }

  void _openFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) => const FilterModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(postingScrollToTopProvider, (_, __) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        ref.read(_postingScrollOffsetProvider.notifier).state = 0;
      }
    });
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F8),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leadingWidth: Sizes.size64,
        backgroundColor: const Color(0xffF3F4F8),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: Sizes.size14),
          child: GestureDetector(
            onTap: () =>
                ref.read(postingScrollToTopProvider.notifier).state++,
            child: SvgPicture.asset(
              'assets/images/logo.svg',
            ),
          ),
        ),
        title: Container(
          height: Sizes.size40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Sizes.size8),
            border: Border.all(color: const Color(0xffDAE1E9)),
          ),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Sizes.size8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size10,
            ),
            child: const SearchTextField(),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              Sizes.size12, Sizes.size12, Sizes.size12, 0),
          child: Column(
            children: [
              SizedBox(
                height: 70,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(50, 11, 15, 11),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFEAFF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '놓치기 쉬운 의료 혜택, 제이에서 빠르게 확인!',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PretendardBold',
                              color: Color(0xff001B51),
                            ),
                          ),
                          SizedBox(height: Sizes.size3),
                          Text(
                            '지금 바로 확인하고 필요한 지원을 챙기세요.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff5B88DE),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 8.5,
                      bottom: -6,
                      child: Image.asset(
                        'assets/images/jay_img.png',
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.v16,
              Container(
                margin: const EdgeInsets.only(right: 5),
                child: GestureDetector(
                  onTap: () => _openFilterModal(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '맞춤 필터 설정하기',
                        style: TextStyle(
                          fontSize: Sizes.size14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1154ED),
                        ),
                      ),
                      Gaps.h8,
                      SvgPicture.asset(
                        'assets/images/filter_icon.svg',
                        width: Sizes.size14,
                        height: Sizes.size14,
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.v8,
              Builder(builder: (context) {
                final chips = ref.watch(filterProvider).activeFilterChips;
                if (chips.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    height: 30,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: chips.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 6),
                      itemBuilder: (_, i) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xffEAF0FF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xff1154ED)),
                        ),
                        child: Text(
                          chips[i],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xff1154ED),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              Expanded(
                child: ref.watch(postingProvider).when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stackTrace) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '오류가 발생했어요.',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => ref.invalidate(postingProvider),
                              child: const Text('다시 시도'),
                            ),
                          ],
                        ),
                      ),
                      data: (postings) {
                        if (postings.isEmpty) {
                          return _buildEmptyState(context);
                        }
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: postings.length + (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == postings.length) {
                              return const Padding(
                                padding: EdgeInsets.all(Sizes.size16),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                            return GestureDetector(
                              onTap: () => _onTapCard(postings[index]),
                              child: PostingCard(
                                item: postings[index],
                                isDetailScreen: false,
                              ),
                            );
                          },
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
