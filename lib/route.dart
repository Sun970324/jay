import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/features/community/views/community_detail_screen.dart';
import 'package:jay/features/community/views/community_screen.dart';
import 'package:jay/features/community/models/community_post_model.dart';
import 'package:jay/features/community/views/community_write_screen.dart';
import 'package:jay/features/postings/models/posting_model.dart';
import 'package:jay/features/postings/repos/posting_repo.dart';
import 'package:jay/features/postings/views/posting_detail_screen.dart';
import 'package:jay/features/postings/views/posting_screen.dart';
import 'package:jay/features/users/views/login_screen.dart';
import 'package:jay/features/users/views/my_page_screen.dart';
import 'package:jay/features/users/views/edit_profile_screen.dart';
import 'package:jay/features/users/views/my_comments_screen.dart';
import 'package:jay/features/users/views/onboarding_screen.dart';
import 'package:jay/features/users/views/my_posts_screen.dart';
import 'package:jay/features/legal/views/privacy_policy_screen.dart';
import 'package:jay/main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _AuthRefreshStream extends ChangeNotifier {
  _AuthRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final routerProvider = Provider((ref) {
  final repo = ref.read(postingRepo);
  return GoRouter(
    initialLocation: '/',
    refreshListenable: _AuthRefreshStream(
      Supabase.instance.client.auth.onAuthStateChange.where(
        (event) =>
            event.event == AuthChangeEvent.signedIn ||
            event.event == AuthChangeEvent.signedOut,
      ),
    ),
    redirect: (context, state) {
      final user = Supabase.instance.client.auth.currentUser;
      final isLoggedIn = user != null;
      final hasNickname = user?.userMetadata?['nickname'] != null;
      final path = state.uri.path;

      if (isLoggedIn && path == LoginScreen.routeURL) return '/';
      if (isLoggedIn && !hasNickname && path != OnboardingScreen.routeURL) {
        return OnboardingScreen.routeURL;
      }
      return null;
    },
    routes: [
      GoRoute(
        name: LoginScreen.routeName,
        path: LoginScreen.routeURL,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: OnboardingScreen.routeName,
        path: OnboardingScreen.routeURL,
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            name: PostingScreen.routeName,
            path: PostingScreen.routeURL,
            builder: (context, state) => const PostingScreen(),
          ),
          GoRoute(
            name: CommunityScreen.routeName,
            path: CommunityScreen.routeURL,
            builder: (context, state) => const CommunityScreen(),
          ),
          GoRoute(
            name: MyPageScreen.routeName,
            path: MyPageScreen.routeURL,
            builder: (context, state) => const MyPageScreen(),
          ),
        ],
      ),
      GoRoute(
        name: CommunityWriteScreen.routeName,
        path: CommunityWriteScreen.routeURL,
        builder: (context, state) => CommunityWriteScreen(
          post: state.extra as CommunityPostModel?,
        ),
      ),
      GoRoute(
        name: MyPostsScreen.routeName,
        path: MyPostsScreen.routeURL,
        builder: (context, state) => const MyPostsScreen(),
      ),
      GoRoute(
        name: MyCommentsScreen.routeName,
        path: MyCommentsScreen.routeURL,
        builder: (context, state) => const MyCommentsScreen(),
      ),
      GoRoute(
        name: EditProfileScreen.routeName,
        path: EditProfileScreen.routeURL,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        name: PrivacyPolicyScreen.routeName,
        path: PrivacyPolicyScreen.routeURL,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        name: TermsOfServiceScreen.routeName,
        path: TermsOfServiceScreen.routeURL,
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
      GoRoute(
        name: CommunityDetailScreen.routeName,
        path: '/community/:postId',
        builder: (context, state) {
          final post = state.extra as dynamic;
          return CommunityDetailScreen(post: post);
        },
      ),
      GoRoute(
        name: PostingDetailScreen.routeName,
        path: PostingDetailScreen.routeURL,
        builder: (context, state) {
          final item = state.extra as PostingModel?;
          if (item != null) {
            return PostingDetailScreen(item: item);
          }
          // 새로고침 시 extra가 없으면 URL의 postingId로 DB 조회
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
