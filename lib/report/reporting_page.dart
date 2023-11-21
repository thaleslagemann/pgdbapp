// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:pgdbapp/models/disciplina.dart';
import 'package:provider/provider.dart';
import '../models/data.dart';
import 'report.dart';

class ReportingPage extends StatefulWidget {
  const ReportingPage({super.key, required this.media, required this.disciplina});

  final double media;
  final String disciplina;

  @override
  ReportingPageState createState() => ReportingPageState();
}

class ReportingPageState extends State<ReportingPage> {
  List<Report> relatorios = [
    Report('ELC1071', DateTime(2023, 1, 1), 5.0),
    Report('EDE1131', DateTime(2023, 1, 1), 0.0),
    Report('ELC137', DateTime(2023, 1, 1), 8.0),
    Report('MAT1123', DateTime(2023, 1, 1), 9.0),
    Report('DPADI0185', DateTime(2023, 1, 1), 10.0),
  ];

  @override
  Widget build(BuildContext context) {
    var data = context.watch<Data>();
    var media = widget.media;
    //double media = calcularMediaMensal(relatorios, 2023, 1);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Relatório',
              style: TextStyle(color: Colors.white),
            ),
            Text(widget.disciplina),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Colors.black, Colors.black87, Colors.white]),
            ),
          ),
        ),
      ),
      body: Column(children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Text('Relatório', style: TextStyle(fontSize: 18.0)),
              Divider(
                height: 0,
                color: Colors.black54,
                thickness: 0.5,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 300, 0),
                child: Text('A média é:'),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 60),
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2.0),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${media.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 300, 0),
                child: Text('A aula está:'),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 60, 0, 60),
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2.0),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(media > 7.0 ? 'Healthy' : 'Sick',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                )))),
                  )),
            ]),
      ]),
    );
  }
}
