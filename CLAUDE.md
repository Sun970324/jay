# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run app
flutter run

# Run on specific platform
flutter run -d chrome        # Web
flutter run -d ios           # iOS simulator
flutter run -d macos         # macOS

# Build
flutter build web
flutter build ios

# Install dependencies
flutter pub get

# Lint / analyze
flutter analyze

# Run tests
flutter test
flutter test test/widget_test.dart   # single test file
```

## Environment Setup

The app requires `assets/config/.env` with:
```
SUPABASE_URL=...
SUPABASE_ANON_KEY=...
```

## Architecture

This is a Flutter app (Korean medical welfare benefits aggregator) targeting web + mobile. App name is "제이(Jay)".

**State management**: Flutter Riverpod (`flutter_riverpod`) with the MVVM pattern:
- `models/` — plain data classes (no logic)
- `repos/` — data access layer (Supabase queries, SharedPreferences persistence)
- `view_models/` — `Notifier`/`AsyncNotifier` providers that bridge repos and views
- `views/` — full screens
- `widgets/` — reusable UI components

**Routing**: `go_router` via `routerProvider` in `lib/route.dart`. Routes are `/` (PostingScreen) and `/posting/:postingId` (PostingDetailScreen). Route extra carries the full `PostingModel` object.

**Backend**: Supabase (`postings` table). The `PostingRepository` builds dynamic queries based on `FilterModel` fields. Query results are limited to 10 items.

**Filter persistence**: `FilterRepository` (in `posting_repo.dart` pattern, `repos/filter_repo.dart`) uses `SharedPreferences` to persist user filter state across sessions. On first launch with no saved filters, `PostingScreen` automatically opens `FilterModal`.

**Web layout**: On web, `main.dart` wraps the app in a two-column layout — left column (`WebInfoLayout`) shows marketing copy, right column shows the app UI capped at 500px wide.

**Key providers**:
- `postingProvider` — `AsyncNotifierProvider<PostingViewModel, List<PostingModel>>` — fetches postings from Supabase, supports `searchByTitle()` (ilike on title) and `refreshWithFilter()`
- `filterProvider` — `NotifierProvider<FilterViewModel, FilterModel>` — holds current filter state, persists changes to SharedPreferences
- Both are overridden in `main()` via `ProviderScope` to inject dependencies

**Constants**: `lib/constants/sizes.dart` and `lib/constants/gaps.dart` provide spacing tokens used throughout the UI.

**Localization**: Korean (`ko`) is the primary locale; `flutter_localizations` is included for date pickers and Cupertino widgets.
