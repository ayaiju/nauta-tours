import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LugaresScreen extends StatelessWidget {
  const LugaresScreen({Key? key}) : super(key: key);

  Widget _buildCard(BuildContext context, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final nombre = data['nombre'] ?? 'Sin nombre';
    final descripcion = data['descripcion'] ?? '';
    final imageUrl = data['imageUrl'] as String?;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LugarDetailScreen(data: data),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                image: imageUrl != null && imageUrl.isNotEmpty
                    ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
                    : const DecorationImage(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nombre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(
                      descripcion,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance.collection('lugares').orderBy('nombre').snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Lugares Turísticos')),
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error al cargar lugares'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No hay lugares registrados aún.'));

          return ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 16),
            itemCount: docs.length,
            itemBuilder: (context, index) => _buildCard(context, docs[index]),
          );
        },
      ),
    );
  }
}

class LugarDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const LugarDetailScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nombre = data['nombre'] ?? 'Sin nombre';
    final descripcion = data['descripcion'] ?? '';
    final imageUrl = data['imageUrl'] as String?;
    final lat = data['lat'];
    final lng = data['lng'];

    return Scaffold(
      appBar: AppBar(title: Text(nombre)),
      body: ListView(
        children: [
          SizedBox(
            height: 220,
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity)
                : Image.asset('assets/placeholder.jpg', fit: BoxFit.cover, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(nombre, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(descripcion),
                const SizedBox(height: 20),
                if (lat != null && lng != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ubicación:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('Lat: $lat, Lng: $lng'),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Aquí puedes abrir Google Maps con url_launcher si quieres
                        },
                        icon: const Icon(Icons.map),
                        label: const Text('Ver en el mapa'),
                      )
                    ],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
