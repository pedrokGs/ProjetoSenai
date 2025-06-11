import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/favorites_service.dart';
import '../widgets/bottom_nav_bar.dart';

class FavoritosPage extends StatefulWidget {
  final String userId;
  const FavoritosPage({super.key, required this.userId});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  final FavoritosService _favoritosService = FavoritosService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _favoritosService.getFavoritos(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return const Center(child: Text('Erro ao carregar favoritos'));

          final favoritos = snapshot.data!;
          if (favoritos.isEmpty)
            return const Center(child: Text('Nenhum favorito ainda.'));

          return ListView.builder(
            itemCount: favoritos.length,
            itemBuilder: (context, index) {
              final livro = favoritos[index];
              return ListTile(
                leading: CachedNetworkImage(
                  imageUrl: livro['imagem'],
                  width: 50,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                title: Text(livro['titulo']),
                subtitle: Text(livro['autor']),
                onTap: () {
                  Navigator.pushNamed(context, '/detalhesLivro', arguments: livro.id);
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await _favoritosService.removerFavorito(widget.userId, livro.id);
                    setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
    );
  }
}
