import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/postings/models/posting_model.dart';
import 'package:jay/features/postings/repos/posting_repo.dart';
import 'package:jay/features/postings/widgets/posting_card.dart';

class MyScrapsScreen extends ConsumerStatefulWidget {
  static const routeURL = '/my-scraps';
  static const routeName = 'myScraps';
  const MyScrapsScreen({super.key});

  @override
  ConsumerState<MyScrapsScreen> createState() => _MyScrapsScreenState();
}

class _MyScrapsScreenState extends ConsumerState<MyScrapsScreen> {
  late Future<List<PostingModel>> _scrapsFuture;

  @override
  void initState() {
    super.initState();
    _scrapsFuture = ref.read(postingRepo).getScrappedPostings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F8),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xffF3F4F8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '저장한 공고',
          style: TextStyle(fontSize: Sizes.size18, fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<List<PostingModel>>(
        future: _scrapsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('오류가 발생했어요.',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() {
                      _scrapsFuture =
                          ref.read(postingRepo).getScrappedPostings();
                    }),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }
          final postings = snapshot.data ?? [];
          if (postings.isEmpty) {
            return const Center(
              child: Text(
                '저장한 공고가 없어요',
                style: TextStyle(
                    fontSize: Sizes.size14, color: Color(0xff9EA7B2)),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(Sizes.size16),
            itemCount: postings.length,
            separatorBuilder: (_, __) => Gaps.v10,
            itemBuilder: (context, i) {
              final posting = postings[i];
              return GestureDetector(
                onTap: () =>
                    context.push('/detail/${posting.id}', extra: posting),
                child: PostingCard(item: posting, isDetailScreen: false),
              );
            },
          );
        },
      ),
    );
  }
}
