import 'package:flutter/material.dart';

import '../ProfileImage.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final List<Map<String, String>> perguntasRespostas = [
    {
      "pergunta": "Por que Vortexus",
      "resposta":
          "A palavra Vortexus vem da origem de duas palavras Vortex que indica um movimento circular intenso e Exus que dá um toque de futurismo, e por isso juntamos as duas palavras que na tradução literal significaria '' centro dinâmico de conhecimento '' sendo ideal para nosso projeto que visa ser uma biblioteca com inúmeros conhecimentos, deixando-o dinâmico e único",
    },
    {
      "pergunta": "Como fazer marcações nos livros",
      "resposta":
          "Você pode usar as ferramentas de marcação dentro do aplicativo.",
    },
    {
      "pergunta": "Não encontrei o livro que eu quero",
      "resposta": "Tente procurar novamente ou entre em contato com o suporte.",
    },
    {
      "pergunta": "Os livros são completos",
      "resposta": "Sim, todos os livros são completos.",
    },
    {
      "pergunta": "Como achar os melhores livros",
      "resposta": "Explore as categorias e veja as recomendações.",
    },
    {
      "pergunta": "Minha conta consta como expirada",
      "resposta": "Verifique a data de validade da sua assinatura.",
    },
    {
      "pergunta": "Como mexer nos áudios",
      "resposta": "Use os controles de play, pause e avançar.",
    },
    {
      "pergunta": "O Que o Exus faz",
      "resposta": "Exus ajuda você a descobrir novos conteúdos.",
    },
    {
      "pergunta": "Tem como abaixar",
      "resposta": "Sim, você pode baixar livros para ler offline.",
    },
    {
      "pergunta": "Como funciona o plano",
      "resposta": "O plano oferece acesso a todos os livros e recursos.",
    },
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 12),
            Text("Perguntas Frequentes", style: TextStyle(fontSize: 24)),
            SizedBox(height: 12),

            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
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

            Expanded(
              child: ListView.builder(
                itemCount: perguntasRespostas.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Theme.of(context).colorScheme.secondary,
                    margin: EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      title: Text(perguntasRespostas[index]["pergunta"]!),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(perguntasRespostas[index]["resposta"]!),
                        ),
                      ],
                    ),
                  );
                },
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
        case 3:
          Navigator.pushNamed(context, '/aiChat');
      }
    });
  }
}
