import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jay/features/users/repos/auth_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends AsyncNotifier<User?> {
  StreamSubscription<AuthState>? _subscription;

  @override
  Future<User?> build() async {
    final repo = ref.read(authRepo);
    _subscription?.cancel();
    _subscription = repo.authStateChanges.listen((event) {
      state = AsyncData(event.session?.user);
    });
    ref.onDispose(() => _subscription?.cancel());
    return repo.currentUser;
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    final repo = ref.read(authRepo);
    try {
      await repo.signInWithGoogle();
    } catch (e, st) {
      state = AsyncError(e, st);
      return;
    }
    state = AsyncData(repo.currentUser);
  }

  Future<void> signInWithKakao() async {
    state = const AsyncLoading();
    final repo = ref.read(authRepo);
    try {
      await repo.signInWithKakao();
    } catch (e, st) {
      state = AsyncError(e, st);
      return;
    }
    state = AsyncData(repo.currentUser);
  }

  Future<void> updateProfile({String? name}) async {
    await ref.read(authRepo).updateProfile(name: name);
  }

  Future<void> signOut() async {
    await ref.read(authRepo).signOut();
  }
}

final authProvider = AsyncNotifierProvider<AuthViewModel, User?>(
  () => AuthViewModel(),
);
