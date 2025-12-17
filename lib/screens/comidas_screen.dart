import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ComidasScreen extends StatelessWidget {
  const ComidasScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchComidas() async {
    final data = await Supabase.instance.client
        .from('comidas')
        .select()
        .eq('activo', true)
        .order('nombre');

    return List<Map<String, dynamic>>.from(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comidas Típicas'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchComidas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar comidas'));
          }

          final comidas = snapshot.data ?? [];

          if (comidas.isEmpty) {
            return const Center(child: Text('No hay comidas registradas'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: comidas.length,
            itemBuilder: (context, index) {
              final c = comidas[index];

              return _ComidaCard(
                nombre: c['nombre']?.toString() ?? '',
                descripcion: c['descripcion']?.toString() ?? '',
                imagenUrl: c['imagen_url']?.toString() ?? '',
              );
            },
          );
        },
      ),
    );
  }
}

class _ComidaCard extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final String imagenUrl;

  const _ComidaCard({
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(16),
            ),
            child: Image.network(
              imagenUrl,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 110,
                height: 110,
                color: Colors.grey[300],
                child: const Icon(Icons.restaurant, size: 40),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
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
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
