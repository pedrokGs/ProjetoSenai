import 'package:biblioteca/widgets/ProfileImage.dart';
import 'package:biblioteca/widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MeusDadosPage extends StatefulWidget {
  const MeusDadosPage({super.key});

  @override
  State<MeusDadosPage> createState() => _MeusDadosPageState();
}

class _MeusDadosPageState extends State<MeusDadosPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User? user = _auth.currentUser;

  Future<Map<String, dynamic>?> getUserData() async {
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user!.uid).get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Dados"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProfileImage(),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Erro ao carregar dados do usuário."));
          }

          final data = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: data['fotoPerfil'] != null
                      ? NetworkImage(data['fotoPerfil'])
                      : null,
                  child: data['fotoPerfil'] == null ? const Icon(Icons.person, size: 50) : null,
                ),
                const SizedBox(height: 20),
                Text(
                  data['nome'] ?? user!.displayName ?? 'Usuário sem nome',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  user!.email ?? 'Email não disponível',
                  style: const TextStyle(fontSize: 18),
                ),
                const Divider(height: 40),
                ListTile(
                  title: const Text("Nome completo"),
                  subtitle: Text(data['nome'] ?? '-'),
                  leading: const Icon(Icons.person),
                ),
                ListTile(
                  title: const Text("E-mail"),
                  subtitle: Text(user!.email ?? '-'),
                  leading: const Icon(Icons.email),
                ),
                if (data['telefone'] != null)
                  ListTile(
                    title: const Text("Telefone"),
                    subtitle: Text(data['telefone']),
                    leading: const Icon(Icons.phone),
                  ),
                if (data['generoFavorito'] != null)
                  ListTile(
                    title: const Text("Gênero favorito"),
                    subtitle: Text(data['generoFavorito']),
                    leading: const Icon(Icons.book),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
    );
  }
}
