import 'package:biblioteca/widgets/ProfileImage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom extends StatefulWidget {
  final String genre;

  const ChatRoom({super.key, required this.genre});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _controller = TextEditingController();

  void sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;

    if (_controller.text.trim().isNotEmpty && user != null) {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      final userData = userDoc.data() as Map<String, dynamic>;

      await FirebaseFirestore.instance.collection('messages').add({
        'text': _controller.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'userName': userData['nome'] ?? user.displayName ?? 'Usuário',
        'genre': widget.genre,
      });

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.genre,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Harmoni',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/perfil');
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProfileImage(),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection('messages')
                      .where('genre', isEqualTo: widget.genre)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (ctx, i) {
                    return ListTile(
                      leading: ProfileImage(
                        userId: docs[i]['userId'],
                        radius: 20,
                      ),
                      title: Text(docs[i]['userName'] ?? 'Desconhecido'),
                      subtitle: Text(docs[i]['text']),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: "Digite sua mensagem...",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: sendMessage,
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
