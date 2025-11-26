import 'dart:async'; // 1. Import dart:async untuk Timer
import 'package:flutter/material.dart';
import 'package:hmte_app/supabase_service.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class VotingPage extends StatefulWidget {
  const VotingPage({super.key});

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  static const Color kMainBlue = Color(0xFF313A6A);
  static const Color kLightBlue = Color(0xFF0172B2);

  String? _selectedCandidate;

  // 2. Variabel Timer
  Timer? _timer;
  int _start = 60; // Waktu dalam detik (1 menit)

  @override
  void initState() {
    super.initState();
    _startTimer(); // Mulai timer saat halaman dibuka
  }

  @override
  void dispose() {
    _timer?.cancel(); // Matikan timer jika halaman ditutup manual
    super.dispose();
  }

  // 3. Fungsi Logika Timer
  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
        _handleTimeout(); // Panggil fungsi ketika waktu habis
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  // Fungsi ketika waktu habis
  void _handleTimeout() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Waktu habis! Sesi voting telah berakhir.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      // Kembali ke halaman sebelumnya (sama seperti selesai voting)
      Navigator.pop(context);
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
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TAMPILAN TIMER DI POJOK KANAN ATAS (Opsional)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white54),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer, color: Colors.white, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          '$_start s', // Menampilkan detik berjalan
                          style: TextStyle(
                            color: _start <= 10
                                ? Colors.redAccent
                                : Colors.white, // Merah jika < 10 detik
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                _buildHeader(),

                const Spacer(flex: 1),
                _buildCandidateCard('Calon 1'),
                const SizedBox(height: 20),
                _buildCandidateCard('Calon 2'),
                const Spacer(flex: 3),
                _buildVoteSlider(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCandidateCard(String candidateName) {
    return GestureDetector(
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
            Icon(Icons.person_outline, size: 40, color: Colors.grey[700]),
            const SizedBox(width: 16),
            Text(
              candidateName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Radio<String>(
              value: candidateName,
              groupValue: _selectedCandidate,
              onChanged: (String? value) {
                setState(() {
                  _selectedCandidate = value;
                });
              },
              activeColor: kMainBlue,
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
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildVoteSlider(BuildContext context) {
    return ConfirmationSlider(
      text: 'SLIDE TO VOTE',
      textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      onConfirmation: () async {
        // Stop timer dulu agar tidak timeout saat loading
        _timer?.cancel();

        if (_selectedCandidate == null) {
          // Jika gagal validasi, nyalakan timer lagi (opsional, atau biarkan user diusir)
          _startTimer();

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Silakan pilih salah satu calon terlebih dahulu.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );

        try {
          final client = SupabaseService.client;
          final candidateId = _selectedCandidate == 'Calon 1' ? 1 : 2;

          await client.rpc(
            'increment_vote',
            params: {'candidate_id': candidateId},
          );

          if (mounted) {
            Navigator.pop(context); // Tutup loading
            Navigator.pop(context); // Kembali ke halaman sebelumnya (Selesai)
          }
        } catch (e) {
          if (mounted) {
            Navigator.pop(context); // Tutup loading

            // Nyalakan timer lagi jika error, supaya user punya kesempatan coba lagi (sisa waktu lanjut)
            _startTimer();

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
