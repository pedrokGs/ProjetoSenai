import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ProfileImage.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Future<void> _showLogoutConfirmationDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible:
            false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sair da conta?'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Você tem certeza que deseja sair da sua conta?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor:
                      Colors
                          .red,
                ),
                child: const Text('Sair'),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
              ),
            ],
          );
        },
      );
    }

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 24),
            ProfileImage(radius: 125),
            SizedBox(height: 24),
            if (user != null)
              FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .get(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot,
                ) {
                  if (snapshot.hasError) {
                    return Text("Algo deu errado ao carregar os dados.");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;

                    String nome = data['nome'];
                    String email = data['email'];

                    return Column(
                      children: [
                        Text(
                          "$nome",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text("$email", style: TextStyle(fontSize: 20)),
                      ],
                    );
                  }

                  return CircularProgressIndicator();
                },
              )
            else
              Text("Nenhum usuário logado."),

            SizedBox(height: 64),

            Padding(
              padding: EdgeInsets.only(left: 50, right: 50),
              child: Column(
                children: [
                  GestureDetector(
                    child: ListTile(
                      title: Text(
                        "Frequência de Leitura",
                        style: TextStyle(fontSize: 24),
                      ),
                      leading: Icon(Icons.line_axis_rounded, size: 50),
                    ),
                    onTap:
                        () =>
                            Navigator.pushNamed(context, '/frequenciaLeitura'),
                  ),
                  Divider(color: Colors.grey),
                  GestureDetector(
                    child: ListTile(
                      title: Text("Meus dados", style: TextStyle(fontSize: 24)),
                      leading: Icon(Icons.person, size: 50),
                    ),
                    onTap: () => Navigator.pushNamed(context, '/meusDados'),
                  ),
                  Divider(color: Colors.grey),
                  GestureDetector(
                    child: ListTile(
                      title: Text(
                        "Perguntas Frequentes",
                        style: TextStyle(fontSize: 24),
                      ),
                      leading: Icon(Icons.question_mark, size: 50),
                    ),
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          '/perguntasFrequentes',
                        ),
                  ),
                  Divider(color: Colors.grey),
                  GestureDetector(
                    child: ListTile(
                      title: Text(
                        "Sair da minha conta",
                        style: TextStyle(fontSize: 24),
                      ),
                      leading: Icon(Icons.door_back_door, size: 50),
                    ),
                    onTap: _showLogoutConfirmationDialog,
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
          break;
        case 3:
          Navigator.pushNamed(context, '/aiChat');
          break;
      }
    });
  }
}
