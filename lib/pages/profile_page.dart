import 'package:flutter/material.dart';
import 'package:hmte_app/pages/login_page.dart';
import 'package:hmte_app/supabase_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Warna Anda
  static const Color kMainBlue = Color(0xFF313A6A);
  static const Color kLightBlue = Color(0xFF0172B2);

  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final client = SupabaseService.client;
      final user = client.auth.currentUser;

      if (user != null) {
        // GANTI .single() menjadi .maybeSingle()
        final response = await client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle(); // <--- SOLUSI

        // Cek apakah response TIDAK null sebelum setState
        // response sekarang adalah Map<String, dynamic>?
        if (response != null) {
          setState(() {
            _profileData = response;
          });
        }
        // Jika response null, _profileData akan tetap null
        // dan UI Anda sudah aman menampilkannya sebagai 'Loading...'
      }
    } catch (e) {
      // Menangkap error jika ada masalah lain (koneksi, RLS, dll)
      debugPrint('Error fetching profile: $e');
      // Anda bisa setState ke state error jika mau
    }
  }

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
                    _buildInfoRow(
                      icon: Icons.person,
                      text: _profileData?['name'] ?? 'Loading...',
                    ),
                    _buildInfoRow(
                      icon: Icons.school,
                      text: _profileData?['npm'] ?? 'Loading...',
                    ),
                    _buildInfoRow(
                      icon: Icons.email,
                      text:
                          SupabaseService.client.auth.currentUser?.email ??
                          'Loading...',
                    ),
                    const SizedBox(height: 50),
                    _buildLogoutButton(context),
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

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await SupabaseService.client.auth.signOut();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text(
          'LOGOUT',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
