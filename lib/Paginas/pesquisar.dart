import 'package:biblioteca/FirestoreService.dart';
import 'package:biblioteca/Paginas/searchResultPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ThemeProvider.dart';

class Pesquisar extends StatefulWidget {
  const Pesquisar({super.key});

  @override
  State<Pesquisar> createState() => _PesquisarState();
}

class _PesquisarState extends State<Pesquisar> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _pesquisaController = TextEditingController();
  int _selectedIndex = 1;

  Future<List<DocumentSnapshot<Object?>>>? livros; // Make it nullable
  Future<List<DocumentSnapshot<Object?>>>? audiobooks; // Make it nullable

  Future<List<DocumentSnapshot>> searchBooks(String query) async {
    final result =
        await _firestoreService.firestore
            .collection('livros')
            .orderBy('titulo')
            .startAt([query.toUpperCase()])
            .endAt([query.toUpperCase() + '\uf8ff'])
            .get();
    return result.docs;
  }

  Future<List<DocumentSnapshot>> searchAudiobooks(String query) async {
    final result =
        await _firestoreService.firestore
            .collection('audiobooks')
            .orderBy('titulo')
            .startAt([query.toUpperCase()])
            .endAt([query.toUpperCase() + '\uf8ff'])
            .get();
    return result.docs;
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
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Form(
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      controller: _pesquisaController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        hintText: "Pesquisar",
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pesquise algo!';
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(width: 12),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.22,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () {
                        if (_pesquisaController.text.isNotEmpty) {
                          final Future<List<DocumentSnapshot>>
                          livrosResultsFuture = searchBooks(
                            _pesquisaController.text,
                          );
                          final Future<List<DocumentSnapshot>>
                          audiobooksResultsFuture = searchAudiobooks(
                            _pesquisaController.text,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => SearchResultPage(
                                    livrosFuture: livrosResultsFuture,
                                    audiobooksFuture: audiobooksResultsFuture,
                                  ),
                            ),
                          );
                        } else {
                          print('O campo de pesquisa está vazio.');
                        }
                      },
                      child: Text(
                        "Procurar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 27),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,

              padding: const EdgeInsets.all(12),

              crossAxisSpacing: 12,

              mainAxisSpacing: 4,

              children: [
                /*

GestureDetector(

onTap: () {},

child: Container(

padding: EdgeInsets.all(4),

decoration: BoxDecoration(

borderRadius: BorderRadius.circular(12),

),

child: CachedNetworkImage(

imageUrl: 'https://i.imgur.com/6rFYwtb.png',

fit: BoxFit.contain,

),

),

),

*/
                GestureDetector(
                  onTap: () {},

                  child: Container(
                    padding: EdgeInsets.all(4),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: CachedNetworkImage(
                      imageUrl: 'https://i.imgur.com/Cyufels.png',

                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/pesquisaCategoria');
                  },

                  child: Container(
                    padding: EdgeInsets.all(4),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: CachedNetworkImage(
                      imageUrl: 'https://i.imgur.com/v30mFts.png',

                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/kids');
                  },

                  child: Container(
                    padding: EdgeInsets.all(4),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: CachedNetworkImage(
                      imageUrl: 'https://i.imgur.com/bALZpkM.png',

                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                /*



GestureDetector(

onTap: () {},

child: Container(

padding: EdgeInsets.all(4),

decoration: BoxDecoration(

borderRadius: BorderRadius.circular(12),

),

child: CachedNetworkImage(

imageUrl: 'https://i.imgur.com/bglIOUu.png',

fit: BoxFit.contain,

),

),

),

*/
                GestureDetector(
                  onTap: () {},

                  child: Container(
                    padding: EdgeInsets.all(4),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: CachedNetworkImage(
                      imageUrl: 'https://i.imgur.com/hyd6yVR.png',

                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
        currentIndex: _selectedIndex,
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
