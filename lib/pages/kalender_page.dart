import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // Import package

class KalenderPage extends StatefulWidget {
  const KalenderPage({super.key});

  @override
  State<KalenderPage> createState() => _KalenderPageState();
}

class _KalenderPageState extends State<KalenderPage> {
  // Warna baru Anda
  static const Color kMainBlue = Color(0xFF313A6A);
  static const Color kLightBlue = Color(0xFF0172B2);

  // State untuk melacak kalender
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // 1. Background Gradien
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
            children: [
              // 2. Tombol "Back" Kustom
              _buildBackButton(context),

              // 3. Widget Kalender
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildCalendar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  // Tombol "Back" (sama seperti halaman lain)
  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0), // Beri padding agar tidak mepet
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

  // Widget Kalender yang sudah di-style
  Widget _buildCalendar() {
    return TableCalendar(
      // --- DATA ---
      firstDay: DateTime.utc(2010, 1, 1),
      lastDay: DateTime.utc(2040, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,

      // --- KONTROL STATE ---
      selectedDayPredicate: (day) {
        // Menandai hari yang dipilih
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay; // Pindahkan fokus ke hari yang dipilih
        });
      },
      onPageChanged: (focusedDay) {
        // Saat pengguna ganti bulan
        _focusedDay = focusedDay;
      },

      // --- STYLING (BAGIAN PENTING) ---

      // 1. Style Header (Desember 2025)
      headerStyle: HeaderStyle(
        formatButtonVisible: false, // Sembunyikan tombol 'Month'
        titleCentered: true,
        // Style teks "Desember 2025"
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        // Latar belakang biru tua rounded
        decoration: BoxDecoration(
          color: kMainBlue.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        headerPadding: const EdgeInsets.symmetric(vertical: 10),
        // Style tombol panah < >
        leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
        rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
      ),

      // 2. Style Nama Hari (Sun, Mon, Tue)
      daysOfWeekStyle: const DaysOfWeekStyle(
        // Style hari kerja (Mon-Sat)
        weekdayStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        // Style hari Minggu (Sun) - warna merah
        weekendStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),

      // 3. Style Angka Kalender (1, 2, 3...)
      calendarStyle: CalendarStyle(
        // Style angka hari ini (default)
        defaultTextStyle: const TextStyle(color: Colors.white),
        // Style angka hari libur (Sabtu, Minggu)
        weekendTextStyle: const TextStyle(color: Colors.white),
        // Style angka "ghost" (hari di luar bulan ini)
        outsideTextStyle: TextStyle(color: Colors.white.withOpacity(0.4)),

        // Hapus marker 'today' (lingkaran default)
        todayDecoration: const BoxDecoration(color: Colors.transparent),
        // Style saat hari dipilih
        selectedDecoration: BoxDecoration(
          color: kLightBlue, // Warna biru cerah saat dipilih
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
