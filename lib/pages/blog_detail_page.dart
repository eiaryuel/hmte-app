// lib/pages/blog_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:hmte_app/models/blog_post_mode.dart';

class BlogDetailPage extends StatelessWidget {
  final BlogPost post;

  const BlogDetailPage({super.key, required this.post});

  static const Color kMainBlue = Color(0xFF313A6A);
  static const Color kLightBlue = Color(0xFF0172B2);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Tombol Back
                _buildBackButton(context),

                // 2. Hero Image
                _buildHeroImage(post.imageUrl),

                // 3. Konten (Judul, Tanggal, Author, Isi)
                // Kita tambahkan parameter post.author di sini
                _buildBlogContent(post.title, post.date, post.author),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  Widget _buildHeroImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          imageUrl,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 220,
            color: Colors.grey,
            child: const Center(child: Icon(Icons.broken_image)),
          ),
        ),
      ),
    );
  }

  // UPDATE: Menambahkan parameter author
  Widget _buildBlogContent(String title, String date, String author) {
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
          const SizedBox(height: 12), // Sedikit jarak sebelum metadata
          // Metadata Row (Tanggal & Author)
          Row(
            children: [
              // Tanggal
              Icon(
                Icons.calendar_today,
                color: Colors.white.withOpacity(0.7),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                date,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),

              const SizedBox(width: 20), // Jarak pemisah
              // Author
              Icon(
                Icons.person,
                color: Colors.white.withOpacity(0.7),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                author,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight
                      .bold, // Bold agar author lebih menonjol sedikit
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // Divider (Garis pemisah opsional agar lebih rapi)
          Divider(color: Colors.white.withOpacity(0.3)),

          const SizedBox(height: 15),

          // Isi (Lorem Ipsum)
          Text(
            loremIpsum,
            textAlign: TextAlign.justify, // Rata kanan-kiri agar rapi
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.6,
            ),
          ),

          // Jarak bawah agar scroll tidak mentok
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
