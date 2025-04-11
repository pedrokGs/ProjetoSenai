import 'package:biblioteca/Paginas/detalhesAudiobook.dart';
import 'package:biblioteca/Paginas/homePage.dart';
import 'package:biblioteca/Paginas/detalhesLivro.dart';
import 'package:biblioteca/Paginas/meusDados.dart';
import 'package:biblioteca/Paginas/paginaCategoria.dart';
import 'package:biblioteca/Paginas/perfil.dart';
import 'package:biblioteca/Paginas/perguntasFrequentes.dart';
import 'package:biblioteca/Paginas/pesquisa_Categoria.dart';
import 'package:biblioteca/Paginas/pesquisar.dart';
import 'package:biblioteca/Usuario/loginCadastro.dart';
import 'package:biblioteca/Paginas/telainicio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app_colors.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(), // Transição do iOS no Android
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(), // Transição padrão do iOS
            TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          },
        ),
        inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(fontSize: 14, color:AppColors.primary)
        ),
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 20),
          bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ),
      home: telaInicio(),
      routes: <String, WidgetBuilder> {
        '/loginCadastro': (BuildContext context) => const loginCadastro(),
        '/home': (BuildContext context) => HomePage(),
        '/detalhesLivro': (BuildContext context) => DetalhesLivro(),
        '/detalhesAudiobook': (BuildContext context) => DetalhesAudiobook(),
        '/pesquisar' : (BuildContext context) => Pesquisar(),
        '/pesquisaCategoria' : (BuildContext context) => PesquisaCategoria(),
        '/paginaCategoria' : (BuildContext context) => PaginaCategoria(),
        '/perfil' : (BuildContext context) => PerfilPage(),
        '/meusDados': (BuildContext context) => MeusDadosPage(),
        '/perguntasFrequentes' : (BuildContext context) => FAQPage(),
      },
    );
  }
}