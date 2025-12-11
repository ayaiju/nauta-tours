import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nauta_tours/auth/login.dart';
import 'package:nauta_tours/auth/register.dart';
import 'clima_screen.dart';
import 'package:nauta_tours/widgets/info_nauta_widget.dart';
import 'package:nauta_tours/widgets/menu_drawer.dart';

class HomeScreen extends StatefulWidget {
  final bool isLoggedIn;

  const HomeScreen({super.key, required this.isLoggedIn});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ----------------------
  // MODAL LOGIN / REGISTER
  // ----------------------
// ----------------------
// MODAL LOGIN / REGISTER
// ----------------------
void _openAccountModal() {
  showDialog(
    context: context,
    builder: (_) {
      return LayoutBuilder(
        builder: (context, constraints) {
          double w = constraints.maxWidth;
          double modalWidth = math.min(w * 0.85, 400);

          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: modalWidth,
              padding: EdgeInsets.all(modalWidth * 0.06),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Bienvenido",
                    style: TextStyle(
                      fontSize: modalWidth * 0.12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: modalWidth * 0.06),
                  Text(
                    "Elige una opción para continuar",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: modalWidth * 0.08,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: modalWidth * 0.08),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // cerrar modal
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const LoginPage(fromComment: false)), // o true según tu lógica
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding:
                            EdgeInsets.symmetric(vertical: modalWidth * 0.06),
                      ),
                      child: Text(
                        "Iniciar Sesión",
                        style: TextStyle(fontSize: modalWidth * 0.08),
                      ),
                    ),
                  ),
                  SizedBox(height: modalWidth * 0.04),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // cerrar modal
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterPage()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orangeAccent),
                        padding:
                            EdgeInsets.symmetric(vertical: modalWidth * 0.06),
                      ),
                      child: Text(
                        "Crear Cuenta",
                        style: TextStyle(
                          fontSize: modalWidth * 0.08,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double w = constraints.maxWidth;

      return SafeArea(
        child: Scaffold(
          drawer: MenuDrawer(parentContext: context),

          // ----------------------
          // APPBAR RESPONSIVO
          // ----------------------
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: LayoutBuilder(
              builder: (context, constraints) {
                

                return AppBar(
                  elevation: 3,
                  automaticallyImplyLeading: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFA726), Color(0xFFFF5722)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/nauta_banner.jpg',
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Nauta Tours",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black38,
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    if (!widget.isLoggedIn)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: ElevatedButton(
                          onPressed: _openAccountModal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.orangeAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                          ),
                          child: const Text(
                            "Iniciar / Crear",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    else
                      IconButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        icon: const Icon(Icons.logout,
                            size: 28, color: Colors.white),
                      ),
                  ],
                );
              },
            ),
          ),

          body: Stack(
            children: [
              Positioned.fill(
                child:
                    Image.asset('assets/fondo_selva.jpg', fit: BoxFit.cover),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.04),
                        child: const ClimaScreen(),
                      ),
                    ),
                    SizedBox(height: w * 0.05),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.04),
                        child: const InfoNautaWidget(),
                      ),
                    ),
                    SizedBox(height: w * 0.05),

                    // ----------------------
                    // FOOTER / PIE DE PÁGINA
                    // ----------------------
                    Container(
                      padding: EdgeInsets.all(w * 0.04),
                      alignment: Alignment.center,
                      child: Text(
                        "© 2025 Nauta Tours. Todos los derechos reservados.",
                        style: TextStyle(
                          fontSize: math.min(w * 0.035, 16),
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
