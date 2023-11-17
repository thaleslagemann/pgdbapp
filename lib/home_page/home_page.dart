// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pgdbapp/evaluation/evaluation_page.dart';
import 'package:pgdbapp/login/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _customTileExpanded = false;
  int _permission = 0;

  String _permissionSelector() {
    switch (_permission) {
      case 0:
        return "Administrador";
      case 1:
        return "Aluno";
      case 2:
        return "Professor";
      default:
        return "Aluno";
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          Icons.person_2,
                          color: Colors.black,
                          size: 80,
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Column(
                          children: [
                            if (_auth.currentUser!.displayName == null)
                              Text('Olá, User!',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white)),
                            if (_auth.currentUser!.displayName != null)
                              Text('Olá, ${_auth.currentUser!.displayName}!',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white)),
                            Text('Logado como ${_permissionSelector()}',
                                style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
                            Text(_auth.currentUser!.email!,
                                style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
                            TextButton(
                              onPressed: (() {
                                Navigator.of(context).pop();
                                _auth.signOut();
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
                        if (_permission == 0 || _permission == 2)
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            leading: Icon(Icons.star_half_rounded, color: Colors.black87),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black87),
                            title: Text('Avaliação de aulas', style: TextStyle(color: Colors.black87)),
                            onTap: () {
                              setState(() {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EvaluationPage()));
                              });
                            },
                          ),
                        if (_permission == 0 || _permission == 2)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Divider(
                              thickness: 1,
                              color: Colors.black26,
                              height: 0,
                            ),
                          ),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          leading: Icon(Icons.school_rounded, color: Colors.black87),
                          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black87),
                          title: Text('Aulas Avaliadas', style: TextStyle(color: Colors.black87)),
                          onTap: () {
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EvaluationPage()));
                            });
                          },
                        ),
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
                          onExpansionChanged: (value) {
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
