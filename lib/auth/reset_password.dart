import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailCtrl = TextEditingController();
  bool loading = false;

  Future<void> sendResetEmail() async {
    try {
      setState(() => loading = true);

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailCtrl.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Correo enviado. Revisa tu bandeja.")),
      );

      Navigator.pop(context); // volver al login
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message}")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restablecer Contraseña")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Ingresa tu correo y te enviaremos un enlace para cambiar tu contraseña.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Correo"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : sendResetEmail,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Enviar Enlace"),
            ),
          ],
        ),
      ),
    );
  }
}
