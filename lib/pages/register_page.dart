import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  // Warna gradien yang sama dengan login screen
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
          // Gunakan SingleChildScrollView agar tidak overflow saat keyboard muncul
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Jarak dari atas
                  const SizedBox(height: 60),

                  // 1. Widget Logo Placeholder
                  _buildLogoPlaceholder(),
                  const SizedBox(height: 40),

                  // 2. Text Fields
                  _buildTextField(label: 'Nama'),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'NPM',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'No. HP',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(label: 'Password', obscureText: true),
                  const SizedBox(height: 20),
                  _buildTextField(label: 'Confirm Password', obscureText: true),
                  const SizedBox(height: 50),

                  // 3. Widget Tombol Register
                  _buildRegisterButton(context),
                  const SizedBox(height: 40),

                  // 4. Widget Teks Login
                  _buildLoginLink(context),
                  const SizedBox(height: 40), // Jarak ke bawah
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  // Ini adalah widget placeholder yang sama dari login screen
  Widget _buildLogoPlaceholder() {
    return Container(
      width: 150, // Sesuaikan lebar jika perlu
      height: 150, // Sesuaikan tinggi jika perlu
      // Anda bisa tetap menggunakan BoxDecoration untuk border atau background circle jika ingin
      // atau hilangkan jika logo sudah berbentuk lingkaran/transparan dan ingin menyesuaikan ukuran
      decoration: BoxDecoration(
        // Jika logo sudah bulat/transparan, Anda bisa hapus warna atau border di sini
        // color: Colors.white.withOpacity(0.2),
        // shape: BoxShape.circle,
        // border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipOval(
        // Opsional: Untuk memastikan gambar dipotong menjadi lingkaran
        child: Image.asset(
          'assets/images/logo.png', // <-- GANTI DENGAN PATH LENGKAP FILE LOGO ANDA
          fit: BoxFit
              .cover, // Untuk memastikan gambar mengisi ruang yang tersedia
          width: 150, // Tetapkan lebar gambar
          height: 150, // Tetapkan tinggi gambar
        ),
      ),
    );
  }

  // Helper untuk membuat Text Field agar tidak duplikat kode
  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white), // Teks input
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Tombol selebar layar
      child: ElevatedButton(
        onPressed: () {
          // Aksi saat register ditekan:
          // Untuk saat ini, kita kembali ke halaman Login
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Warna tombol
          foregroundColor: Colors.black, // Warna teks
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // Membuat sudut bulat
          ),
        ),
        child: const Text(
          'REGISTER',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.white),
        ),
        // GestureDetector agar teks "Login here" bisa diklik
        GestureDetector(
          onTap: () {
            // Aksi saat "Login here" ditekan
            // Kembali ke halaman Login (menutup halaman ini)
            Navigator.of(context).pop();
          },
          child: Text(
            'Login here',
            style: TextStyle(
              color: Colors.grey[400], // Warna abu-abu seperti di gambar
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey[400],
            ),
          ),
        ),
      ],
    );
  }
}
