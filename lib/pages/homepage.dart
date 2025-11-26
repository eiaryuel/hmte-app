import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // 1. IMPORT TAMBAHAN
import 'package:hmte_app/pages/elevote_page.dart';
import 'package:hmte_app/pages/ewine_page.dart';
import 'package:hmte_app/pages/kalender_page.dart';
import 'package:hmte_app/pages/login_page.dart';
import 'package:hmte_app/models/blog_post_mode.dart';
import 'package:hmte_app/pages/profile_page.dart';
import 'package:hmte_app/pages/blog_detail_page.dart';
import 'package:hmte_app/supabase_service.dart';
// Note: import 'package:hmte_app/pages/arsip_materi_page.dart'; bisa dihapus jika tidak dipakai lagi

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color kMainBlue = Color(0xFF313A6A);
  static const Color kLightBlue = Color(0xFF0172B2);

  String? _userName;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  // 2. FUNGSI UNTUK MEMBUKA LINK DRIVE
  Future<void> _launchArsipUrl() async {
    const urlString =
        'https://drive.google.com/drive/folders/1-WCMxk5vt3ageLOkwv1HyP5Ha_4N5Z_o?usp=drive_link';
    final Uri url = Uri.parse(urlString);

    try {
      if (!await launchUrl(
        url,
        mode: LaunchMode.inAppBrowserView, // Mode In-App Browser
      )) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal membuka link: $e')));
      }
    }
  }

  Future<void> _fetchUserName() async {
    try {
      final client = SupabaseService.client;
      final user = client.auth.currentUser;
      if (user != null) {
        final response = await client
            .from('profiles')
            .select('name')
            .eq('id', user.id)
            .maybeSingle();
        if (response != null && response.isNotEmpty) {
          setState(() {
            _userName = response['name'] as String?;
          });
        } else {
          setState(() {
            _userName = 'Guest';
          });
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 30),

                  _buildGridMenu(context),
                  const SizedBox(height: 30),

                  const Text(
                    "E-Wine Terbaru",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  _buildBlogList(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _userName != null
                      ? const ProfilePage()
                      : const LoginScreen(),
                ),
              );
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

  Widget _buildGridMenu(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildGridItem(
          Icons.how_to_vote,
          'Elevote',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ElevotePage()),
          ),
        ),
        _buildGridItem(
          Icons.calendar_today,
          'Kalender',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KalenderPage()),
          ),
        ),
        _buildGridItem(
          Icons.newspaper,
          'EWine',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EWinePage()),
          ),
        ),
        // 3. GANTI AKSI TOMBOL ARSIP MATERI
        _buildGridItem(Icons.folder_copy_outlined, 'Arsip Materi', () {
          // Memanggil fungsi launch URL, bukan Navigator.push
          _launchArsipUrl();
        }),
      ],
    );
  }

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

  Widget _buildBlogList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: blogDataList.length > 2 ? 2 : blogDataList.length,
      itemBuilder: (context, index) {
        final post = blogDataList[index];
        return _buildBlogCard(context: context, post: post);
      },
    );
  }

  Widget _buildBlogCard({
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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                post.imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  height: 140,
                  color: Colors.grey,
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kMainBlue,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        post.date,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.person, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          post.author,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
