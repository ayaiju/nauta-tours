import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// ===============================
///  HOTELS SCREEN
/// ===============================
class HotelesScreen extends StatelessWidget {
  const HotelesScreen({super.key});

  /// 🔥 Obtener hoteles activos desde Supabase
  Future<List<Map<String, dynamic>>> _fetchHoteles() async {
    final response = await Supabase.instance.client
        .from('hoteles')
        .select()
        .eq('activo', true)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// 📞 Llamar por teléfono
  Future<void> _callPhone(String number) async {
    if (number.isEmpty) return;

    final clean = number.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('tel:$clean');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// 🗺️ Abrir mapa (OpenStreetMap / Google Maps)
  Future<void> _openMaps(String url) async {
    if (url.isEmpty) return;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// 💬 Abrir WhatsApp (API gratuita)
  Future<void> _openWhatsApp(String number) async {
    if (number.isEmpty) return;

    final clean = number.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$clean');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoteles'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchHoteles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar hoteles'));
          }

          final hoteles = snapshot.data ?? [];

          if (hoteles.isEmpty) {
            return const Center(child: Text('No hay hoteles disponibles'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: hoteles.length,
            itemBuilder: (context, index) {
              final h = hoteles[index];

              return HotelCard(
                nombre: h['nombre'] ?? '',
                direccion: h['direccion'] ?? '',
                ciudad: h['ciudad'] ?? '',
                celular: h['celular'] ?? '',
                imagenUrl: h['imagen_url'] ?? '',
                mapsUrl: h['maps_url'] ?? '',
                onCall: _callPhone,
                onMaps: _openMaps,
                onWhatsApp: _openWhatsApp,
              );
            },
          );
        },
      ),
    );
  }
}

/// ===============================
///  HOTEL CARD
/// ===============================
class HotelCard extends StatelessWidget {
  final String nombre;
  final String direccion;
  final String ciudad;
  final String celular;
  final String imagenUrl;
  final String mapsUrl;
  final Future<void> Function(String) onCall;
  final Future<void> Function(String) onMaps;
  final Future<void> Function(String) onWhatsApp;

  const HotelCard({
    super.key,
    required this.nombre,
    required this.direccion,
    required this.ciudad,
    required this.celular,
    required this.imagenUrl,
    required this.mapsUrl,
    required this.onCall,
    required this.onMaps,
    required this.onWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _image(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  [direccion, ciudad].where((e) => e.isNotEmpty).join(' • '),
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Llamar',
                      icon: const Icon(Icons.phone, color: Colors.green),
                      onPressed: celular.isEmpty ? null : () => onCall(celular),
                    ),
                    IconButton(
                      tooltip: 'Mapa',
                      icon: const Icon(Icons.map, color: Colors.deepPurple),
                      onPressed: mapsUrl.isEmpty ? null : () => onMaps(mapsUrl),
                    ),
                    IconButton(
                      tooltip: 'WhatsApp',
                      icon: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                      ),
                      onPressed: celular.isEmpty
                          ? null
                          : () => onWhatsApp(celular),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _image() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: imagenUrl.isNotEmpty
          ? Image.network(
              imagenUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(),
            )
          : _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      height: 180,
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: const Icon(Icons.hotel, size: 60),
    );
  }
}
