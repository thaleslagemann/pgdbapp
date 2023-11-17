// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'evaluation_page.dart';
import 'evaluation.dart';

class EvaluationForm extends StatefulWidget {
  const EvaluationForm({super.key, required this.evaluation});
  final Evaluation evaluation;

  @override
  EvaluationFormState createState() => EvaluationFormState();
}

class EvaluationFormState extends State<EvaluationForm> {
  final EvaluationPageState evaluationPage = EvaluationPageState();
  final TextEditingController _comentarioController = TextEditingController();
  double _nota = 0;

  Icon _isFilled(int starNumber) {
    if (_nota >= starNumber) {
      return Icon(Icons.star);
    } else {
      return Icon(Icons.star_border);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black, Colors.white]),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: (() => Navigator.of(context).pop()),
                        icon: const Icon(Icons.arrow_back, color: Colors.white)),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(DateFormat('dd/MM/yyyy').format(widget.evaluation.data)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.evaluation.disciplina),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 25,
                                  child: IconButton(
                                    key: Key('star1'),
                                    icon: _isFilled(1),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    onPressed: (() {
                                      setState(() => _nota = 1);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                  child: IconButton(
                                    key: Key('star2'),
                                    icon: _isFilled(2),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: (() {
                                      setState(() => _nota = 2);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                  child: IconButton(
                                    key: Key('star3'),
                                    icon: _isFilled(3),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: (() {
                                      setState(() => _nota = 3);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                  child: IconButton(
                                    key: Key('star4'),
                                    icon: _isFilled(4),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: (() {
                                      setState(() => _nota = 4);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                  child: IconButton(
                                    key: Key('star5'),
                                    icon: _isFilled(5),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: (() {
                                      setState(() => _nota = 5);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                  child: IconButton(
                                    key: Key('star6'),
                                    icon: _isFilled(6),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: (() {
                                      setState(() => _nota = 6);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                  child: IconButton(
                                    key: Key('star7'),
                                    icon: _isFilled(7),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: (() {
                                      setState(() => _nota = 7);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                  child: IconButton(
                                    key: Key('star8'),
                                    icon: _isFilled(8),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: (() {
                                      setState(() => _nota = 8);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                  child: IconButton(
                                    key: Key('star9'),
                                    icon: _isFilled(9),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: (() {
                                      setState(() => _nota = 9);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                  child: IconButton(
                                    key: Key('star10'),
                                    icon: _isFilled(10),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: (() {
                                      setState(() => _nota = 10);
                                    }),
                                  ),
                                ),
                              ],
                            ),
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
                                    if(_nota != 0) {
                                      setState(() {
                                        setFormResults(widget.evaluation);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const EvaluationPage()), // Substitua HomeScreen() pela tela desejada
                                        );
                                        print('Enviado');
                                      });
                                    }
                                  }),
                                  child: Text('Enviar'),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void setFormResults(Evaluation e) {
    int index = evaluationPage.getEvaluationIndex(e);

    Evaluation newEvaluation = Evaluation(e.id, e.matricula, e.disciplina, e.aula, e.data, _nota, _comentarioController.text, true);
    evaluationPage.aulasAvaliadas[index] = newEvaluation;
  }
}