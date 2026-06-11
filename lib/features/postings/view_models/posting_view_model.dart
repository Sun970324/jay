import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jay/features/postings/models/filter_model.dart';
import 'package:jay/features/postings/models/posting_model.dart';
import 'package:jay/features/postings/repos/posting_repo.dart';
import 'package:jay/features/postings/view_models/filter_view_model.dart';

class PostingViewModel extends AsyncNotifier<List<PostingModel>> {
  List<PostingModel> _list = [];
  String _lastQueryText = '';
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<List<PostingModel>> _fetchPostings({
    FilterModel? filter,
    String? queryText,
    int offset = 0,
  }) async {
    final repository = ref.read(postingRepo);
    return repository.getPostings(
      filter: filter,
      queryText: queryText,
      offset: offset,
    );
  }

  @override
  FutureOr<List<PostingModel>> build() async {
    final filter = ref.watch(filterProvider);
    final effectiveFilter = filter.isPersonalInfoConsent ? filter : null;
    _offset = 0;
    _hasMore = true;
    _list = await _fetchPostings(filter: effectiveFilter, queryText: _lastQueryText);
    if (_list.length < 10) _hasMore = false;
    _offset = _list.length;
    return _list;
  }

  Future<void> refreshWithFilter(FilterModel? filter) async {
    _offset = 0;
    _hasMore = true;
    state = const AsyncLoading();
    final result = await _fetchPostings(
      filter: filter,
      queryText: _lastQueryText,
      offset: 0,
    );
    if (result.length < 10) _hasMore = false;
    _offset = result.length;
    _list = result;
    state = AsyncData(result);
  }

  Future<void> searchByTitle(String queryText) async {
    _lastQueryText = queryText;
    ref.read(searchQueryProvider.notifier).state = queryText;
    final filter = ref.read(filterProvider);
    final effectiveFilter = filter.isPersonalInfoConsent ? filter : null;
    await refreshWithFilter(effectiveFilter);
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    final filter = ref.read(filterProvider);
    final effectiveFilter = filter.isPersonalInfoConsent ? filter : null;
    final newItems = await _fetchPostings(
      filter: effectiveFilter,
      queryText: _lastQueryText,
      offset: _offset,
    );
    if (newItems.length < 10) _hasMore = false;
    _offset += newItems.length;
    _list = [..._list, ...newItems];
    _isLoadingMore = false;
    state = AsyncData(_list);
  }
}

final postingProvider =
    AsyncNotifierProvider<PostingViewModel, List<PostingModel>>(
  () => PostingViewModel(),
);

final searchQueryProvider = StateProvider<String>((ref) => '');
