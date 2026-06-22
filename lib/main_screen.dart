import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jay/features/postings/views/posting_screen.dart';

class MainScreen extends ConsumerWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  int _tabIndex(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    if (path.startsWith('/community')) return 1;
    if (path.startsWith('/my-page')) return 2;
    return 0;
  }

  void _onTap(BuildContext context, WidgetRef ref, int index) {
    if (index == 0 && _tabIndex(context) == 0) {
      ref.read(postingScrollToTopProvider.notifier).state++;
      return;
    }
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/community');
      case 2:
        context.go('/my-page');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: Colors.transparent,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return IconThemeData(
                  color: selected
                      ? const Color(0xff1154ED)
                      : const Color(0xff9E9E9E),
                  size: 26,
                );
              }),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return TextStyle(
                  fontSize: 11,
                  fontFamily: selected ? 'PretendardBold' : 'PretendardMedium',
                  color: selected
                      ? const Color(0xff1154ED)
                      : const Color(0xff9E9E9E),
                );
              }),
            ),
            child: NavigationBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              selectedIndex: _tabIndex(context),
              onDestinationSelected: (i) => _onTap(context, ref, i),
              destinations: [
                NavigationDestination(
                  icon: SvgPicture.asset('assets/images/postings_nav_icon.svg',
                      width: 26,
                      height: 26,
                      colorFilter: const ColorFilter.mode(
                          Color(0xff9E9E9E), BlendMode.srcIn)),
                  selectedIcon: SvgPicture.asset(
                      'assets/images/postings_nav_icon.svg',
                      width: 26,
                      height: 26,
                      colorFilter: const ColorFilter.mode(
                          Color(0xff1154ED), BlendMode.srcIn)),
                  label: '맞춤 지원',
                ),
                NavigationDestination(
                  icon: SvgPicture.asset('assets/images/community_nav_icon.svg',
                      width: 26,
                      height: 26,
                      colorFilter: const ColorFilter.mode(
                          Color(0xff9E9E9E), BlendMode.srcIn)),
                  selectedIcon: SvgPicture.asset(
                      'assets/images/community_nav_icon.svg',
                      width: 26,
                      height: 26,
                      colorFilter: const ColorFilter.mode(
                          Color(0xff1154ED), BlendMode.srcIn)),
                  label: '커뮤니티',
                ),
                NavigationDestination(
                  icon: SvgPicture.asset('assets/images/mypage_nav_icon.svg',
                      width: 26,
                      height: 26,
                      colorFilter: const ColorFilter.mode(
                          Color(0xff9E9E9E), BlendMode.srcIn)),
                  selectedIcon: SvgPicture.asset(
                      'assets/images/mypage_nav_icon.svg',
                      width: 26,
                      height: 26,
                      colorFilter: const ColorFilter.mode(
                          Color(0xff1154ED), BlendMode.srcIn)),
                  label: '마이페이지',
                ),
              ],
            ),
          ),
        ),
    );
  }
}
