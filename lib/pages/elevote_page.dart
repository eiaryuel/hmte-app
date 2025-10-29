import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hmte_app/pages/uniqe_code_page.dart';
import 'package:hmte_app/supabase_service.dart';
import 'package:pie_chart/pie_chart.dart';

class ElevotePage extends StatefulWidget {
  const ElevotePage({super.key});

  @override
  State<ElevotePage> createState() => _ElevotePageState();
}

class _ElevotePageState extends State<ElevotePage> {
  static const Color kMainBlue = Color(0xFF313A6A);
  static const Color kLightBlue = Color(0xFF0172B2);

  Map<String, double> dataMap = {};
  bool _isLoading = true;

  static final colorList = <Color>[
    const Color(0xFFC93434), // Merah
    const Color(0xFF9E9D24), // Hijau Zaitun
    // Anda bisa tambah warna lagi jika kandidat > 2
  ];

  late final StreamSubscription _candidatesSubscription;

  @override
  void initState() {
    super.initState();
    _listenToVotes();
  }

  @override
  void dispose() {
    _candidatesSubscription.cancel();
    super.dispose();
  }

  void _listenToVotes() {
    _candidatesSubscription = SupabaseService.client
        .from('candidates')
        .stream(primaryKey: ['id'])
        .listen(
          (event) {
            setState(() {
              print('DATA DARI STREAM: $event');

              dataMap = {
                for (var item in event)
                  (item['nama'] as String? ?? 'Data Kosong'):
                      (item['votes'] as int? ?? 0).toDouble(),
              };
              _isLoading = false; // <-- Data sudah diterima, loading selesai
            });
          },
          onError: (e) {
            // Handle jika ada error stream
            setState(() {
              _isLoading = false;
            });
            print('Error listening to votes: $e');
          },
        );
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildBackButton(context),
                  const SizedBox(height: 30),

                  // 2. Kartu Putih berisi Chart
                  _buildChartCard(context), // <-- WIDGET INI DIUBAH
                  const SizedBox(height: 40),

                  // 3. Tombol "VOTE NOW"
                  _buildVoteButton(context),
                  const SizedBox(height: 40),

                  // --- KARTU VISI & MISI (TETAP HARD-CODE) ---
                  _buildCandidateCard(
                    candidateName: 'Calon A',
                    vision:
                        'Mewujudkan Himpunan Teknik Elektro yang solid, progresif, dan bermanfaat bagi seluruh anggotanya.',
                    mission:
                        '1. Meningkatkan kualitas akademik dan non-akademik anggota.\n'
                        '2. Mempererat tali persaudaraan antar anggota.\n'
                        '3. Menjalin hubungan baik dengan alumni dan industri.',
                  ),

                  _buildCandidateCard(
                    candidateName: 'Calon B',
                    vision:
                        'Menjadikan Himpunan sebagai wadah aspirasi dan pengembangan diri yang inovatif dan berdaya saing.',
                    mission:
                        '1. Menciptakan program kerja yang kreatif dan solutif.\n'
                        '2. Mengoptimalkan potensi anggota di bidang teknologi.\n'
                        '3. Membangun citra positif himpunan di tingkat universitas.',
                  ),

                  // --- AKHIR BAGIAN HARD-CODE ---
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildBackButton(BuildContext context) {
    // ... (Tidak ada perubahan)
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

  // --- PERUBAHAN UTAMA DI FUNGSI INI ---
  Widget _buildChartCard(BuildContext context) {
    // Tampilkan loading jika dataMap masih kosong ATAU state isLoading true
    if (_isLoading) {
      return Container(
        height: 200, // Beri tinggi agar loading terlihat
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    // Hitung total votes dengan aman
    final totalVotes = dataMap.isEmpty
        ? 0.0
        : dataMap.values.reduce((a, b) => a + b);

    // Ambil data vote dengan aman (null-safe)
    // ⬇️ PENTING: Ganti "Calon 1" dan "Calon 2" agar sesuai
    //    dengan string 'name' di tabel Supabase Anda.
    final votesCalon1 = dataMap['Calon 1'] ?? 0.0;
    final votesCalon2 = dataMap['Calon 2'] ?? 0.0;

    // Hitung persentase dengan aman
    final percentCalon1 = totalVotes == 0.0
        ? 0.0
        : (votesCalon1 / totalVotes * 100);
    final percentCalon2 = totalVotes == 0.0
        ? 0.0
        : (votesCalon2 / totalVotes * 100);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          const Text(
            'Perhitungan Pemilihan Ketua Himpunan',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 30),
          PieChart(
            // Tampilan chart tetap sama
            // Handle jika 0 vote agar chart tidak error
            dataMap: dataMap.isEmpty || totalVotes == 0.0
                ? {"Belum ada vote": 1.0}
                : dataMap,
            animationDuration: const Duration(milliseconds: 800),
            chartRadius: MediaQuery.of(context).size.width / 2.2,
            colorList: colorList,
            initialAngleInDegree: -90,
            chartType: ChartType.ring,
            ringStrokeWidth: 32,
            centerText: "",
            legendOptions: const LegendOptions(showLegends: false),
            chartValuesOptions: const ChartValuesOptions(
              showChartValues: false,
            ),
          ),
          const SizedBox(height: 30),

          // --- PERUBAHAN DI SINI ---
          // Tampilan UI tetap "Calon A", tapi data ambil dari "Calon 1"
          Text(
            'Calon A : ${votesCalon1.toInt()} suara (${percentCalon1.toStringAsFixed(1)}%)',
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          // Tampilan UI tetap "Calon B", tapi data ambil dari "Calon 2"
          Text(
            'Calon B : ${votesCalon2.toInt()} suara (${percentCalon2.toStringAsFixed(1)}%)',
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          // --- AKHIR PERUBAHAN ---
        ],
      ),
    );
  }
  // --- AKHIR PERUBAHAN UTAMA ---

  Widget _buildVoteButton(BuildContext context) {
    // ... (Tidak ada perubahan)
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UniqueCodePage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text(
          'VOTE NOW',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // --- KARTU INI TETAP HARD-CODE (TIDAK BERUBAH) ---
  Widget _buildCandidateCard({
    required String candidateName,
    required String vision,
    required String mission,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            candidateName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Visi:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            vision,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Misi:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mission,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
