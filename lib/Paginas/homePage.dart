import 'package:biblioteca/FirebaseAuthService.dart';
import 'package:biblioteca/FirestoreService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ProfileImage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuthService _firebaseAuth = FirebaseAuthService();

  late User? user = _firebaseAuth.getCurrentUser();
  late String userId = user!.uid;

  Future<List<String>> getLivrosLidos(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestoreService.firestore
              .collection('users')
              .doc(userId)
              .get();
      if (userDoc.exists) {
        List<dynamic> leituras = userDoc.get('leituras');
        return leituras.map((item) => item.toString()).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Erro ao obter livros lidos: $e');
      return [];
    }
  }

  Future<List<String>> getAudiobooksEscutados(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestoreService.firestore
              .collection('users')
              .doc(userId)
              .get();
      if (userDoc.exists) {
        List<dynamic> audiobooks = userDoc.get('audiobooks');
        return audiobooks.map((item) => item.toString()).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Erro ao obter audiobooks escutados: $e');
      return [];
    }
  }

  Stream<QuerySnapshot> getAudiobooksFiltrados(List<String> audiobooksLidos) {
    if (audiobooksLidos.isEmpty) {
      return Stream.empty();
    } else {
      return _firestoreService.firestore
          .collection('audiobooks')
          .where(FieldPath.documentId, whereIn: audiobooksLidos)
          .snapshots();
    }
  }

  Stream<QuerySnapshot> getLivrosFiltrados(List<String> livrosLidos) {
    if (livrosLidos.isEmpty) {
      return Stream.empty();
    } else {
      return _firestoreService.firestore
          .collection('livros')
          .where(FieldPath.documentId, whereIn: livrosLidos)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: Text(
                "VORTEXUS",
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " Leituras Iniciadas",
                      style: TextStyle(fontSize: 28, fontFamily: 'Harmoni'),
                    ),
                    Container(
        
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
                      child: FutureBuilder<List<String>>(
                        future: getLivrosLidos(userId),
                        builder: (context, snapshotLivrosLidos) {
                          List<String> livrosLidos = snapshotLivrosLidos.data!;
                          if (livrosLidos.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text("Nenhuma leitura iniciada ainda.", style: TextStyle(fontSize: 24)),
                            );
                          }
                          if (snapshotLivrosLidos.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshotLivrosLidos.hasError ||
                              !snapshotLivrosLidos.hasData) {
                            return Text('Erro ao carregar livros lidos');
                          }
                          return StreamBuilder<QuerySnapshot>(
                            stream: getLivrosFiltrados(livrosLidos),
                            builder: (context, snapshotLivros) {
                              if (!snapshotLivros.hasData) {
                                return CircularProgressIndicator();
                              }
                              final livros = snapshotLivros.data!.docs;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    height: 200.0,
                                    enlargeCenterPage: true,
                                    enableInfiniteScroll: true,
                                    disableCenter: true,
                                    viewportFraction: 0.45,
                                  ),
                                  items:
                                      livros.map((livro) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 5,
                                              ),
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFedc9af),
                                              ),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(context, '/detalhesLivro', arguments: livro.id);
                                                    },
                                                    child: CachedNetworkImage(
                                                      imageUrl: livro['imagem'],
                                                      height: 200,
                                                      width: 120,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              CircularProgressIndicator(),
                                                      errorWidget:
                                                          (context, url, error) =>
                                                              Icon(Icons.error),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
        
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " Audiobooks iniciados",
                      style: TextStyle(fontSize: 28, fontFamily: 'Harmoni'),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Color(0xFFedc9af)),
                      child: FutureBuilder<List<String>>(
                        future: getAudiobooksEscutados(userId),
                        builder: (context, snapshotAudiobooksEscutados) {
                          if (snapshotAudiobooksEscutados.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshotAudiobooksEscutados.hasError ||
                              !snapshotAudiobooksEscutados.hasData) {
                            return Text('Erro ao carregar audiobooks escutados');
                          }
                          List<String> audiobooksEscutados =
                              snapshotAudiobooksEscutados.data!;
                          if (audiobooksEscutados.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text("Nenhum audiobook iniciado ainda.", style: TextStyle(fontSize: 24)),
                            );
                          }
                          return StreamBuilder<QuerySnapshot>(
                            stream: getAudiobooksFiltrados(audiobooksEscutados),
                            builder: (context, snapshotAudiobooks) {
                              if (!snapshotAudiobooks.hasData) {
                                return CircularProgressIndicator();
                              }
                              final audibooks = snapshotAudiobooks.data!.docs;
                              return Padding(
                                // Adiciona padding
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    enlargeCenterPage: true,
                                    height: 200.0,
                                    enableInfiniteScroll: true,
                                    disableCenter: true,
                                    viewportFraction: 0.45,
                                  ),
                                  items:
                                      audibooks.map((audiobook) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 5,
                                              ),
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.secondary,
                                              ),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                        context,
                                                        '/detalhesAudiobook',
                                                        arguments: audiobook.id,
                                                      );
                                                    },
                                                    child: CachedNetworkImage(
                                                      imageUrl: audiobook['imagem'],
                                                      height: 200,
                                                      width: 120,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              CircularProgressIndicator(),
                                                      errorWidget:
                                                          (context, url, error) =>
                                                              Icon(Icons.error),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).colorScheme.primary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xFF834d40),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Procurar',
            backgroundColor: Color(0xFF834d40),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
            backgroundColor: Color(0xFF834d40),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.android),
            label: 'Chats',
            backgroundColor: Color(0xFF834d40),
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      switch (_selectedIndex) {
        case 0:
          Navigator.pushNamed(context, '/home');
          break;
        case 1:
          Navigator.pushNamed(context, '/pesquisar');
          break;
        case 2:
          Navigator.pushNamed(context, '/chatroom');
        case 3:
          Navigator.pushNamed(context, '/aiChat');
      }
    });
  }
}

