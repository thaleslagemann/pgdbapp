import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pgdbapp/register/register_page.dart';
import 'package:provider/provider.dart';
import '../home/home_page.dart';
import '../models/data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _hidePass = true;

  @override
  Widget build(BuildContext context) {
    var data = context.watch<Data>();
    Future<void> _loginUser(BuildContext context) async {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await data.setUser();
      data.getAvaliacoesDB();
      if (mounted && data.usuarioLogado()) {
        setState(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()), // Substitua HomeScreen() pela tela desejada
          );
        });
      }
      print('Usuário logado: ${userCredential.user!.uid}');
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black, Colors.white]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Log In',
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800))),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'E-mail'),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: TextField(
                                controller: _passwordController,
                                decoration: const InputDecoration(labelText: 'Senha'),
                                obscureText: _hidePass,
                                onSubmitted: ((value) {
                                  _loginUser(context);
                                })),
                          ),
                          IconButton(
                              icon: const Icon(Icons.remove_red_eye_outlined),
                              onPressed: () => setState(() {
                                    _hidePass = !_hidePass;
                                  }))
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _loginUser(context),
                        child: const Text('Login'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Não possui uma conta?'),
                          TextButton(
                              onPressed: (() {
                                setState(() {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => const RegisterUserScreen()));
                                });
                              }),
                              child: const Text('Registrar', style: TextStyle(color: Colors.deepPurple))),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
