import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class VerifyEmailPendingPage extends StatefulWidget {
  const VerifyEmailPendingPage({super.key});

  @override
  State<VerifyEmailPendingPage> createState() => _VerifyEmailPendingPageState();
}

class _VerifyEmailPendingPageState extends State<VerifyEmailPendingPage> {
  bool isSending = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(seconds: 4),
      (_) => checkEmailVerified(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      timer?.cancel();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  Future<void> resendVerificationEmail() async {
    setState(() => isSending = true);

    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Correo reenviado")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.email_outlined,
                size: 80,
                color: Colors.deepOrange,
              ),
              const SizedBox(height: 20),
              const Text(
                "Verifica tu correo",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Te enviamos un enlace de verificación.\nRevisa tu bandeja.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: isSending ? null : resendVerificationEmail,
                child: isSending
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Reenviar correo"),
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                onPressed: checkEmailVerified,
                child: const Text("Ya verifiqué mi correo"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
