import 'package:biblioteca/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca/services/streak_service.dart';

import '../services/user_service.dart';

class RecompensasPage extends StatefulWidget {
  const RecompensasPage({super.key});

  @override
  State<RecompensasPage> createState() => _RecompensasPageState();
}

class _RecompensasPageState extends State<RecompensasPage> {
  final _userService = UserService();
  int streakDias = 0;
  final List<Recompensa> recompensas = [
    Recompensa(diasNecessarios: 20, descricao: 'Desconto de 5% na compra de um livro'),
    Recompensa(diasNecessarios: 40, descricao: 'Desconto de 10% na compra de um livro'),
    Recompensa(diasNecessarios: 60, descricao: 'Desconto de 20% na compra de um livro'),
    Recompensa(diasNecessarios: 80, descricao: 'Desconto de 33% na compra de um livro'),
  ];

  final Set<int> recompensasResgatadas = {};

  @override
  void initState() {
    super.initState();
    _loadStreak();
    _loadRecompensasResgatadas();
  }

  void _loadRecompensasResgatadas() async {
    final data = await _userService.getRecompensasResgatadas();
    print('Dados do usuário: $data');
    if (data.isEmpty) return;

    setState(() {
      if (data['desconto_1mes'] == true) recompensasResgatadas.add(20);
      if (data['desconto_2mes'] == true) recompensasResgatadas.add(40);
      if (data['planogratuito_1mes'] == true) recompensasResgatadas.add(60);
      if (data['desconto_5'] == true) recompensasResgatadas.add(80);
    });
  }

  void _loadStreak() async {
    int novaStreak = await StreakService().getStreak();
    setState(() {
      streakDias = novaStreak;
    });
  }

  void _resgatarRecompensa(Recompensa recompensa) async {
    setState(() {
      recompensasResgatadas.add(recompensa.diasNecessarios);
    });

    String campoFirestore;
    switch (recompensa.diasNecessarios) {
      case 20:
        campoFirestore = 'desconto_1mes';
        break;
      case 40:
        campoFirestore = 'desconto_2mes';
        break;
      case 60:
        campoFirestore = 'planogratuito_1mes';
        break;
      case 80:
        campoFirestore = 'desconto_5';
        break;
      default:
        campoFirestore = '';
    }

    if (campoFirestore.isNotEmpty) {
      await _userService.atualizarRecompensa(campoFirestore);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Recompensa de ${recompensa.diasNecessarios} dias resgatada!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resgatar Recompensas'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Sua streak atual: $streakDias dias',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: recompensas.length,
                itemBuilder: (context, index) {
                  final recompensa = recompensas[index];
                  final podeResgatar = streakDias >= recompensa.diasNecessarios;
                  final jaResgatado = recompensasResgatadas.contains(recompensa.diasNecessarios);

                  return Card(
                    child: ListTile(
                      leading: Icon(
                        jaResgatado
                            ? Icons.check_circle
                            : podeResgatar
                            ? Icons.card_giftcard
                            : Icons.lock,
                        color: jaResgatado
                            ? Colors.green
                            : podeResgatar
                            ? Colors.amber
                            : Colors.grey,
                      ),
                      title: Text('${recompensa.diasNecessarios} dias'),
                      subtitle: Text(recompensa.descricao),
                      trailing: ElevatedButton(
                        onPressed: (podeResgatar && !jaResgatado)
                            ? () => _resgatarRecompensa(recompensa)
                            : null,
                        child: Text(jaResgatado ? 'Resgatado' : 'Resgatar'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
    );
  }
}

class Recompensa {
  final int diasNecessarios;
  final String descricao;

  Recompensa({required this.diasNecessarios, required this.descricao});
}
