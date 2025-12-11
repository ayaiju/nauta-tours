import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BebidasScreen extends StatelessWidget {
  const BebidasScreen({Key? key}) : super(key: key);

  Widget _buildCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final nombre = data['nombre'] ?? 'Sin nombre';
    final descripcion = data['descripcion'] ?? '';
    final imageUrl = data['imageUrl'] as String?;
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
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(imageUrl, fit: BoxFit.cover)
                : Image.asset('assets/placeholder.jpg', fit: BoxFit.cover),
          ),
        ),
        title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(descripcion, maxLines: 2, overflow: TextOverflow.ellipsis),
        onTap: () {
          // Puedes mostrar detalle o modal con receta/ingredientes
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance.collection('bebidas').orderBy('nombre').snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Bebidas Tradicionales')),
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error al cargar bebidas'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No hay bebidas registradas.'));

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: docs.length,
            itemBuilder: (context, index) => _buildCard(docs[index]),
          );
        },
      ),
    );
  }
}
