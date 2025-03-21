import 'package:biblioteca/FirebaseAuthService.dart';
import 'package:biblioteca/FirestoreService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: Text(
          "VORTEXUS",
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Harmoni',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF834d40),
      ),
      body: Center(
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
                    decoration: BoxDecoration(color: Color(0xFFedc9af)),
                    child: FutureBuilder<List<String>>(
                      future: getLivrosLidos(userId),
                      builder: (context, snapshotLivrosLidos) {
                        if (snapshotLivrosLidos.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshotLivrosLidos.hasError ||
                            !snapshotLivrosLidos.hasData) {
                          return Text('Erro ao carregar livros lidos');
                        }
                        List<String> livrosLidos = snapshotLivrosLidos.data!;
                        return StreamBuilder<QuerySnapshot>(
                          stream: getLivrosFiltrados(livrosLidos),
                          builder: (context, snapshotLivros) {
                            if (!snapshotLivros.hasData) {
                              return CircularProgressIndicator();
                            }
                            final livros = snapshotLivros.data!.docs;
                            return Padding(
                              // Adiciona padding
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  height: 200.0,
                                  enableInfiniteScroll: true,
                                  disableCenter: true,
                                  viewportFraction:
                                      0.45 // Ajusta o viewportFraction
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
                                                CachedNetworkImage(
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
            Container(),
          ],
        ),
      ),
    );
  }
}
