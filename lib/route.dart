import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/features/postings/models/posting_model.dart';
import 'package:jay/features/postings/repos/posting_repo.dart';
import 'package:jay/features/postings/views/posting_detail_screen.dart';
import 'package:jay/features/postings/views/posting_screen.dart';

final routerProvider = Provider((ref) {
  final repo = ref.read(postingRepo);
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: PostingScreen.routeName,
        path: PostingScreen.routeURL,
        builder: (context, state) => const PostingScreen(),
      ),
      GoRoute(
        name: PostingDetailScreen.routeName,
        path: PostingDetailScreen.routeURL,
        builder: (context, state) {
          final item = state.extra as PostingModel?;
          if (item != null) {
            return PostingDetailScreen(item: item);
          }
          final postingId = int.tryParse(state.pathParameters['postingId'] ?? '');
          if (postingId == null) {
            return const PostingScreen();
          }
          return FutureBuilder<PostingModel?>(
            future: repo.getPostingById(postingId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              final fetched = snapshot.data;
              if (fetched == null) {
                return const PostingScreen();
              }
              return PostingDetailScreen(item: fetched);
            },
          );
        },
      ),
    ],
  );
});
