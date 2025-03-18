import 'package:biblioteca/Paginas/homePage.dart';
import 'package:biblioteca/Usuario/loginCadastro.dart';
import 'package:biblioteca/Paginas/telainicio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


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
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff65350f))
      ),
      home: telaInicio(),
      routes: <String, WidgetBuilder> {
        '/loginCadastro': (BuildContext context) => const loginCadastro(),
        '/home': (BuildContext context) => const HomePage(),
      },
    );
  }
}
