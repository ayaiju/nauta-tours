import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BebidasScreen extends StatelessWidget {
  const BebidasScreen({super.key});

  // Obtener bebidas desde Supabase
  Future<List<Map<String, dynamic>>> _fetchBebidas() async {
    final data = await Supabase.instance.client
        .from('bebidas')
        .select()
        .eq('activo', true)
        .order('nombre');

    return List<Map<String, dynamic>>.from(data);
  }

  Widget _buildCard(Map<String, dynamic> bebida) {
    final nombre = bebida['nombre'] ?? 'Sin nombre';
    final descripcion = bebida['descripcion'] ?? '';
    final imageUrl = bebida['image_url']?.toString() ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 64,
            height: 64,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Image.asset('assets/placeholder.jpg', fit: BoxFit.cover),
            ),
          ),
        ),
        title: Text(
          nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          descripcion,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          // Aquí puedes mostrar detalle o receta
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bebidas Tradicionales')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchBebidas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar bebidas'));
          }

          final bebidas = snapshot.data ?? [];

          if (bebidas.isEmpty) {
            return const Center(child: Text('No hay bebidas registradas.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: bebidas.length,
            itemBuilder: (context, index) => _buildCard(bebidas[index]),
          );
        },
      ),
    );
  }
}
