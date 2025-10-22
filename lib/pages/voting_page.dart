import 'package:flutter/material.dart';
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
      onConfirmation: () {
        // Aksi setelah slide berhasil
        if (_selectedCandidate != null) {
          print("Berhasil vote untuk: $_selectedCandidate");
          // Kembali ke halaman Elevote (hasil)
          Navigator.pop(context);
        } else {
          // Tampilkan pesan jika belum memilih
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Silakan pilih salah satu calon terlebih dahulu.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      backgroundColor: Colors.white,
      foregroundColor: kMainBlue,
      iconColor: Colors.white,
      height: 60,
    );
  }
}
