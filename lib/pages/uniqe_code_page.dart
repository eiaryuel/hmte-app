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

  @override
  void initState() {
    super.initState();
    _generateAndSaveOtp();
  }

  Future<void> _generateAndSaveOtp() async {
    final client = SupabaseService.client;
    final user = client.auth.currentUser;

    if (user != null) {
      final otp = (100000 + Random().nextInt(900000)).toString();
      await client.from('otps').insert({'user_id': user.id, 'otp': otp});
      print('Your OTP is: $otp');
    }
  }

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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildBackButton(context),
                  const SizedBox(height: 100),
                  _buildCodeField(),
                  const SizedBox(height: 60),
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

            try {
              final response = await client
                  .from('otps')
                  .select()
                  .eq('user_id', user.id)
                  .eq('otp', enteredOtp)
                  .order('created_at', ascending: false)
                  .limit(1)
                  .single();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const VotingPage()),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invalid or expired OTP'),
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
