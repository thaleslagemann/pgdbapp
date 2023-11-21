// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unnecessary_null_comparison, no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pgdbapp/evaluation/evaluation_page.dart';
import 'package:pgdbapp/login/login_page.dart';
import 'package:pgdbapp/report/reporting_page.dart';
import 'package:provider/provider.dart';

import '../models/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _customTileExpanded = false;
  double media = 0;

  @override
  Widget build(BuildContext context) {
    var data = context.watch<Data>();

    String _permissionSelector() {
      if (data.usuarioLogado()) {
        switch (data.getCurrentUsuario()!.cargo) {
          case 0:
            return "Administrador";
          case 1:
            return "Aluno";
          case 2:
            return "Professor";
          default:
            return "Aluno";
        }
      } else {
        return 'null';
      }
    }

    // Future<void> _displayTurmaSelector() async {
    //   return showDialog(
    //       context: context,
    //       builder: (context) {
    //         return StatefulBuilder(builder: (context, setState) {
    //           return AlertDialog(
    //             backgroundColor: Colors.white,
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.all(Radius.circular(10)),
    //             ),
    //             contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
    //             title: Center(child: const Text('Selecionar turma')),
    //             content: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text(turma.disciplina),
    //                 Text(data.getDisciplina(turma.disciplina)!.nome),
    //                 SizedBox(height: 15),
    //                 Text('Alunos'),
    //                 for (var aluno in alunos)
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Text("${aluno.matricula.toString()} ${aluno.nome}"),
    //                     ],
    //                   ),
    //                 SizedBox(height: 15),
    //                 ElevatedButton(
    //                     onPressed: () {
    //                       _displayClassInsertionDialog(turma.disciplina);
    //                     },
    //                     child: Container(
    //                       width: 100,
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: const [
    //                           Icon(Icons.post_add, size: 20, color: Colors.black),
    //                           Text('Nova Aula', style: TextStyle(color: Colors.black)),
    //                         ],
    //                       ),
    //                     )),
    //               ],
    //             ),
    //           );
    //         });
    //       });
    // }

    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.black, Colors.black54, Colors.white]),
              ),
              height: MediaQuery.of(context).size.height / 2.5 - MediaQuery.of(context).padding.top,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.zero,
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(width: 6, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.black,
                          size: 80,
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Column(
                          children: [
                            if (!data.usuarioLogado())
                              Text('Olá, User!',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white)),
                            if (data.usuarioLogado())
                              Text('Olá, ${data.getCurrentUsuario()!.nome}!',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white)),
                            if (data.usuarioLogado())
                              Text('Logado como ${_permissionSelector()}',
                                  style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
                            if (data.usuarioLogado())
                              Text(_auth.currentUser!.email!,
                                  style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
                            TextButton(
                              onPressed: (() async {
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                await _auth.signOut();
                                data.clearEvaluations();
                                data.clearAulas();
                                data.clearTurmas();
                                data.userLogout();
                              }),
                              child:
                                  Text('Log out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black,
              thickness: 1,
            ),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        if (data.usuarioLogado())
                          if (data.getCurrentUsuario()!.cargo == 1)
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              leading: Icon(Icons.school_rounded, color: Colors.black87),
                              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black87),
                              title: Text("Aulas", style: TextStyle(color: Colors.black87)),
                              onTap: () async {
                                await data.getAvaliacoesDB().then((value) => print('getAvaliacoesDB ok'));
                                await data.getAulasDB().then((value) => print('getAulasDB ok'));
                                await data.getTurmasDB().then((value) => print('getTurmasDB ok'));
                                await data.getDisciplinasDB().then((value) => print('getDisciplinasDB ok'));
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EvaluationPage()));
                                });
                              },
                            ),
                        if (data.usuarioLogado())
                          if (data.getCurrentUsuario()!.cargo == 2)
                            ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                leading: Icon(Icons.school_rounded, color: Colors.black87),
                                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black87),
                                title: Text("Turmas", style: TextStyle(color: Colors.black87)),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EvaluationPage()));
                                }),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Divider(
                            thickness: 1,
                            color: Colors.black26,
                            height: 0,
                          ),
                        ),
                        ExpansionTile(
                          tilePadding: EdgeInsets.symmetric(horizontal: 10),
                          leading: Icon(
                            Icons.text_snippet_rounded,
                            color: Colors.black87,
                          ),
                          trailing: Icon(
                            _customTileExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: Colors.black87,
                          ),
                          iconColor: Colors.black,
                          textColor: Colors.black,
                          onExpansionChanged: (value) async {
                            if (media == 0 || media == null) {
                              media = await data.getMediaAvaliacoesAula("ELC1071", data.getCurrentUsuario()!.matricula);
                            }
                            setState(() {
                              _customTileExpanded = !_customTileExpanded;
                            });
                          },
                          shape: Border(bottom: BorderSide(color: Colors.white, width: 0)),
                          collapsedShape: Border(bottom: BorderSide(color: Colors.white, width: 0)),
                          title: Text('Relatórios', style: TextStyle(color: Colors.black87)),
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 30),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(color: Colors.black26, width: 1),
                                              top: BorderSide(color: Colors.black26, width: 1))),
                                      child: ListTile(
                                        title: Text(
                                          'Diários',
                                          style: TextStyle(fontSize: 16, color: Colors.black54),
                                          textAlign: TextAlign.start,
                                        ),
                                        onTap: () async {
                                          print(media);
                                          if (media != 0.0 && media != null) {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => ReportingPage(media: media)));
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 30),
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.black26, width: 1))),
                                      child: ListTile(
                                        title: Text(
                                          'Semanais',
                                          style: TextStyle(fontSize: 16, color: Colors.black54),
                                          textAlign: TextAlign.start,
                                        ),
                                        onTap: () {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 30),
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.black26, width: 1))),
                                      child: ListTile(
                                        title: Text(
                                          'Mensais',
                                          style: TextStyle(fontSize: 16, color: Colors.black54),
                                          textAlign: TextAlign.start,
                                        ),
                                        onTap: () {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 30),
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.black26, width: 1))),
                                      child: ListTile(
                                        title: Text(
                                          'Anuais',
                                          style: TextStyle(fontSize: 16, color: Colors.black54),
                                          textAlign: TextAlign.start,
                                        ),
                                        onTap: () {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Divider(
                            thickness: 1,
                            color: _customTileExpanded ? Color.fromRGBO(0, 0, 0, 0) : Colors.black26,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ]),
    ));
  }
}
