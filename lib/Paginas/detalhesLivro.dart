import 'package:biblioteca/FirebaseAuthService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DetalhesLivro extends StatefulWidget {
  const DetalhesLivro({super.key});

  @override
  State<DetalhesLivro> createState() => _DetalhesLivroState();
}

class _DetalhesLivroState extends State<DetalhesLivro> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuthService _firebaseAuth = FirebaseAuthService();
    late User? user = _firebaseAuth.getCurrentUser();
    late String userId = user!.uid;
    final String livroId = ModalRoute.of(context)!.settings.arguments as String;

    final DocumentReference livro = FirebaseFirestore.instance
        .collection('livros')
        .doc(livroId);

    final DocumentReference userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "VORTEXUS",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05, // Responsivo
            fontFamily: 'Harmoni',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF834d40),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: livro.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          return Stack(
            children: [
              // Background image
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(data['imagem'] ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Sliding Panel
              SlidingUpPanel(
                color: Color(0xFFfdf2e9),
                panel: Column(
                  children: [
                    // Cabeçalho do painel
                    Container(
                      height: 100, // Altura semelhante ao cabeçalho da imagem
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF834d40),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24.0),
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Detalhes do Livro",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    data['paginas'].toString() ?? '0',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Páginas',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    data['leitores'].toString() ?? '0',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Leitores',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Conteúdo do painel
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            Container(
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xFFedc9af),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data['titulo'] ?? 'Título não disponível',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    data['autor'] ?? 'Autor não disponível',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xFFedc9af),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: SingleChildScrollView(
                                  child: Text(
                                    data['sinopse'] ?? "Sinopse indisponível",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: const Color(0xFF834d40),
                                  padding: const EdgeInsets.all(16),
                                ),
                                onPressed: () async {},
                                child: const Text(
                                  'Ouvir agora',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: const Color(0xFF834d40),
                                  padding: const EdgeInsets.all(16),
                                ),
                                onPressed: () async {
                                  final userDoc = await userRef.get();

                                  if (userDoc.exists &&
                                      userDoc.data() != null) {
                                    final userData =
                                        userDoc.data()!
                                            as Map<
                                              String,
                                              dynamic
                                            >;
                                    List<dynamic> leiturasAtuais =
                                        userData['leituras'] != null
                                            ? List<dynamic>.from(
                                              userData['leituras'],
                                            )
                                            : [];

                                    leiturasAtuais.add(livroId);

                                    await userRef.update({
                                      'leituras': leiturasAtuais,
                                    });
                                  } else {
                                    await userRef.update({
                                      'leituras': [livroId],
                                    });
                                  }
                                },

                                child: const Text(
                                  'Ler agora',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                collapsed: Container(
                  alignment: Alignment.center,
                  color: const Color(0xFF834d40),
                  child: const Text(
                    "Deslize para ver mais detalhes do livro",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                minHeight: 80,
                maxHeight: MediaQuery.of(context).size.height * 0.6,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24.0),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
