import 'package:flutter/material.dart';
import 'voting_page.dart'; // Import halaman voting

class UniqueCodePage extends StatelessWidget {
  const UniqueCodePage({super.key});

  // --- PERUBAHAN WARNA ---
  static const Color kMainBlue = Color(0xFF313A6A);
  static const Color kLightBlue = Color(0xFF0172B2);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kLightBlue, kMainBlue], // Menggunakan warna baru
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildBackButton(context),
                  const SizedBox(height: 100),
                  _buildCodeField(),
                  const SizedBox(height: 60),
                  _buildConfirmButton(
                    context,
                  ), // Perubahan ada di dalam fungsi ini
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    // ... (Fungsi ini tidak berubah)
    return Row(
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
    );
  }

  Widget _buildCodeField() {
    // ... (Fungsi ini tidak berubah)
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          labelText: 'Enter Unique Code',
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // --- MODIFIKASI FUNGSI INI ---
  Widget _buildConfirmButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Aksi saat "CONFIRM" ditekan
            print("Kode dikonfirmasi! Pindah ke Halaman Voting.");

            // --- GANTI NAVIGASI ---
            // Kita gunakan pushReplacement agar pengguna tidak bisa "kembali"
            // ke halaman unique code dari halaman voting.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const VotingPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: const Text(
            'CONFIRM',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
