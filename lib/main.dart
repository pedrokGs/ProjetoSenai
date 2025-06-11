import 'package:biblioteca/Paginas/chat_room.dart';
import 'package:biblioteca/Paginas/chat_room_selector.dart';
import 'package:biblioteca/Paginas/detalhesAudiobook.dart';
import 'package:biblioteca/Paginas/homePage.dart';
import 'package:biblioteca/Paginas/detalhesLivro.dart';
import 'package:biblioteca/Paginas/kidsPage.dart';
import 'package:biblioteca/Paginas/meus_dados.dart';
import 'package:biblioteca/Paginas/ofensiva_main_page.dart';
import 'package:biblioteca/Paginas/ofensiva_start_page.dart';
import 'package:biblioteca/Paginas/ouvirAudiobook.dart';
import 'package:biblioteca/Paginas/paginaCategoria.dart';
import 'package:biblioteca/Paginas/perfil.dart';
import 'package:biblioteca/Paginas/perguntasFrequentes.dart';
import 'package:biblioteca/Paginas/pesquisa_Categoria.dart';
import 'package:biblioteca/Paginas/pesquisar.dart';
import 'package:biblioteca/Usuario/loginCadastro.dart';
import 'package:biblioteca/Paginas/telainicio.dart';
import 'package:biblioteca/admin/AdminUtils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'ThemeProvider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme.copyWith(pageTransitionsTheme: PageTransitionsTheme(
        builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()},
      ),),
      home: telaInicio(),
      routes: <String, WidgetBuilder>{
        '/loginCadastro': (BuildContext context) => const loginCadastro(),
        '/home': (BuildContext context) => HomePage(),
        '/detalhesLivro': (BuildContext context) => DetalhesLivro(),
        '/detalhesAudiobook': (BuildContext context) => DetalhesAudiobook(),
        '/pesquisar': (BuildContext context) => Pesquisar(),
        '/pesquisaCategoria': (BuildContext context) => PesquisaCategoria(),
        '/paginaCategoria': (BuildContext context) => PaginaCategoria(),
        '/perfil': (BuildContext context) => PerfilPage(),
        '/meusDados': (BuildContext context) => MeusDadosPage(),
        '/perguntasFrequentes': (BuildContext context) => FAQPage(),
        '/kids': (BuildContext context) => HomePageKids(),
        '/ouvirAudiobook': (BuildContext context) => AudiobookPlayer(),
        '/chatroom': (BuildContext context) => ChatRoomSelector(),
        '/ofensiva': (BuildContext context) => OfensivaStartPage(),
        '/ofensivamainpage': (BuildContext context) => OfensivaMainPage(),
      },
    );
  }
}
