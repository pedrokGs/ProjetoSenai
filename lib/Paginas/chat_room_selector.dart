import 'package:biblioteca/Paginas/chat_room.dart';
import 'package:biblioteca/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/ProfileImage.dart';

class ChatRoomSelector extends StatelessWidget {
  final List<String> genres = [
    'Aventura',
    'Romance',
    'Terror',
    'Fantasia',
    'Suspense',
    'Ficção Científica',
    'Drama',
    'Comédia',
    'Biografia',
    'História'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
      body: ListView.builder(
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          return ListTile(
            title: Text(genre),
            leading: const Icon(Icons.chat_bubble_outline),
            trailing: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(15)
            ),child:Text("Participe"),),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatRoom(genre: genre),
                ),
              );
            },
          );
        },
      ),
      
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 2),
    );
  }
}
