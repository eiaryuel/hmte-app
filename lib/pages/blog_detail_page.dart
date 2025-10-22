// lib/blog_detail_page.dart (FILE BARU)

import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart'; // Import package placeholder
import 'package:hmte_app/models/blog_post_mode.dart'; // Import model data Anda

class BlogDetailPage extends StatelessWidget {
  // 1. Halaman ini menerima satu objek BlogPost
  final BlogPost post;

  const BlogDetailPage({super.key, required this.post});

  // Warna Anda
  static const Color kMainBlue = Color(0xFF313A6A);
  static const Color kLightBlue = Color(0xFF0172B2);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Latar belakang gradien
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kLightBlue, kMainBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          // Gunakan SingleChildScrollView agar konten bisa di-scroll
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Tombol Back
                _buildBackButton(context),

                // 3. Hero Image (Gambar Utama Blog)
                _buildHeroImage(post.imageUrl),

                // 4. Konten (Judul, Tanggal, Isi)
                _buildBlogContent(post.title, post.date),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper untuk tombol Back
  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.white, size: 28),
                SizedBox(width: 8),
                Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk Hero Image
  Widget _buildHeroImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      // ClipRRect untuk membulatkan sudut gambar
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          // Gunakan Image.asset
          imageUrl, // Ambil gambar dari model
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Helper untuk Judul dan Isi
  Widget _buildBlogContent(String title, String date) {
    // Teks placeholder Lorem Ipsum
    final String loremIpsum = lorem(paragraphs: 3, words: 150);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Tanggal
          Text(
            date,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 25),

          // Isi (Lorem Ipsum)
          Text(
            loremIpsum,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.6, // Jarak antar baris
            ),
          ),
        ],
      ),
    );
  }
}
