import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/ProfileImage.dart';
import '../widgets/bottom_nav_bar.dart';

class SearchResultPage extends StatefulWidget {
  final Future<List<DocumentSnapshot<Object?>>> livrosFuture;
  final Future<List<DocumentSnapshot<Object?>>> audiobooksFuture;

  const SearchResultPage({
    super.key,
    required this.livrosFuture,
    required this.audiobooksFuture,
  });

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  int _selectedIndex = 1; // Set 'Procurar' as the initial selected index

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
        child: Column(
          children: [
            SizedBox(height: 20),
            FutureBuilder<List<DocumentSnapshot<Object?>>>(
              future: widget.livrosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar livros: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final livros = snapshot.data!;
                  return _buildCarousel(
                    title: " Livros encontrados:",
                    items: livros,
                    onTap: (livroId) {
                      Navigator.pushNamed(
                        context,
                        '/detalhesLivro',
                        arguments: livroId,
                      );
                    },
                    imageUrlKey: 'imagem',
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
            FutureBuilder<List<DocumentSnapshot<Object?>>>(
              future: widget.audiobooksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar audiobooks: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final audiobooks = snapshot.data!;
                  return _buildCarousel(
                    title: " Audiobooks encontrados:",
                    items: audiobooks,
                    onTap: (audiobookId) {
                      Navigator.pushNamed(
                        context,
                        '/detalhesAudiobook',
                        arguments: audiobookId,
                      );
                    },
                    imageUrlKey: 'imagem',
                  );
                } else {
                  return FutureBuilder<List<DocumentSnapshot<Object?>>>(
                    future: widget.audiobooksFuture,
                    builder: (context, audiobookSnapshot) {
                      if (audiobookSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SizedBox.shrink(); // Evitar mostrar "Nenhum item encontrado" enquanto carrega audiobooks
                      }
                      if (audiobookSnapshot.hasData &&
                          audiobookSnapshot.data!.isNotEmpty) {
                        return SizedBox.shrink(); // Se há audiobooks, não mostrar mensagem de não encontrado
                      }
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Nenhum livro ou audiobook encontrado para a sua busca.',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  );
                }
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),

        bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1)
    );
  }

  Widget _buildCarousel({
    required String title,
    required List<DocumentSnapshot<Object?>> items,
    required Function(String) onTap,
    required String imageUrlKey,
  }) {
    if (items.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 28, fontFamily: 'Harmoni'),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 220,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                enableInfiniteScroll: false,
                disableCenter: false,
                viewportFraction: 0.45,
              ),
              items:
                  items.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: MediaQuery.of(context).size.width * 0.45,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: GestureDetector(
                            onTap: () => onTap(item.id),
                            child: Center(
                              child: CachedNetworkImage(
                                imageUrl: item[imageUrlKey],
                                height: 180,
                                width: 110,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) =>
                                        CircularProgressIndicator(),
                                errorWidget:
                                    (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
