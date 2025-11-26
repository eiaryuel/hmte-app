import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hmte_app/supabase_service.dart';
import 'voting_page.dart';

class UniqueCodePage extends StatefulWidget {
  const UniqueCodePage({super.key});

  @override
  State<UniqueCodePage> createState() => _UniqueCodePageState();
}

class _UniqueCodePageState extends State<UniqueCodePage> {
  static const Color kMainBlue = Color(0xFF313A6A);
  static const Color kLightBlue = Color(0xFF0172B2);

  final _otpController = TextEditingController();

  // SETUP DURASI: Berapa menit OTP berlaku
  final int _otpValidityMinutes = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateAndSaveOtp();
    });
  }

  Future<void> _generateAndSaveOtp() async {
    final client = SupabaseService.client;
    final user = client.auth.currentUser;

    if (user != null) {
      try {
        // Tampilkan loading jika perlu
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mengirim kode OTP ke email...')),
          );
        }

        // Panggil Edge Function 'send-otp'
        // Pastikan Anda sudah deploy function dengan nama 'send-otp'
        await client.functions.invoke('send-otp');

        print('OTP generated and email sent via Server');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kode OTP telah dikirim ke email Anda!'),
            ),
          );
        }
      } catch (e) {
        print('Error sending OTP: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mengirim email: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildBackButton(context),
                  const SizedBox(height: 100),
                  _buildCodeField(),
                  const SizedBox(height: 20),
                  // Tambahan info text agar user tau ada batas waktu
                  Text(
                    "Kode berlaku selama $_otpValidityMinutes menit",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 40),
                  _buildConfirmButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
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

  Widget _buildCodeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: _otpController,
        textAlign: TextAlign.left,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        keyboardType: TextInputType.number, // Tambahkan ini agar keyboard angka
        decoration: const InputDecoration(
          labelText: 'Enter Unique Code',
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            final client = SupabaseService.client;
            final user = client.auth.currentUser;
            final enteredOtp = _otpController.text.trim();

            if (user == null) return;
            if (enteredOtp.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter the code')),
              );
              return;
            }

            try {
              // LOGIKA UTAMA EXPIRATION
              // Hitung batas waktu: Waktu sekarang dikurangi 5 menit
              final DateTime validTimeLimit = DateTime.now().toUtc().subtract(
                Duration(minutes: _otpValidityMinutes),
              );

              // Query mencari OTP yang:
              // 1. Punya user ini
              // 2. Kodenya sama
              // 3. Dibuat SETELAH (Greater Than / gt) batas waktu limit
              final response = await client
                  .from('otps')
                  .select()
                  .eq('user_id', user.id)
                  .eq('otp', enteredOtp)
                  .gt(
                    'created_at',
                    validTimeLimit.toIso8601String(),
                  ) // Filter Waktu
                  .maybeSingle(); // Gunakan maybeSingle agar return null jika tidak ketemu/expired

              if (response != null) {
                // Jika ketemu datanya, berarti OTP Benar & Masih Berlaku

                // Opsional: Hapus OTP setelah dipakai agar tidak bisa dipakai 2x
                await client.from('otps').delete().eq('id', response['id']);

                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const VotingPage()),
                  );
                }
              } else {
                // Jika null, bisa jadi salah kode ATAU sudah expired
                throw Exception("Expired or Invalid");
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kode salah atau sudah kadaluarsa!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: const Text(
            'CONFIRM',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
