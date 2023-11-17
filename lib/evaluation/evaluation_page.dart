// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'data.dart';
import 'evaluation.dart';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key});

  @override
  EvaluationPageState createState() => EvaluationPageState();
}

class EvaluationPageState extends State<EvaluationPage> {
  @override
  Widget build(BuildContext context) {
    var data = context.watch<Data>();
    var evaluations = data.getAulas();

    Future<void> _displayEvaluationPopUp(Evaluation e) async {
      final TextEditingController _comentarioController = TextEditingController();
      double _nota = 0;

      Icon _isFilled(int starNumber) {
        if (_nota >= starNumber) {
          return Icon(Icons.star);
        } else {
          return Icon(Icons.star_border);
        }
      }

      return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                title: Center(child: const Text('Avaliar aula')),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(DateFormat('dd/MM/yyyy').format(e.data)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(e.disciplina),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 20,
                              child: IconButton(
                                key: Key('star1'),
                                icon: _isFilled(1),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                visualDensity: VisualDensity(),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onPressed: (() {
                                  setState(() => _nota = 1);
                                }),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              child: IconButton(
                                key: Key('star2'),
                                icon: _isFilled(2),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                visualDensity: VisualDensity(),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (() {
                                  setState(() => _nota = 2);
                                }),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              child: IconButton(
                                key: Key('star3'),
                                icon: _isFilled(3),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                visualDensity: VisualDensity(),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (() {
                                  setState(() => _nota = 3);
                                }),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              child: IconButton(
                                key: Key('star4'),
                                icon: _isFilled(4),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                visualDensity: VisualDensity(),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (() {
                                  setState(() => _nota = 4);
                                }),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              child: IconButton(
                                key: Key('star5'),
                                icon: _isFilled(5),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                visualDensity: VisualDensity(),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (() {
                                  setState(() => _nota = 5);
                                }),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              child: IconButton(
                                key: Key('star6'),
                                icon: _isFilled(6),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                visualDensity: VisualDensity(),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (() {
                                  setState(() => _nota = 6);
                                }),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              child: IconButton(
                                key: Key('star7'),
                                icon: _isFilled(7),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                visualDensity: VisualDensity(),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (() {
                                  setState(() => _nota = 7);
                                }),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              child: IconButton(
                                key: Key('star8'),
                                icon: _isFilled(8),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                visualDensity: VisualDensity(),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (() {
                                  setState(() => _nota = 8);
                                }),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              child: IconButton(
                                key: Key('star9'),
                                icon: _isFilled(9),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                visualDensity: VisualDensity(),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (() {
                                  setState(() => _nota = 9);
                                }),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              child: IconButton(
                                key: Key('star10'),
                                icon: _isFilled(10),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                visualDensity: VisualDensity(),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (() {
                                  setState(() => _nota = 10);
                                }),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _nota.toString(),
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Comentário:'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: TextField(
                                controller: _comentarioController,
                                minLines: 1,
                                maxLines: 8,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: (() {
                                  if (_nota != 0) {
                                    data.updateEvaluation([_nota, _comentarioController.text], e);
                                    Navigator.of(context).pop();
                                    print('Enviado');
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Avaliação realizada!')),
                                    );
                                  }
                                }),
                                child: Text('Enviar'),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

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
                          for (var evaluation in evaluations)
                            Consumer<Data>(builder: (context, cart, child) {
                              return ListTile(
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
                                          Text(DateFormat('dd/MM/yyyy').format(evaluation.data),
                                              style: TextStyle(fontSize: 10)),
                                          Text(evaluation.disciplina,
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0)),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 18,
                                              ),
                                              Text(evaluation.nota.toStringAsFixed(1),
                                                  style: TextStyle(fontWeight: FontWeight.w700)),
                                            ],
                                          ),
                                          Text(
                                            "\"${evaluation.comentario}\"",
                                            style: TextStyle(fontSize: 12),
                                            softWrap: true,
                                          ),
                                        ],
                                      ),
                                    if (evaluation.evaluated == false && evaluation.evaluationAvailable == true)
                                      Column(
                                        children: [
                                          Text(DateFormat('dd/MM/yyyy').format(evaluation.data),
                                              style: TextStyle(fontSize: 10)),
                                          Text(evaluation.disciplina,
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0)),
                                          Text('Avaliação Disponível', style: TextStyle(color: Colors.green[300])),
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10.0)))),
                                              onPressed: (() {
                                                _displayEvaluationPopUp(evaluation);
                                              }),
                                              child: Text('Avaliar'))
                                        ],
                                      ),
                                    if (evaluation.evaluated == false && evaluation.evaluationAvailable == false)
                                      Column(
                                        children: [
                                          Text(DateFormat('dd/MM/yyyy').format(evaluation.data),
                                              style: TextStyle(fontSize: 10)),
                                          Text(evaluation.disciplina,
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0)),
                                          Text('Aluno ausente', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                          Text('Avaliação Indisponível', style: TextStyle(color: Colors.red[400])),
                                        ],
                                      ),
                                  ]),
                                ),
                              );
                            })
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
}
