import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/community/view_models/community_view_model.dart';
import 'package:jay/features/community/widgets/community_post_card.dart';
import 'package:jay/features/users/repos/auth_repo.dart';
import 'package:jay/features/users/views/login_screen.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  static const routeURL = '/community';
  static const routeName = 'community';
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(() {
      final hasText = _searchController.text.isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(communityProvider.notifier).loadMore();
    }
  }

  void _onWriteTap() {
    final isLoggedIn = ref.read(authRepo).currentUser != null;
    if (!isLoggedIn) {
      context.push(LoginScreen.routeURL);
      return;
    }
    context.push('/community/write');
  }

  void _onSearch(String query) {
    ref.read(communityProvider.notifier).searchByTitle(query);
  }

  void _onClear() {
    _searchController.clear();
    ref.read(communityProvider.notifier).searchByTitle('');
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(communityProvider);
    final sort = ref.watch(communitySortProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF3F4F8),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leadingWidth: Sizes.size64,
        backgroundColor: const Color(0xffF3F4F8),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: Sizes.size14),
          child: SvgPicture.asset('assets/images/logo.svg'),
        ),
        title: Container(
          height: Sizes.size40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Sizes.size8),
            border: Border.all(color: const Color(0xffDAE1E9)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size10),
          child: TextField(
            controller: _searchController,
            onSubmitted: _onSearch,
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(fontSize: Sizes.size14),
            decoration: InputDecoration(
              hintText: '게시글 검색',
              hintStyle: const TextStyle(
                color: Color(0xffDAE1E9),
                fontFamily: 'PretendardMedium',
                fontSize: 13,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              suffixIcon: _hasText
                  ? GestureDetector(
                      onTap: _onClear,
                      child: const Icon(
                        Icons.close,
                        size: Sizes.size18,
                        color: Color(0xffA0A0A0),
                      ),
                    )
                  : const Icon(
                      size: Sizes.size24,
                      Icons.search,
                      color: Color(0xffDAE1E9),
                    ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: Sizes.size24,
                minHeight: Sizes.size40,
                maxHeight: Sizes.size40,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 배너 — 고정
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  Sizes.size12, Sizes.size12, Sizes.size12, 0),
              child: SizedBox(
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
                      child: Image.asset('assets/images/jay_img.png'),
                    ),
                  ],
                ),
              ),
            ),
            // 정렬 버튼 — 고정
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  Sizes.size16, Sizes.size16, Sizes.size16, Sizes.size8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      final next = sort == 'latest' ? 'popular' : 'latest';
                      ref.read(communitySortProvider.notifier).state = next;
                    },
                    child: Row(
                      children: [
                        Text(
                          sort == 'latest' ? '최신순' : '인기순',
                          style: const TextStyle(
                            fontSize: Sizes.size14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1154ED),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down,
                            size: 18, color: Color(0xff1154ED)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 포스트 목록 — 스크롤
            Expanded(
              child: posts.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('오류가 발생했습니다: $e')),
                data: (list) {
                  if (list.isEmpty) {
                    return const Center(
                      child: Text(
                        '아직 게시글이 없어요.\n첫 번째 글을 작성해보세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff9EA7B2),
                          fontSize: Sizes.size14,
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () =>
                        ref.read(communityProvider.notifier).refresh(),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size16, vertical: Sizes.size8),
                      itemCount: list.length + 1,
                      itemBuilder: (context, i) {
                        if (i == list.length) {
                          return ref
                                  .read(communityProvider.notifier)
                                  .isLoadingMore
                              ? const Padding(
                                  padding: EdgeInsets.all(Sizes.size16),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : Gaps.v16;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: Sizes.size10),
                          child: CommunityPostCard(
                            post: list[i],
                            onTap: () => context.push(
                                '/community/${list[i].id}',
                                extra: list[i]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: _onWriteTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff1154ED),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 4,
        ),
        icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
        label: const Text(
          '글쓰기',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.size14,
          ),
        ),
      ),
    );
  }
}
