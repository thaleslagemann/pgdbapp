// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pgdbapp/home/home_page.dart';
import 'package:pgdbapp/models/data.dart';
import 'package:pgdbapp/models/usuario.dart';
import 'package:provider/provider.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  RegisterUserScreenState createState() => RegisterUserScreenState();
}

class RegisterUserScreenState extends State<RegisterUserScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _matriculaController = TextEditingController();

  List<String> permissionChoices = ["Adminitrador", "Aluno", "Professor"];
  var _userType = 0;

  @override
  Widget build(BuildContext context) {
    var data = context.watch<Data>();

    void taskChoiceAction(String choice) {
      switch (choice) {
        case "Administrador":
          _userType = 0;
          break;
        case "Aluno":
          _userType = 1;
          break;
        case "Professor":
          _userType = 2;
          break;
      }
    }

    Future<void> _registerUser() async {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await data.addNewUsuario(Usuario(
          id: data.findNextUsuarioId(0),
          matricula: int.parse(_matriculaController.text),
          email: _emailController.text,
          nome: _nomeController.text,
          cargo: _userType));
      await data.setUser();
      data.getAvaliacoesDB();
      if (mounted && data.usuarioLogado()) {
        setState(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        });
      }
    }

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
                          controller: _nomeController,
                          decoration: const InputDecoration(labelText: 'Nome'),
                        ),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'E-mail'),
                        ),
                        TextField(
                          controller: _matriculaController,
                          decoration: const InputDecoration(labelText: 'Matrícula'),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(labelText: 'Senha'),
                          obscureText: true,
                        ),
                        Row(
                          children: [
                            Text(permissionChoices[_userType]),
                            PopupMenuButton<String>(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              icon: Icon(Icons.arrow_drop_down_sharp, color: Colors.black),
                              itemBuilder: (BuildContext context) {
                                return permissionChoices.map((String choice) {
                                  return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                      onTap: () => {
                                            setState(() {
                                              taskChoiceAction(choice);
                                            })
                                          });
                                }).toList();
                              },
                            ),
                          ],
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
}
