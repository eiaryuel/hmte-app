import 'package:flutter/material.dart';
import 'package:hmte_app/pages/arsip_materi_page.dart';
import 'package:hmte_app/pages/elevote_page.dart';
import 'package:hmte_app/pages/ewine_page.dart';
import 'package:hmte_app/pages/kalender_page.dart';
import 'package:hmte_app/pages/login_page.dart';
import 'package:hmte_app/models/blog_post_mode.dart';
import 'package:hmte_app/pages/profile_page.dart';
import 'package:hmte_app/pages/blog_detail_page.dart';
import 'package:hmte_app/supabase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Warna utama background
  static const Color kMainBlue = Color(0xFF313A6A);
  static const Color kLightBlue = Color(0xFF0172B2);

  String? _userName;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final client = SupabaseService.client;
      final user = client.auth.currentUser;

      if (user != null) {
        // GANTI .single() menjadi .maybeSingle()
        final response = await client
            .from('profiles')
            .select('name')
            .eq('id', user.id)
            .maybeSingle(); // <--- SOLUSI

        // Cek apakah response TIDAK null sebelum mengambil data
        if (response != null && response.isNotEmpty) {
          setState(() {
            _userName = response['name'] as String?;
          });
        } else {
          // Handle jika user login tapi tidak punya profile
          // Anda bisa set default name di sini
          setState(() {
            _userName = 'Guest'; // Atau 'Nama Default', dll.
          });
        }
      }
    } catch (e) {
      // Handle jika ada error lain (cth: network, RLS, dll)
      debugPrint('Error fetching user name: $e');
      setState(() {
        _userName = 'Error'; // Tampilkan error di UI jika perlu
      });
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
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Konten utama yang bisa di-scroll
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Header
                      _buildHeader(context),
                      const SizedBox(height: 30),

                      // 2. Grid Menu
                      _buildGridMenu(context),
                      const SizedBox(height: 30),

                      // 3. Image Carousel
                      _buildImageCarousel(),

                      // Memberi jarak agar tidak tertutup bottom nav
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),

              // 4. Bottom Navigation Bar (Mengambang)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: _buildBottomNav(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk Header
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hello,\n${_userName ?? 'Guest'}!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_userName != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Grid Menu
  Widget _buildGridMenu(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildGridItem(Icons.how_to_vote, 'Elevote', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ElevotePage()),
          );
        }),
        _buildGridItem(Icons.calendar_today, 'Kalender', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KalenderPage()),
          );
        }),
        _buildGridItem(Icons.newspaper, 'EWine', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EWinePage()),
          );
        }),
        _buildGridItem(Icons.folder_copy_outlined, 'Arsip Materi', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ArsipMateriPage()),
          );
        }),
      ],
    );
  }

  // Helper widget untuk setiap item di grid
  Widget _buildGridItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, size: 35, color: kMainBlue),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Widget untuk Image Carousel
  Widget _buildImageCarousel() {
    return SizedBox(
      height: 200,
      // Gunakan ListView.builder untuk membuat list dari data model
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // Ambil jumlah item dari list data kita
        itemCount: blogDataList.length,
        itemBuilder: (context, index) {
          // Ambil data postingan blog satu per satu
          final post = blogDataList[index];

          // Panggil _buildImageCard dengan data yang benar
          return _buildImageCard(
            context: context,
            post: post, // Gunakan title sebagai label
          );
        },
      ),
    );
  }

  // Helper widget untuk setiap item di carousel
  Widget _buildImageCard({
    required BuildContext context,
    required BlogPost post,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BlogDetailPage(post: post)),
        );
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(post.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        // Overlay gradient agar teks terbaca
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  post.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk Bottom Navigation Bar
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KalenderPage()),
              );
            },
            child: Icon(
              Icons.calendar_today_outlined,
              color: Colors.grey[600],
              size: 30,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.home, color: kMainBlue, size: 30),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            child: Icon(
              Icons.person_outline,
              color: Colors.grey[600],
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
