import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final supabase = Supabase.instance.client;

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signup({
    required String email,
    required String password,
  }) async {
    await supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  static Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
