import 'package:biblioteca/FirestoreService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaginaCategoria extends StatefulWidget {
  const PaginaCategoria({super.key});

  @override
  State<PaginaCategoria> createState() => _PaginaCategoriaState();
}

class _PaginaCategoriaState extends State<PaginaCategoria> {
  final FirestoreService _firestoreService = FirestoreService();
  int _selectedIndex = 1;

  Future<List<DocumentSnapshot>> getLivrosCategoria(String categoria) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestoreService.firestore
              .collection('livros')
              .where('categoria', arrayContains: categoria)
              .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Erro ao obter livros por categoria: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  @override
  Widget build(BuildContext context) {
    final String categoria =
        ModalRoute.of(context)!.settings.arguments as String;
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
                    " Principais Livros de ${categoria}",
                    style: TextStyle(fontSize: 28, fontFamily: 'Harmoni'),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Color(0xFFedc9af)),
                    child: FutureBuilder<List<DocumentSnapshot>>(
                      future: getLivrosCategoria(
                        categoria,
                      ), // Use a função correta aqui
                      builder: (context, snapshotLivros) {
                        if (snapshotLivros.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshotLivros.hasError ||
                            !snapshotLivros.hasData ||
                            snapshotLivros.data!.isEmpty) {
                          return Text(
                            'Nenhum livro encontrado para esta categoria.',
                          );
                        }
                        final livros = snapshotLivros.data!;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: 200.0,
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
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFedc9af),
                                        ),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/detalhesLivro',
                                                  arguments: livro.id,
                                                );
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Color(0xFF834d40),
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
