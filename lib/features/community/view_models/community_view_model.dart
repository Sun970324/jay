import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jay/features/community/models/community_post_model.dart';
import 'package:jay/features/community/repos/community_repo.dart';

final communitySortProvider = StateProvider<String>((ref) => 'latest');
final communitySearchProvider = StateProvider<String>((ref) => '');

class CommunityViewModel extends AsyncNotifier<List<CommunityPostModel>> {
  static const _limit = 10;
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<List<CommunityPostModel>> build() async {
    _offset = 0;
    _hasMore = true;
    final sort = ref.watch(communitySortProvider);
    final query = ref.watch(communitySearchProvider);
    return ref.read(communityRepo).getPosts(sort: sort, offset: 0, query: query);
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;
    final current = state.valueOrNull ?? [];
    _isLoadingMore = true;
    _offset += _limit;
    final sort = ref.read(communitySortProvider);
    final query = ref.read(communitySearchProvider);
    final more = await ref.read(communityRepo).getPosts(sort: sort, offset: _offset, query: query);
    _hasMore = more.length == _limit;
    _isLoadingMore = false;
    state = AsyncData([...current, ...more]);
  }

  Future<void> refresh() async {
    _offset = 0;
    _hasMore = true;
    state = const AsyncLoading();
    final sort = ref.read(communitySortProvider);
    final query = ref.read(communitySearchProvider);
    final posts = await ref.read(communityRepo).getPosts(sort: sort, offset: 0, query: query);
    state = AsyncData(posts);
  }

  void searchByTitle(String query) {
    ref.read(communitySearchProvider.notifier).state = query;
  }
}

final communityProvider =
    AsyncNotifierProvider<CommunityViewModel, List<CommunityPostModel>>(
  () => CommunityViewModel(),
);
