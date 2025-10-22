import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Warna Anda
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Tombol Back
              _buildBackButton(context),
              const SizedBox(height: 30),

              // 2. Konten Halaman Profile
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // Avatar Placeholder
                    _buildAvatar(),
                    const SizedBox(height: 50),

                    // Info Placeholder
                    _buildInfoRow(icon: Icons.person, text: 'John Doe'),
                    _buildInfoRow(icon: Icons.school, text: '1234567890'),
                    _buildInfoRow(
                      icon: Icons.email,
                      text: 'john.doe@email.com',
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

  // Helper untuk Avatar Placeholder
  Widget _buildAvatar() {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Icon(Icons.person, color: Colors.grey[600], size: 100),
      ),
    );
  }

  // Helper untuk baris info (Ikon + Teks)
  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        children: [
          // Ikon
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(width: 20),
          // Teks Info
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }
}
