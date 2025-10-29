import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://fwyjgakhsqahgwpngjtj.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ3eWpnYWtoc3FhaGd3cG5nanRqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE2NDMzNTgsImV4cCI6MjA3NzIxOTM1OH0.z-9HpHXdQoJaDPGiQtd8QdcsUyILHcK8TLyc2GcjBUc';

  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
