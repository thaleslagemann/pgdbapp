// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pgdbapp/evaluation/evaluation_form.dart';
import 'evaluation.dart';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key});

  @override
  EvaluationPageState createState() => EvaluationPageState();
}

class EvaluationPageState extends State<EvaluationPage> {
  List<Evaluation> aulasAvaliadas = [
    Evaluation(1, 201821179, 'ELC1071', 01, DateTime(2023, 1, 1), 10.0, 'boa aula do professor', true),
    Evaluation(2, 201821179, 'EDE1131', 02, DateTime(2023, 1, 1), 0.0, '', false),
    Evaluation(3, 201821179, 'ELC137', 03, DateTime(2023, 1, 1), 8.0, 'boa aula da professora', true),
    Evaluation(4, 201821179, 'MAT1123', 04, DateTime(2023, 1, 1), 9.0, 'boa aula da professora', true),
    Evaluation(5, 201821179, 'DPADI0185', 05, DateTime(2023, 1, 1), 10.0, 'boa aula da professora', true),
    Evaluation(6, 201821179, 'DPADI0155', 05, DateTime(2023, 1, 2), 2.0, 'uma bosta', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aulas',
          style: TextStyle(color: Colors.white),
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
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(height: 15),
                          for (var evaluation in aulasAvaliadas)
                            ListTile(
                              title: Container(
                                margin: EdgeInsets.symmetric(horizontal: 60),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  //border: Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: Offset(0, 4), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(children: [
                                  if (evaluation.evaluated == true)
                                    Column(
                                      children: [
                                        Text(DateFormat('dd/MM/yyyy').format(evaluation.data)),
                                        Text(evaluation.disciplina),
                                        Text(evaluation.nota.toStringAsFixed(2)),
                                        Text("\"${evaluation.comentario}\"", style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  if (evaluation.evaluated == false)
                                    Column(
                                      children: [
                                        Text(DateFormat('dd/MM/yyyy').format(evaluation.data)),
                                        Text(evaluation.disciplina),
                                        Text('Avaliação Disponível'),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))),
                                            onPressed: (() {
                                                  setState(() {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => EvaluationForm(
                                                                  evaluation: evaluation,
                                                                )));
                                                  });
                                                }),
                                                child: Text('Avaliar'))
                                      ],
                                    ),
                                ]),
                              ),
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ]),
    );
  }

  int getEvaluationIndex(Evaluation evaluation) {
    print(aulasAvaliadas.indexWhere((x) => x.id == evaluation.id));
    return aulasAvaliadas.indexWhere((x) => x.id == evaluation.id);
  }
}
