import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentCtrl = TextEditingController();
  final CollectionReference _commentsCollection =
      FirebaseFirestore.instance.collection('comments');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> _sendComment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Debes iniciar sesión para comentar")));
      return;
    }

    String commentText = _commentCtrl.text.trim();
    if (commentText.isEmpty) return;

    // Obtener el nombre del usuario desde la colección users
    final userDoc = await _usersCollection.doc(user.uid).get();
    String username = "Usuario";
    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;
      username = data['name'] ?? username;
    }

    await _commentsCollection.add({
      'uid': user.uid,
      'username': username,
      'comment': commentText,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _commentCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comentarios"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: [
          // LISTA DE COMENTARIOS
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _commentsCollection
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No hay comentarios aún."));
                }

                final comments = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    final username = comment['username'] ?? "Usuario";
                    final text = comment['comment'] ?? "";

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        child: Text(username[0].toUpperCase()),
                      ),
                      title: Text(username),
                      subtitle: Text(text),
                    );
                  },
                );
              },
            ),
          ),

          // CAJA PARA ESCRIBIR COMENTARIOS
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentCtrl,
                      decoration: InputDecoration(
                        hintText: "Escribe tu comentario...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _sendComment,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent),
                    child: const Text("Enviar"),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
