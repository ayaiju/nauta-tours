import 'package:flutter/material.dart';
import 'package:nauta_tours/screens/map_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class LugaresScreen extends StatelessWidget {
  const LugaresScreen({super.key});

  // 🔥 Obtener lugares desde Supabase
  Future<List<Map<String, dynamic>>> _fetchLugares() async {
    final data = await Supabase.instance.client
        .from('lugares')
        .select()
        .order('nombre');

    return List<Map<String, dynamic>>.from(data);
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> lugar) {
    final nombre = lugar['nombre'] ?? 'Sin nombre';
    final descripcion = lugar['descripcion'] ?? '';
    final imageUrl = lugar['image_url']?.toString();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LugarDetailScreen(lugar: lugar)),
          );
        },
        child: Row(
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
                image: imageUrl != null && imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage('assets/placeholder.jpg'),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      descripcion,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lugares Turísticos')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchLugares(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar lugares'));
          }

          final lugares = snapshot.data ?? [];

          if (lugares.isEmpty) {
            return const Center(child: Text('No hay lugares registrados.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 16),
            itemCount: lugares.length,
            itemBuilder: (context, index) =>
                _buildCard(context, lugares[index]),
          );
        },
      ),
    );
  }
}

class LugarDetailScreen extends StatelessWidget {
  final Map<String, dynamic> lugar;

  const LugarDetailScreen({super.key, required this.lugar});

  @override
  Widget build(BuildContext context) {
    final nombre = lugar['nombre'] ?? 'Sin nombre';
    final descripcion = lugar['descripcion'] ?? '';
    final imageUrl = lugar['image_url']?.toString();

    final lat = (lugar['lat'] as num?)?.toDouble();
    final lng = (lugar['lng'] as num?)?.toDouble();

    return Scaffold(
      appBar: AppBar(title: Text(nombre)),
      body: ListView(
        children: [
          SizedBox(
            height: 220,
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(imageUrl, fit: BoxFit.cover)
                : Image.asset('assets/placeholder.jpg', fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(descripcion),
                const SizedBox(height: 20),
                if (lat != null && lng != null)
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.map),
                      label: const Text('Ver en el mapa'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapaLugarScreen(
                              lat: lat,
                              lng: lng,
                              nombre: nombre,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
