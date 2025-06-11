import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../FirebaseAuthService.dart';

class DetalhesAudiobook extends StatefulWidget {
  const DetalhesAudiobook({super.key});

  @override
  State<DetalhesAudiobook> createState() => _DetalhesAudiobookState();
}

class _DetalhesAudiobookState extends State<DetalhesAudiobook> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuthService _firebaseAuth = FirebaseAuthService();
    late User? user = _firebaseAuth.getCurrentUser();
    late String userId = user!.uid;
    final String audiobookId =
        ModalRoute.of(context)!.settings.arguments as String;

    final DocumentReference audiobook = FirebaseFirestore.instance
        .collection('audiobooks')
        .doc(audiobookId);

    final DocumentReference userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "VORTEXUS",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontFamily: 'Harmoni',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: audiobook.get(),
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
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
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
                            "Detalhes do Audiobook",
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
                                    data['duracao'] ?? '0',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Duração',
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
                                    data['ouvintes'].toString() ?? '0',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Ouvintes',
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
                                color: Theme.of(context).colorScheme.secondary,
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data['autor'] ?? 'Autor não disponível',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  padding: const EdgeInsets.all(16),
                                ),
                                onPressed: () async {
                                  final userDoc = await userRef.get();

                                  if (userDoc.exists &&
                                      userDoc.data() != null) {
                                    final userData =
                                        userDoc.data()! as Map<String, dynamic>;
                                    List<dynamic> audiobooksAtuais =
                                        userData['audiobooks'] != null
                                            ? List<dynamic>.from(
                                              userData['audiobooks'],
                                            )
                                            : [];

                                    if (!audiobooksAtuais.contains(audiobookId)) {
                                      audiobooksAtuais.add(audiobookId);
                                      await userRef.update({
                                        'audiobooks': audiobooksAtuais,
                                      });
                                      Navigator.pushNamed(context, '/home');
                                    } else {
                                      print(
                                        'Audiobook já adicionado à lista de leituras.',
                                      );
                                      Navigator.pushNamed(context, '/ouvirAudiobook');
                                    }
                                  } else {
                                    await userRef.update({
                                      'audiobooks': [audiobookId],
                                    });
                                    Navigator.pushNamed(context, '/home');
                                  }
                                },
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
                            /*
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  padding: const EdgeInsets.all(16),
                                ),
                                onPressed: () async {},
                                child: const Text(
                                  'Ler agora',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                             */
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                collapsed: Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).colorScheme.primary,
                  child: const Text(
                    "Deslize para ver mais detalhes do audiobook",
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
