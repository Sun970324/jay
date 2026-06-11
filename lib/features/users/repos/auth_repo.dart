import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  static const _mobileRedirectUrl = 'jay://login-callback';
  static String get _webRedirectUrl => Uri.base.origin;

  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? _webRedirectUrl : _mobileRedirectUrl,
      authScreenLaunchMode: LaunchMode.externalApplication,
      scopes: 'email',
    );
  }

  Future<void> signInWithKakao() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.kakao,
      redirectTo: kIsWeb ? _webRedirectUrl : _mobileRedirectUrl,
      authScreenLaunchMode: LaunchMode.externalApplication,
      scopes: 'account_email',
    );
  }

  Future<void> signInWithTestAccount() async {
    await _client.auth.signInWithPassword(
      email: 'test@jay.dev',
      password: 'testjay123!',
    );
  }

  Future<void> updateProfile({String? name}) async {
    if (name == null) return;
    final userId = _client.auth.currentUser!.id;
    await _client.auth.updateUser(UserAttributes(data: {'nickname': name}));
    await _client.from('profiles').update({'nickname': name}).eq('id', userId);
  }

  Future<void> signOut() async => _client.auth.signOut();

  Future<void> deleteAccount() async {
    await _client.rpc('delete_user');
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}

final authRepo = Provider<AuthRepository>((ref) => AuthRepository());
