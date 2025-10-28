import 'package:flutter/material.dart';
import 'package:hmte_app/pages/homepage.dart';
import 'package:hmte_app/pages/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Warna gradien dari gambar
  static const Color kMainBlue = Color(0xFF313A6A);
  static const Color kLightBlue = Color(0xFF0172B2);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Kita gunakan 'Container' sebagai root untuk background gradien
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kLightBlue, kMainBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        // Buat background Scaffold transparan agar gradien terlihat
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
                  const SizedBox(height: 100),

                  // 1. Widget Logo Placeholder
                  _buildLogoPlaceholder(),
                  const SizedBox(height: 60),

                  // 2. Widget Text Field Email
                  _buildEmailField(_emailController),
                  const SizedBox(height: 20),

                  // 3. Widget Text Field Password
                  _buildPasswordField(_passwordController),
                  const SizedBox(height: 70),

                  // 4. Widget Tombol Login
                  _buildLoginButton(context),
                  const SizedBox(height: 100), // Beri jarak
                  // 5. Widget Teks Register
                  _buildRegisterText(context),
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

  Widget _buildEmailField(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white), // Teks input
      decoration: const InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.white70),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true, // Menyembunyikan teks password
      style: const TextStyle(color: Colors.white), // Teks input
      decoration: const InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.white70),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Tombol selebar layar
      child: ElevatedButton(
        onPressed: () async {
          final supabase = Supabase.instance.client;
          final email = _emailController.text;
          final password = _passwordController.text;

          try {
            final response = await supabase.auth.signInWithPassword(
              email: email,
              password: password,
            );

            if (response.user != null) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (Route<dynamic> route) => false,
              );
            }
          } on AuthException catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.message)));
          }
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
          'LOGIN',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildRegisterText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.white),
        ),
        // GestureDetector agar teks "Register here" bisa diklik
        GestureDetector(
          onTap: () {
            // Aksi saat "Register here" ditekan
            // (Contoh: Pindah ke halaman register)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterScreen()),
            );
          },
          child: Text(
            'Register here',
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
