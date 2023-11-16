import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  RegisterUserScreenState createState() => RegisterUserScreenState();
}

class RegisterUserScreenState extends State<RegisterUserScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black, Colors.white]),
          ),
          child: Stack(children: [
            Row(children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: (() {
                      Navigator.of(context).pop();
                    }),
                  )),
            ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Registro',
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
                        TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(labelText: 'Senha'),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _registerUser(),
                          child: const Text('Registrar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('Usuário registrado: ${userCredential.user!.uid}');
    } catch (e) {
      print('Erro no registro: $e');
    }
  }
}
