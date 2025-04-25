import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> adicionarLivrosTeste() async {
  final livros = [
    {
      "autor": "Ruth Rocha",
      "categoria": ["Aventura", "Amizade", "Fábula"],
      "imagem": "https://i.imgur.com/Xn3Q25a.jpeg",
      "kids": true,
      "leitores": "674",
      "paginas": 64,
      "sinopse":
      "Neste livro encantador, Beto e sua turma embarcam numa aventura para salvar o bosque encantado de uma ameaça misteriosa. Ao longo do caminho, descobrem o valor da amizade e da coragem.",
      "titulo": "A Floresta dos Amigos"
    },
    {
      "autor": "Monteiro Lobato",
      "categoria": ["Clássico", "Fábula", "Fantasia"],
      "imagem": "https://i.imgur.com/YykZYbU.jpeg",
      "kids": true,
      "leitores": "1.204",
      "paginas": 88,
      "sinopse":
      "Em mais uma aventura no Sítio do Picapau Amarelo, Narizinho e Emília enfrentam desafios mágicos ao entrarem no Reino das Águas Claras, onde aprendem sobre empatia e imaginação.",
      "titulo": "Reino das Águas Claras"
    },
    {
      "autor": "Eva Furnari",
      "categoria": ["Fantasia", "Fábula", "Humor"],
      "imagem": "https://i.imgur.com/cOfFkXB.jpeg",
      "kids": true,
      "leitores": "843",
      "paginas": 52,
      "sinopse":
      "A história hilária de um bruxo desastrado e sua tentativa de encontrar o feitiço perfeito para fazer amigos. Uma jornada divertida cheia de lições sobre aceitação.",
      "titulo": "O Bruxo Teimoso"
    },
    {
      "autor": "Ana Maria Machado",
      "categoria": ["Fábula", "Conto", "Família"],
      "imagem": "https://i.imgur.com/t3KFTMG.jpeg",
      "kids": true,
      "leitores": "752",
      "paginas": 70,
      "sinopse":
      "Um conto delicado sobre uma criança e sua avó, que compartilham memórias e receitas mágicas que curam o coração e ensinam sobre a importância da tradição.",
      "titulo": "Receitas da Vovó"
    },
    {
      "autor": "Mauricio de Sousa",
      "categoria": ["Quadrinhos", "Aventura", "Humor"],
      "imagem": "https://i.imgur.com/fbMGE67.jpeg",
      "kids": true,
      "leitores": "1.523",
      "paginas": 96,
      "sinopse":
      "A Turma da Mônica enfrenta um sumiço misterioso no bairro do Limoeiro. Juntos, eles unem forças para desvendar o mistério e descobrem o valor do trabalho em equipe.",
      "titulo": "Mistério no Limoeiro"
    },
    {
      "autor": "Pedro Bandeira",
      "categoria": ["Mistério", "Aventura", "Juvenil"],
      "imagem": "https://i.imgur.com/Eq8ujB1.jpeg",
      "kids": true,
      "leitores": "812",
      "paginas": 128,
      "sinopse": "Os Karas enfrentam um novo enigma em uma escola onde estranhas mensagens aparecem nos corredores. Um livro cheio de suspense, desafios e lições sobre união.",
      "titulo": "A Marca de uma Lágrima"
    },
    {
      "autor": "Lúcia Hiratsuka",
      "categoria": ["Cultura", "Fábula", "Família"],
      "imagem": "https://i.imgur.com/z1WDquf.jpeg",
      "kids": true,
      "leitores": "479",
      "paginas": 40,
      "sinopse": "Inspirado na cultura japonesa, esta história acompanha um menino e seu avô pescando carpas mágicas e aprendendo sobre respeito e tradição.",
      "titulo": "O Pescador de Carpas"
    },
    {
      "autor": "Ilana Casoy",
      "categoria": ["Detetive", "Aventura", "Amizade"],
      "imagem": "https://i.imgur.com/9PzU6Dz.jpeg",
      "kids": true,
      "leitores": "916",
      "paginas": 96,
      "sinopse": "Um grupo de crianças forma um clube secreto para investigar um sumiço misterioso no bairro. Uma trama envolvente com muito humor e coragem.",
      "titulo": "O Mistério da Casa Azul"
    },
    {
      "autor": "Roger Mello",
      "categoria": ["Poesia", "Arte", "Fábula"],
      "imagem": "https://i.imgur.com/h65Jv8v.jpeg",
      "kids": true,
      "leitores": "302",
      "paginas": 36,
      "sinopse": "Uma coletânea poética sobre a natureza, os sentimentos e a beleza do mundo visto pelos olhos das crianças. Um convite à imaginação.",
      "titulo": "Versos do Céu e da Terra"
    },
    {
      "autor": "Tatiana Belinky",
      "categoria": ["Conto", "Clássico", "Animais"],
      "imagem": "https://i.imgur.com/A17FoGC.jpeg",
      "kids": true,
      "leitores": "657",
      "paginas": 45,
      "sinopse": "Recontos de fábulas clássicas com um toque moderno e engraçado. Os animais falam, pensam e nos ensinam lições com leveza e diversão.",
      "titulo": "Fábulas do Bicho Esperto"
    },
    {
      "autor": "Angela Lago",
      "categoria": ["Tecnologia", "Família", "Fábula"],
      "imagem": "https://i.imgur.com/Lpi5V5G.jpeg",
      "kids": true,
      "leitores": "564",
      "paginas": 48,
      "sinopse": "Lili tenta ensinar sua avó a usar o celular. Entre risos e confusões, elas constroem novas memórias e mostram que o afeto supera gerações.",
      "titulo": "Vovó Online"
    },
    {
      "autor": "Leo Cunha",
      "categoria": ["Poesia", "Criança", "Escola"],
      "imagem": "https://i.imgur.com/Gc17m9B.jpeg",
      "kids": true,
      "leitores": "388",
      "paginas": 38,
      "sinopse": "Poeminhas sobre a vida na escola: o recreio, o lápis que some, o lanche trocado... Uma leitura leve e divertida para os pequenos estudantes.",
      "titulo": "Poemas para a Hora do Recreio"
    },
    {
      "autor": "Marina Colasanti",
      "categoria": ["Fábula", "Reflexão", "Conto"],
      "imagem": "https://i.imgur.com/AV3Xkck.jpeg",
      "kids": true,
      "leitores": "511",
      "paginas": 60,
      "sinopse": "Contos curtos e mágicos sobre escolhas, liberdade e crescimento. Marina encanta com histórias que falam à mente e ao coração das crianças.",
      "titulo": "Doze Reis e a Moça no Labirinto do Vento"
    },
    {
      "autor": "Ricardo Azevedo",
      "categoria": ["Cultura Brasileira", "Humor", "Folclore"],
      "imagem": "https://i.imgur.com/TvY3YLS.jpeg",
      "kids": true,
      "leitores": "745",
      "paginas": 72,
      "sinopse": "Contos populares brasileiros recontados com humor e linguagem acessível. Um passeio pelas histórias que moldam a nossa cultura.",
      "titulo": "Histórias Que o Povo Conta"
    },
    {
      "autor": "Ziraldo",
      "categoria": ["Clássico", "Infância", "Reflexão"],
      "imagem": "https://i.imgur.com/L3Y4qHw.jpeg",
      "kids": true,
      "leitores": "1.940",
      "paginas": 120,
      "sinopse": "Um menino sonhador se destaca por suas ideias coloridas. Uma narrativa inspiradora sobre identidade, criatividade e aceitação.",
      "titulo": "O Menino Maluquinho"
    },
    {
      "autor": "Ana Maria Machado",
      "categoria": ["Amizade", "Escola", "Diversidade"],
      "imagem": "https://i.imgur.com/hqWkeKh.jpeg",
      "kids": true,
      "leitores": "845",
      "paginas": 64,
      "sinopse": "Juca chega à nova escola e descobre que ser diferente pode ser muito especial. Uma história leve sobre inclusão e companheirismo.",
      "titulo": "Amigo é Para Essas Coisas"
    },
    {
      "autor": "Eva Furnari",
      "categoria": ["Humor", "Criatividade", "Família"],
      "imagem": "https://i.imgur.com/vLDnqIf.jpeg",
      "kids": true,
      "leitores": "703",
      "paginas": 52,
      "sinopse": "Bisa Bia visita a bisavó e embarca em uma viagem no tempo recheada de humor e afeto. Uma história maluca e cheia de reviravoltas.",
      "titulo": "Bisa Bia, Bisa Bel"
    }


  ];

  final firestore = FirebaseFirestore.instance;

  for (var livro in livros) {
    await firestore.collection('livros').add(livro);
  }

  print("Livros adicionados com sucesso!");
  adicionarLivrosTeste();

}

void removerLivrosDuplicados() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final livrosSnapshot = await firestore.collection('livros').get();

  Map<String, String> livrosUnicos = {}; // título -> docId
  List<String> duplicados = [];

  for (var doc in livrosSnapshot.docs) {
    String titulo = doc['titulo'];

    if (livrosUnicos.containsKey(titulo)) {
      // Já existe, então este é duplicado
      duplicados.add(doc.id);
    } else {
      // Primeiro com esse título
      livrosUnicos[titulo] = doc.id;
    }
  }

  // Deleta os duplicados
  for (String docId in duplicados) {
    await firestore.collection('livros').doc(docId).delete();
    print('Deletado: $docId');
  }

  print("Remoção de duplicados concluída.");
}

class AdminUtils extends StatefulWidget {
  const AdminUtils({super.key});

  @override
  State<AdminUtils> createState() => _AdminUtilsState();
}

class _AdminUtilsState extends State<AdminUtils> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await adicionarLivrosTeste();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Livros adicionados!")),
                );
              },
              child: Text("Adicionar Livros de Teste"),
            ),
            
            ElevatedButton(onPressed: () => removerLivrosDuplicados(), child:
            Text("Remover livros duplicados")),
          ],
        ),
      ),
    );
  }
}


