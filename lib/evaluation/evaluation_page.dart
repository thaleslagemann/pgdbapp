// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/aula.dart';
import '../models/data.dart';
import '../models/evaluation.dart';
import '../models/usuario.dart';
import '../models/turma.dart';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key});

  @override
  EvaluationPageState createState() => EvaluationPageState();
}

class EvaluationPageState extends State<EvaluationPage> {
  @override
  Widget build(BuildContext context) {
    var data = context.watch<Data>();
    var evaluations = data.getAulasAvaliar();
    var turmas = data.getTurmas();
    bool _validate = true;
    final TextEditingController _codigoDisciplinaController = TextEditingController();
    final TextEditingController _numAulaController = TextEditingController();
    DateTime _date = DateTime.now();

    Future<DateTime?> _invokeDatePicker() async {
      return await showDatePicker(
          keyboardType: TextInputType.number,
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1989, 1, 1),
          lastDate: DateTime(2189, 1, 1));
    }

    Future<void> _displayClassInsertionDialog([String? cod]) async {
      if (cod != null) {
        _codigoDisciplinaController.text = cod;
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
                  title: Center(child: const Text('Nova Aula')),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Código da Disciplina:',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'ELC12345, MAT7654, ...',
                                hintStyle: TextStyle(
                                    fontStyle: FontStyle.italic, color: Colors.grey, fontWeight: FontWeight.w400),
                                errorText: _validate ? null : "Código Inexistente",
                              ),
                              textAlign: TextAlign.center,
                              controller: _codigoDisciplinaController,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [Text('Número da Aula:')],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: '1, 2, 3, ...',
                                hintStyle: TextStyle(
                                    fontStyle: FontStyle.italic, color: Colors.grey, fontWeight: FontWeight.w400),
                              ),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              controller: _numAulaController,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [Text('Data:')],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (DateFormat('dd/MM/yyyy').format(_date)),
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              iconSize: 24,
                              onPressed: (() async {
                                DateTime? selectedDate = await _invokeDatePicker();
                                setState(() {
                                  _date = selectedDate!;
                                });
                              }),
                              icon: Icon(Icons.calendar_month_outlined))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: (() {
                                setState(() {
                                  _validate = data.checkCodDisciplina(_codigoDisciplinaController.text);
                                  print(_validate);
                                  if (_validate) {
                                    data.addNewAula(Aula(
                                        id: data.findNextAulaId(0),
                                        disciplina: _codigoDisciplinaController.text,
                                        aula: int.parse(_numAulaController.text),
                                        data: _date));
                                    Navigator.of(context).pop();
                                  }
                                });
                              }),
                              child: Text('Enviar'),
                            )
                          ],
                        ),
                      ),
                    ],
                  ));
            },
          );
        },
      );
    }

    Widget? _insertClassButton() {
      if (data.getUsuarioPermission() != 1) {
        return FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple[300],
          onPressed: (() {
            _displayClassInsertionDialog();
          }),
          child: Icon(Icons.post_add, size: 30, color: Colors.white),
        );
      } else {
        return SizedBox();
      }
    }

    Future<void> _displayEvaluationDialog(Evaluation e) async {
      final TextEditingController _comentarioController = TextEditingController();
      double _nota = 0;

      Icon _isFilled(int starNumber) {
        if (_nota >= starNumber) {
          return Icon(Icons.star, color: Colors.yellow[700]);
        } else {
          return Icon(Icons.star_border, color: Colors.grey);
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
                            onPressed: (() async {
                              if (_nota != 0) {
                                await data.executeEvaluation([_nota, _comentarioController.text], e);
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
              );
            },
          );
        },
      );
    }

    Future<void> _displayTurmaDialog(Turma turma, List<Usuario> alunos) async {
      return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                title: Center(child: const Text('Turma')),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(turma.disciplina),
                    Text(data.getDisciplina(turma.disciplina)!.nome),
                    SizedBox(height: 15),
                    Text('Alunos'),
                    for (var aluno in alunos)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${aluno.matricula.toString()} ${aluno.nome}"),
                        ],
                      ),
                    SizedBox(height: 15),
                    ElevatedButton(
                        onPressed: () {
                          _displayClassInsertionDialog(turma.disciplina);
                        },
                        child: Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.post_add, size: 20, color: Colors.black),
                              Text('Nova Aula', style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            });
          });
    }

    return Scaffold(
      floatingActionButton: _insertClassButton(),
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
                          if (data.getUsuarioPermission()! == 1)
                            for (var evaluation in evaluations)
                              if (evaluation.matricula == data.getCurrentUsuario()!.matricula)
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
                                              Text("Aula ${evaluation.aula}",
                                                  style: TextStyle(
                                                      fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0)),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    size: 20,
                                                    color: Colors.yellow[700],
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
                                                    _displayEvaluationDialog(evaluation);
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
                                }),
                          if (data.getUsuarioPermission() == 2)
                            for (var turma in turmas)
                              if (turma.matProfessor == data.getCurrentUsuario()!.matricula)
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
                                        Column(
                                          children: [
                                            Text(turma.disciplina,
                                                style: TextStyle(
                                                    fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0)),
                                            Text(data.getDisciplina(turma.disciplina)!.nome,
                                                style: TextStyle(fontSize: 14))
                                          ],
                                        ),
                                      ]),
                                    ),
                                    onTap: () async {
                                      List<Usuario> alunos = await data.getAlunos(turma);

                                      setState(() {
                                        _displayTurmaDialog(turma, alunos);
                                      });
                                    },
                                  );
                                }),
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
