import 'package:biblioteca/FirebaseAuthService.dart';
import 'package:biblioteca/FirestoreService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageKids extends StatefulWidget {
  const HomePageKids({super.key});

  @override
  State<HomePageKids> createState() => _HomePageKidsState();
}

class _HomePageKidsState extends State<HomePageKids> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuthService _firebaseAuth = FirebaseAuthService();

  late User? user = _firebaseAuth.getCurrentUser();
  late String userId = user!.uid;
  String _currentFilter = 'ler'; // 'ler' ou 'ouvir'

  Stream<QuerySnapshot> getLivrosInfantis() {
    if (_currentFilter == 'ler') {
      return _firestoreService.firestore
          .collection('livros')
          .where('kids', isEqualTo: true)
          .snapshots();
    } else {
      return _firestoreService.firestore
          .collection('audiobooks')
          .where('kids', isEqualTo: true)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFF76),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              List<int> numeros = List.generate(3, (_) => 1 + (3 + (10 * (0.3 + 0.7 * (DateTime.now().microsecond % 1000) / 1000)).toInt()) % 9);
                              final controller = TextEditingController();

                              return AlertDialog(
                                title: Text("Saída do modo infantil"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Digite os seguintes números para sair:"),
                                    SizedBox(height: 10),
                                    Text(
                                      numeros.join(' - '),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    TextField(
                                      controller: controller,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(hintText: "Digite os números"),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      if (controller.text.replaceAll(' ', '') == numeros.join('')) {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(context, '/home');
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Números incorretos. Tente novamente.')),
                                        );
                                      }
                                    },
                                    child: Text("Confirmar"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Icon(Icons.close, color: Colors.red, size: 48),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 80, fontFamily: 'Harmoni'),
                          children: [
                            TextSpan(text: 'K', style: TextStyle(color: Colors.blue)),
                            TextSpan(text: 'I', style: TextStyle(color: Colors.orange)),
                            TextSpan(text: 'D', style: TextStyle(color: Colors.green)),
                            TextSpan(text: 'S', style: TextStyle(color: Colors.purple)),
                          ],
                        ),
                      ),
                      Icon(Icons.favorite, color: Colors.red, size: 48),
                    ],
                  ),
                ),

                StreamBuilder<QuerySnapshot>(
                  stream: getLivrosInfantis(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Erro ao carregar livros.'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('Nenhum livro encontrado.'));
                    }

                    var livros = snapshot.data!.docs;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.55,
                        ),
                        itemCount: livros.length,
                        itemBuilder: (context, index) {
                          final livro = livros[index];
                          return GestureDetector(
                            onTap: () {
                              _currentFilter == 'ler'?
                              Navigator.pushNamed(
                                context,
                                '/detalhesLivro',
                                arguments: livro.id,
                              ) :
                              Navigator.pushNamed(
                                context,
                                '/detalhesAudiobook',
                                arguments: livro.id,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: livro['imagem'],
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      livro['titulo'],
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                SizedBox(height: 100), // Espaço extra para evitar overflow com os botões
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Color(0xFFFFFF76),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentFilter == 'ler'
                          ? Colors.orangeAccent
                          : Colors.grey[300],
                      foregroundColor: _currentFilter == 'ler'
                          ? Colors.purple
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    icon: Icon(Icons.menu_book, size: 28),
                    label: Text(
                      "Ler",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _currentFilter == 'ler'
                            ? Colors.purple
                            : Colors.grey,
                      ),
                    ),
                    onPressed: () {
                      if (_currentFilter != 'ler') {
                        setState(() {
                          _currentFilter = 'ler';
                        });
                      }
                    },
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentFilter == 'ouvir'
                          ? Colors.orangeAccent
                          : Colors.grey[300],
                      foregroundColor: _currentFilter == 'ouvir'
                          ? Colors.blueAccent
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    icon: Icon(Icons.headphones, size: 28),
                    label: Text(
                      "Ouvir",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _currentFilter == 'ouvir'
                            ? Colors.blueAccent
                            : Colors.grey,
                      ),
                    ),
                    onPressed: () {
                      if (_currentFilter != 'ouvir') {
                        setState(() {
                          _currentFilter = 'ouvir';
                        });
                      }
                    },
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