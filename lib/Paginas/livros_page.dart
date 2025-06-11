import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../widgets/bottom_nav_bar.dart';

class MaisLidosPage extends StatefulWidget {
  const MaisLidosPage({super.key});

  @override
  State<MaisLidosPage> createState() => _MaisLidosPageState();
}

class _MaisLidosPageState extends State<MaisLidosPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String filtroSelecionado = 'livros';

  Future<List<QueryDocumentSnapshot>> getMaisLidos() async {
    final snapshot = await _firestore
        .collection(filtroSelecionado)
        .orderBy(filtroSelecionado == 'livros' ? 'leitores' : 'ouvintes', descending: true)
        .limit(5)
        .get();

    return snapshot.docs;
  }

  Future<List<QueryDocumentSnapshot>> getOutros(List<String> idsMaisLidos) async {
    final snapshot = await _firestore.collection(filtroSelecionado).get();
    return snapshot.docs.where((doc) => !idsMaisLidos.contains(doc.id)).toList();
  }

  Widget buildCarrossel(List<QueryDocumentSnapshot> livros) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        disableCenter: true,
        viewportFraction: 0.45,
      ),
      items: livros.map((livro) {
        return Builder(
          builder: (context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: const BoxDecoration(color: Color(0xFFedc9af)),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, filtroSelecionado == 'livros' ? '/detalhesLivro' : '/detalhesAudiobook', arguments: livro.id);
                },
                child: CachedNetworkImage(
                  imageUrl: livro['imagem'],
                  height: 200,
                  width: 120,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
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
      appBar: AppBar(
        title: const Text('Livros Populares'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Botões de filtro
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text("Ler"),
                selected: filtroSelecionado == 'livros',
                onSelected: (_) {
                  setState(() {
                    filtroSelecionado = 'livros';
                  });
                },
              ),
              const SizedBox(width: 12),
              ChoiceChip(
                label: const Text("Ouvir"),
                selected: filtroSelecionado == 'audiobooks',
                onSelected: (_) {
                  setState(() {
                    filtroSelecionado = 'audiobooks';
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
              future: getMaisLidos(),
              builder: (context, snapshotMaisLidos) {
                if (snapshotMaisLidos.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshotMaisLidos.hasError) {
                  return const Center(child: Text('Erro ao carregar dados'));
                }

                final maisLidos = snapshotMaisLidos.data!;
                final maisLidosIds = maisLidos.map((doc) => doc.id).toList();

                return FutureBuilder(
                  future: getOutros(maisLidosIds),
                  builder: (context, snapshotOutros) {
                    if (snapshotOutros.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshotOutros.hasError) {
                      return const Center(child: Text('Erro ao carregar dados'));
                    }

                    final outros = snapshotOutros.data!;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Text(
                              'Mais lidos',
                              style: TextStyle(fontSize: 28, fontFamily: 'Harmoni'),
                            ),
                          ),
                          buildCarrossel(maisLidos),
                          const SizedBox(height: 30),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Outros livros',
                              style: TextStyle(fontSize: 28, fontFamily: 'Harmoni'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          buildCarrossel(outros),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
    );
  }
}
