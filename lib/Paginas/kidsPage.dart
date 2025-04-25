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

  Stream<QuerySnapshot> getLivrosInfantis() {
    return _firestoreService.firestore
        .collection('livros')
        .where('kids', isEqualTo: true)
        .snapshots();
  }



  Widget buildCarrosselLivro(List<QueryDocumentSnapshot> livros) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 250.0,
        enableInfiniteScroll: true,
        viewportFraction: 0.4,
        enlargeCenterPage: true,
      ),
      items: livros.map((livro) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/detalhesLivro', arguments: livro.id);
              },
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: livro['imagem'],
                      height: 180,
                      width: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    livro['titulo'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
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
                  stream: getLivrosInfantis(),  // Agora usamos diretamente o Stream
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError || !snapshot.hasData) {
                      return Text('Erro ao carregar livros.');
                    }

                    var livros = snapshot.data!.docs;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.55,
                        children: livros.map((livro) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/detalhesLivro',
                                arguments: livro.id,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: livro['imagem'],
                                    height: 180,
                                    width: 120,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
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
                        }).toList(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 80),
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Color(0xFFFFFF76),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.purple,
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
                        color: Colors.purple,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.blueAccent,
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
                        color: Colors.blueAccent,
                      ),
                    ),
                    onPressed: () {},
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
