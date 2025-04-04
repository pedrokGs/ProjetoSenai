import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PesquisaCategoria extends StatefulWidget {
  const PesquisaCategoria({super.key});

  @override
  State<PesquisaCategoria> createState() => _PesquisaCategoriaState();
}

class _PesquisaCategoriaState extends State<PesquisaCategoria> {
  int _selectedIndex = 1;
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
            SizedBox(height: 20,),
            Text("CATEGORIAS", style: TextStyle(fontSize: 40, color: Color(0xFF834d40), fontWeight: FontWeight.bold),),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(12),
                crossAxisSpacing: 12,
                mainAxisSpacing: 0,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: 'https://i.imgur.com/5CInpGl.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: 'https://i.imgur.com/Sn1D5UQ.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context,'/paginaCategoria', arguments: 'aventura');
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: 'https://i.imgur.com/YVynLTu.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: 'https://i.imgur.com/TQO0iNi.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: 'https://i.imgur.com/ptrXuRr.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: 'https://i.imgur.com/jvQnyeW.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: 'https://i.imgur.com/AuTCrof.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: 'https://i.imgur.com/NZoJT7W.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: 'https://i.imgur.com/6fKB6ih.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: 'https://i.imgur.com/BNv2WR5.png',
                        fit: BoxFit.contain,
                      ),
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
