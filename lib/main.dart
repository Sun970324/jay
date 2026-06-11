import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jay/constants/breakpoints.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jay/features/postings/repos/filter_repo.dart';
import 'package:jay/features/postings/view_models/posting_view_model.dart';
import 'package:jay/firebase_options.dart';
import 'package:jay/route.dart';
import 'package:jay/web_info_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jay/features/postings/view_models/filter_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(
    fileName: kDebugMode ? "assets/config/.env.dev" : "assets/config/.env.prod",
  );
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final preferences = await SharedPreferences.getInstance();
  final filterRepo = FilterRepository(preferences);
  setPathUrlStrategy();

  runApp(ProviderScope(
    overrides: [
      postingProvider.overrideWith(() => PostingViewModel()),
      filterProvider.overrideWith(() => FilterViewModel(filterRepo)),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      title: 'Jay',
      builder: (context, child) {
        if (!kIsWeb || child == null) return child ?? const SizedBox.shrink();

        final screenWidth = MediaQuery.of(context).size.width;
        const appWidth = 500.0;

        // 브레이크포인트 이하면 앱만 전체화면 표시
        if (screenWidth < Breakpoints.md) {
          return child;
        }

        final leftPadding = screenWidth * 0.05;
        // md(768)에서 0, lg(1024)에서 leftPadding과 동일하게 선형 증가
        final t =
            ((screenWidth - Breakpoints.md) / (Breakpoints.lg - Breakpoints.md))
                .clamp(0.0, 1.0);
        final rightPadding = leftPadding * t;

        return Padding(
          padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
          child: Row(
            children: [
              // 왼쪽: 앱 설명 / 광고 문구
              const WebInfoLayout(),
              // 오른쪽: 실제 앱 화면 (고정 500px)
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: const Color(0XFF000066).withOpacity(0.07),
                    blurRadius: 2,
                    spreadRadius: 3,
                    offset: const Offset(1, 0),
                  ),
                ]),
                width: appWidth,
                child: child,
              ),
            ],
          ),
        );
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ko', ''),
      ],
      theme: ThemeData(
        fontFamily: 'Pretendard',
        dividerColor: const Color(0xffDAE1E9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff1154ED),
          primary: const Color(0xff1154ED),
        ),
        dividerTheme: const DividerThemeData(color: Color(0xffF0F7F1)),
        useMaterial3: true,
      ),
    );
  }
}

final supabase = Supabase.instance.client;
