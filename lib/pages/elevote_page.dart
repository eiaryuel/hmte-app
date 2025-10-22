import 'package:flutter/material.dart';
import 'package:hmte_app/pages/uniqe_code_page.dart';
import 'package:pie_chart/pie_chart.dart'; // Import package

class ElevotePage extends StatelessWidget {
  const ElevotePage({super.key});

  // Warna gradien
  static const Color kMainBlue = Color(0xFF313A6A);
  static const Color kLightBlue = Color(0xFF0172B2);

  // Data untuk chart
  static Map<String, double> dataMap = {"Calon A": 70, "Calon B": 30};

  // Warna untuk chart
  static final colorList = <Color>[
    const Color(0xFFC93434), // Merah
    const Color(0xFF9E9D24), // Hijau Zaitun
  ];

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
          // SingleChildScrollView akan membuat halaman bisa di-scroll
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Tombol "Back" Kustom
                  _buildBackButton(context),
                  const SizedBox(height: 30),

                  // 2. Kartu Putih berisi Chart
                  _buildChartCard(context),
                  const SizedBox(height: 40),

                  // 3. Tombol "VOTE NOW"
                  _buildVoteButton(context),

                  // --- TAMBAHAN BARU: KARTU VISI & MISI ---
                  const SizedBox(height: 40), // Jarak sebelum kartu pertama

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

                  const SizedBox(height: 20), // Jarak di paling bawah
                  // --- AKHIR TAMBAHAN ---
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
    // ... (Fungsi ini tetap sama, tidak perlu diubah)
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

  Widget _buildChartCard(BuildContext context) {
    // ... (Fungsi ini tetap sama, tidak perlu diubah)
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
            dataMap: dataMap,
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
          const Text(
            'Calon A : 70 suara (70%)',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          const Text(
            'Calon B : 30 suara (30%)',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildVoteButton(BuildContext context) {
    // ... (Fungsi ini tetap sama, tidak perlu diubah)
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

  // --- TAMBAHAN BARU: FUNGSI UNTUK KARTU VISI & MISI ---
  Widget _buildCandidateCard({
    required String candidateName,
    required String vision,
    required String mission,
  }) {
    return Container(
      width: double.infinity,
      // Beri jarak antar kartu
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        // Rata kiri
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama Calon
          Text(
            candidateName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Visi
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
              height: 1.5, // Jarak antar baris
            ),
          ),
          const SizedBox(height: 20),

          // Misi
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
              height: 1.5, // Jarak antar baris
            ),
          ),
        ],
      ),
    );
  }

  // --- AKHIR TAMBAHAN ---
}
