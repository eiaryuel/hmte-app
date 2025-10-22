import 'package:flutter/material.dart';

class ArsipMateriPage extends StatelessWidget {
  const ArsipMateriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arsip Materi'),
        backgroundColor: const Color(0xFF1A3E7B),
      ),
      body: const Center(
        child: Text('Halaman Arsip Materi', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
