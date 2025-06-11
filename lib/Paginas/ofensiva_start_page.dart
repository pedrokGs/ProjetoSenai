import 'package:biblioteca/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/ProfileImage.dart';

class OfensivaStartPage extends StatefulWidget {
  const OfensivaStartPage({super.key});

  @override
  State<OfensivaStartPage> createState() => _OfensivaStartPageState();
}

class _OfensivaStartPageState extends State<OfensivaStartPage> {
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

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "Inicie sua jornada de ofensivas!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w400,
                fontFamily: 'Harmoni',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Quer ser um Explorador de histórias  ainda mais ávido? Então inicialize suas ofensivas!Seja persistente em suas leituras, e se desafie com os conteúdos do Vortexus!",


              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SizedBox(height: MediaQuery.of(context).size.height * 0.4, width: 200,child: Image.asset("assets/img/ofensiva.png", fit: BoxFit.contain,)),
            const SizedBox(height: 30),
            GestureDetector(
              onHorizontalDragEnd: (details) {
                Navigator.pushNamed(context, '/ofensivamainpage');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.swipe, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Deslize para começar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),


      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
    );
  }
}
