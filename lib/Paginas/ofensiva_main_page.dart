import 'package:biblioteca/Paginas/ofensiva_reward_page.dart';
import 'package:biblioteca/services/streak_service.dart';
import 'package:biblioteca/widgets/bottom_nav_bar.dart';
import 'package:biblioteca/widgets/ProfileImage.dart';
import 'package:flutter/material.dart';

class OfensivaMainPage extends StatefulWidget {
  const OfensivaMainPage({super.key});

  @override
  State<OfensivaMainPage> createState() => _OfensivaMainPageState();
}

class _OfensivaMainPageState extends State<OfensivaMainPage> {
   int streakDias = 0;

  void _showRecompensasDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Recompensas da Ofensiva'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              ListTile(
                leading: Icon(Icons.star, color: Colors.amber),
                title: Text('20 dias'),
                subtitle: Text('Desconto no plano por 1 mês'),
              ),
              ListTile(
                leading: Icon(Icons.star, color: Colors.amber),
                title: Text('40 dias'),
                subtitle: Text('Desconto no plano por 2 meses'),
              ),
              ListTile(
                leading: Icon(Icons.star, color: Colors.amber),
                title: Text('60 dias'),
                subtitle: Text('Plano gratuito por 1 mês'),
              ),
              ListTile(
                leading: Icon(Icons.star, color: Colors.amber),
                title: Text('80 dias'),
                subtitle: Text('Desconto de 5% na compra de um livro'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

    void loadStreak() async {
      int novaStreak = await StreakService().getStreak();
      setState(() {
        streakDias = novaStreak;
      });
    }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StreakService().atualizarStreak().then((_) {
      loadStreak();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ofensiva'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: true,
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/perfil'),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: ProfileImage(radius: 20),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Olá! Explorador de Histórias, vejo que está mais do que animado para desbravar nossos conteúdos!\n\n"
                  "Continue assim e será um dos nossos exploradores mais ávidos.",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Harmoni',
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Mostrando o streak
            Container(
              padding: const EdgeInsets.all(20),
              width: 220,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Seu streak atual',
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'Harmoni',
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, size: 45,color: streakDias >= 3 ? Colors.orange : Colors.grey,),
                      Text(
                        '$streakDias dias',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: streakDias >= 3 ? Colors.orange : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              icon: const Icon(Icons.card_giftcard, color: Colors.white,),
              label: const Text('Ver recompensas da ofensiva', style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: _showRecompensasDialog,
            ),

            SizedBox(height: 32,),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (context) => RecompensasPage(),)),
              child: const Text('Resgatar recompensas', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
