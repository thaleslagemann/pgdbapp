// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _customTileExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black, Colors.black54, Colors.white]),
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
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(width: 8, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Colors.white,
                        ),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 80,
                            ),
                          ],
                        )),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text('Hello, User!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          leading: Icon(Icons.menu_book, color: Colors.black87),
                          title: Text('Aulas Avaliadas', style: TextStyle(color: Colors.black87)),
                        ),
                        Divider(),
                        ExpansionTile(
                          leading: Icon(
                            Icons.menu_book,
                            color: Colors.black87,
                          ),
                          trailing: Icon(
                            _customTileExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                          iconColor: Colors.black,
                          textColor: Colors.black,
                          onExpansionChanged: (value) {
                            setState(() {
                              _customTileExpanded = !_customTileExpanded;
                            });
                          },
                          shape: Border.all(width: 0, color: Colors.white),
                          title: Text('Relatórios', style: TextStyle(color: Colors.black87)),
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextButton(
                                        onPressed: () => {},
                                        child: Text(
                                          '> Diários',
                                          style: TextStyle(fontSize: 16, color: Colors.black54),
                                          textAlign: TextAlign.start,
                                        )),
                                    TextButton(
                                        onPressed: () => {},
                                        child: Text(
                                          '> Semanais',
                                          style: TextStyle(fontSize: 16, color: Colors.black54),
                                          textAlign: TextAlign.start,
                                        )),
                                    TextButton(
                                        onPressed: () => {},
                                        child: Text(
                                          '> Mensais',
                                          style: TextStyle(fontSize: 16, color: Colors.black54),
                                          textAlign: TextAlign.start,
                                        )),
                                    TextButton(
                                        onPressed: () => {},
                                        child: Text(
                                          '> Anuais',
                                          style: TextStyle(fontSize: 16, color: Colors.black54),
                                          textAlign: TextAlign.start,
                                        )),
                                  ],
                                ))
                          ],
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
