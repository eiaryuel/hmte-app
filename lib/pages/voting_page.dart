import 'package:flutter/material.dart';
import 'package:hmte_app/supabase_service.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart'; // Import package

class VotingPage extends StatefulWidget {
  const VotingPage({super.key});

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  // Warna baru Anda
  static const Color kMainBlue = Color(0xFF313A6A);
  static const Color kLightBlue = Color(0xFF0172B2);

  // Variabel untuk menyimpan calon yang dipilih
  String? _selectedCandidate;

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
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                _buildHeader(),

                const Spacer(flex: 1),
                // Kartu Calon 1
                _buildCandidateCard('Calon 1'),
                const SizedBox(height: 20),
                // Kartu Calon 2
                _buildCandidateCard('Calon 2'),
                const Spacer(flex: 3),
                // Slider
                _buildVoteSlider(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget untuk membuat kartu calon
  Widget _buildCandidateCard(String candidateName) {
    return GestureDetector(
      // Membuat seluruh kartu bisa diklik untuk memilih
      onTap: () {
        setState(() {
          _selectedCandidate = candidateName;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: [
            // Placeholder Foto Calon
            Icon(Icons.person_outline, size: 40, color: Colors.grey[700]),
            const SizedBox(width: 16),
            // Nama Calon
            Text(
              candidateName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            // Radio Button (pengganti Checkbox)
            Radio<String>(
              value: candidateName,
              groupValue: _selectedCandidate,
              onChanged: (String? value) {
                setState(() {
                  _selectedCandidate = value;
                });
              },
              activeColor: kMainBlue, // Warna saat dipilih
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'ELEVOTE 2025',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 32, // Ukuran font besar untuk header
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2, // Sedikit jarak antar huruf
      ),
    );
  }

  // Helper widget untuk "Slide to Vote"
  Widget _buildVoteSlider(BuildContext context) {
    return ConfirmationSlider(
      text: 'SLIDE TO VOTE',
      textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      onConfirmation: () async {
        // 1. Cek apakah calon sudah dipilih
        if (_selectedCandidate == null) {
          // Tampilkan pesan jika belum memilih
          if (!mounted) return; // Selalu cek 'mounted'
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Silakan pilih salah satu calon terlebih dahulu.'),
              backgroundColor: Colors.red,
            ),
          );
          return; // Hentikan fungsi
        }

        // Tampilkan loading spinner
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );

        try {
          final client = SupabaseService.client;

          // 2. Tentukan ID berdasarkan pilihan (Masih hard-code, lihat poin 3)
          final candidateId = _selectedCandidate == 'Calon 1' ? 1 : 2;

          // 3. Panggil fungsi RPC 'increment_vote' (Jauh lebih baik!)
          await client.rpc(
            'increment_vote',
            params: {'candidate_id': candidateId},
          );

          // 4. Tutup loading dan kembali
          if (mounted) {
            Navigator.pop(context); // Tutup loading
            Navigator.pop(context); // Kembali ke halaman Elevote
          }
        } catch (e) {
          // Jika ada error (misal RLS, offline, dll)
          if (mounted) {
            Navigator.pop(context); // Tutup loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Vote Gagal: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      backgroundColor: Colors.white,
      foregroundColor: kMainBlue,
      iconColor: Colors.white,
      height: 60,
    );
  }
}
