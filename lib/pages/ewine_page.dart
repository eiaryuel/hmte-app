import 'package:flutter/material.dart';
import 'package:hmte_app/models/blog_post_mode.dart';
import 'package:hmte_app/pages/blog_detail_page.dart';

class EWinePage extends StatelessWidget {
  const EWinePage({super.key});

  // Warna baru Anda
  static const Color kMainBlue = Color(0xFF313A6A);
  static const Color kLightBlue = Color(0xFF0172B2);

  @override
  Widget build(BuildContext context) {
    return Container(
      // 1. Background Gradien
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
          // 2. Gunakan SingleChildScrollView agar daftar bisa di-scroll
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 3. Tombol "Back" Kustom
                _buildBackButton(context),
                const SizedBox(height: 20),

                // 4. Daftar Kartu Blog
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  // Ganti Column hardcoded dengan .map()
                  child: Column(
                    children: blogDataList.map((post) {
                      // Loop data dari model dan buat widget-nya
                      return _buildBlogCard(context, post: post);
                    }).toList(), // Ubah hasil .map() menjadi List<Widget>
                  ),
                ),
                const SizedBox(height: 20), // Padding di bawah
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  // Tombol "Back" (sama seperti halaman lain)
  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0), // Beri padding
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

  // Helper untuk membuat satu kartu blog
  Widget _buildBlogCard(BuildContext context, {required BlogPost post}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BlogDetailPage(post: post)),
        );
      },
      child: Container(
        height: 200, // Beri tinggi tetap
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20.0), // Jarak antar kartu
        // ClipRRect untuk membulatkan sudut Stack
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Stack(
            // Gunakan Stack untuk menumpuk gambar, gradien, dan teks
            fit: StackFit.expand,
            children: [
              // 1. Gambar Background
              Image.asset(post.imageUrl, fit: BoxFit.cover),

              // 2. Gradien Overlay (agar teks terbaca)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
              ),

              // 3. Teks (Judul dan Tanggal)
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.date,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
