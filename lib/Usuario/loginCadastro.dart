import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../FirebaseAuthService.dart';
import '../FirestoreService.dart';

class loginCadastro extends StatefulWidget {
  const loginCadastro({super.key});

  @override
  State<loginCadastro> createState() => _loginCadastroState();
}

class _loginCadastroState extends State<loginCadastro> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();
  String _tipo = "login";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('tipo')) {
      setState(() {
        _tipo = args['tipo'] as String;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    UserCredential? userCredential = await _authService.signInWithGoogle();
    if (userCredential != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ocorreu um erro ao fazer login com o Google.")));
    }
  }

  late final TextEditingController _nomeController =
  new TextEditingController();
  late final TextEditingController _emailController =
  new TextEditingController();
  late final TextEditingController _senhaController =
  new TextEditingController();
  String _idioma = "";
  bool termos = false;
  final nome = "";
  final senha = "";
  final email = "";

  final _formKey = GlobalKey<FormState>();

  Future<void> _signInWithEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential;
        if (_tipo == 'cadastro') {
          userCredential = await _authService.createUserWithEmailAndPassword(
              _emailController.text, _senhaController.text);
          await _firestoreService.addUser(
              userCredential.user!.uid, {'email': _emailController.text, 'nome': _nomeController.text, 'idioma': _idioma});
              print("Cadastro Bem sucedido!");
        } else {
          userCredential = await _authService.signInWithEmailAndPassword(
              _emailController.text, _senhaController.text);
              print("Login Bem sucedido!");
        }
        print("Navegando até a rota main");
        Navigator.pushNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message ?? "Ocorreu um erro inesperado")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfef3ea),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFFedc9af),
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.85,
          padding: EdgeInsets.all(30),
          margin: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: Text(
                    _tipo == 'login' ? 'Login' : 'Cadastro',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                  ),
                ),
                _tipo == 'cadastro'
                    ? Container(
                  margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
                  child: Column(
                    children: [
                      Text(
                        "Nome",
                        style: TextStyle(fontSize: 28),
                        textDirection: TextDirection.ltr,
                      ),
                      TextFormField(
                        controller: _nomeController,
                        decoration: InputDecoration(
                          hintText: "Qual o seu nome?",
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu nome';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                )
                    : Container(),

                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
                  child: Column(
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(fontSize: 28),
                        textDirection: TextDirection.ltr,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Qual seu email?",
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Por favor, insira um email válido';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
                  child: Column(
                    children: [
                      Text(
                        "Senha",
                        style: TextStyle(fontSize: 28),
                        textDirection: TextDirection.ltr,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _senhaController,
                        decoration: InputDecoration(
                          hintText: "Qual sua senha?",
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua senha';
                          }
                          if (value.length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                _tipo == 'cadastro'
                    ? Container(
                  child: Column(
                    children: [
                      Text(
                        "Idioma",
                        style: TextStyle(fontSize: 28),
                        textDirection: TextDirection.ltr,
                      ),
                      DropdownButtonFormField<String>(
                        items:
                        <String>['Português', 'Inglês', 'Espanhol'].map(
                              (String _idioma) {
                            return DropdownMenuItem<String>(
                              value: _idioma,
                              child: Text(_idioma),
                            );
                          },
                        ).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _idioma =
                            newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Qual seu idioma?",
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                )
                    : Container(),

                _tipo == 'cadastro'
                    ? Row(
                  children: [
                    Checkbox(
                      value: termos,
                      onChanged: (value) {
                        setState(() {
                          termos = value!;
                        });
                      },
                    ),
                    Text("Eu aceito os Termos e Contrato"),
                  ],
                )
                    : Container(),

                _tipo == 'cadastro'
                    ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor:
                      Theme.of(context).colorScheme.primary,
                      padding: EdgeInsets.all(10),
                    ),
                    onPressed: () async {
                      if (!termos) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Por favor, aceite os termos e condições")));
                        return;
                      }
                      await _signInWithEmail();
                      /*
                      UserCredential userCredential = await _authService
                          .createUserWithEmailAndPassword(_emailController.text, _senhaController.text);
                      await _firestoreService.addUser(
                        userCredential.user!.uid,
                          {'nome': _nomeController.text, 'email': _emailController.text, 'senha': _senhaController.text, 'idioma': _idioma});
                    */
                    },
                    child: Text(
                      'Cadastro',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                )
                    : SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor:
                      Theme.of(context).colorScheme.primary,
                      padding: EdgeInsets.all(10),
                    ),
                    onPressed: () async {
                      await _signInWithEmail();
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height:20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: _signInWithGoogle,
                  child: Row(
                    children: [
                      Image.network(
                        'http://pngimg.com/uploads/google/google_PNG19635.png',
                        fit: BoxFit.cover,
                        height: 35,
                        width: 35,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Entrar com Google",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
