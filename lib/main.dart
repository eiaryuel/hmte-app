import 'package:flutter/material.dart';
import 'package:hmte_app/pages/homepage.dart';
import 'package:hmte_app/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fwyjgakhsqahgwpngjtj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ3eWpnYWtoc3FhaGd3cG5nanRqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE2NDMzNTgsImV4cCI6MjA3NzIxOTM1OH0.z-9HpHXdQoJaDPGiQtd8QdcsUyILHcK8TLyc2GcjBUc',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HMTE APP',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
