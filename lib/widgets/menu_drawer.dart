import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nauta_tours/auth/login.dart';
import 'package:nauta_tours/auth/register.dart';
import 'package:nauta_tours/screens/comment_page.dart';
import 'dart:math' as math;

import 'package:nauta_tours/screens/bebidas_screen.dart';
import 'package:nauta_tours/screens/comidas_screen.dart';
import 'package:nauta_tours/screens/lugares_screen.dart';
import 'package:nauta_tours/screens/hoteles_screen.dart';

class MenuDrawer extends StatelessWidget {
  final BuildContext parentContext;

  const MenuDrawer({super.key, required this.parentContext});

  // ----------------------
  // MODAL LOGIN / REGISTER
  // ----------------------
  void _openAccountModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return LayoutBuilder(
          builder: (context, constraints) {
            double w = constraints.maxWidth;
            double modalWidth = math.min(w * 0.85, 400);

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
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
                          Navigator.pop(context);
                          Navigator.push(
                            parentContext,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const LoginPage(fromComment: true),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          padding: EdgeInsets.symmetric(
                            vertical: modalWidth * 0.06,
                          ),
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
                          Navigator.pop(context);
                          Navigator.push(
                            parentContext,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.orangeAccent),
                          padding: EdgeInsets.symmetric(
                            vertical: modalWidth * 0.06,
                          ),
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

  // ----------------------
  // FUNCIÓN COMENTAR
  // ----------------------
  void _openComments(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _openAccountModal(context);
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => CommentPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFA726), Color(0xFFD32F2F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                color: Colors.black38,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Menú Principal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          _drawerItem(Icons.place, 'Lugares Turísticos', Colors.orange, () {
            Navigator.pop(context); // cerrar drawer
            Navigator.push(
              parentContext,
              MaterialPageRoute(builder: (_) => const LugaresScreen()),
            );
          }),

          _drawerItem(Icons.restaurant, 'Comidas Típicas', Colors.green, () {
            Navigator.pop(context);
            Navigator.push(
              parentContext,
              MaterialPageRoute(builder: (_) => const ComidasScreen()),
            );
          }),

          _drawerItem(
            Icons.local_drink,
            'Bebidas Tradicionales',
            Colors.purple,
            () {
              Navigator.pop(context);
              Navigator.push(
                parentContext,
                MaterialPageRoute(builder: (_) => const BebidasScreen()),
              );
            },
          ),
          _drawerItem(Icons.location_city, 'Hoteles', Colors.deepPurple, () {
            Navigator.pop(context);
            Navigator.push(
              parentContext,
              MaterialPageRoute(builder: (_) => const HotelesScreen()),
            );
          }),

          _drawerItem(
            Icons.comment,
            'Comentarios',
            Colors.blueAccent,
            () => _openComments(parentContext),
          ), // ✅ Funcionalidad real
        ],
      ),
    );
  }

  static Widget _drawerItem(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: onTap,
    );
  }
}
