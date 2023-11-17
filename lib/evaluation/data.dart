// ignore_for_file: prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'evaluation.dart';

class Data extends ChangeNotifier {
  List<Evaluation> _aulas = [
    Evaluation(1, 201821179, 'ELC1071', 01, DateTime(2023, 1, 1), 10.0, 'boa aula do professor', true, false),
    Evaluation(2, 201821179, 'EDE1131', 02, DateTime(2023, 1, 1), 0.0, '', false, true),
    Evaluation(3, 201821179, 'ELC137', 03, DateTime(2023, 1, 1), 8.0, 'boa aula da professora', true, false),
    Evaluation(4, 201821179, 'MAT1123', 04, DateTime(2023, 1, 1), 9.0, 'boa aula da professora', true, false),
    Evaluation(5, 201821179, 'DPADI0185', 05, DateTime(2023, 1, 1), 10.0, 'boa aula da professora', true, false),
    Evaluation(6, 201821179, 'DPADI0155', 05, DateTime(2023, 1, 2), 2.0, 'uma bosta', true, false),
    Evaluation(7, 201821179, 'ELC5561', 02, DateTime(2022, 10, 12), 0.0, '', false, false),
  ];

  int getEvaluationIndex(Evaluation evaluation) {
    print(_aulas.indexWhere((x) => x.id == evaluation.id));
    return _aulas.indexWhere((x) => x.id == evaluation.id);
  }

  List<Evaluation> getAulas() {
    return _aulas;
  }

  void addAula(Evaluation aula) {
    _aulas.add(aula);
  }

  void removeAula(int index) {
    _aulas.removeAt(index);
  }

  void updateEvaluation(List<dynamic> result, Evaluation e) {
    _aulas[getEvaluationIndex(e)].nota = result[0];
    _aulas[getEvaluationIndex(e)].comentario = result[1];
    _aulas[getEvaluationIndex(e)].evaluated = true;
    print('${_aulas[getEvaluationIndex(e)].nota} ${_aulas[getEvaluationIndex(e)].comentario}');
    notifyListeners();
  }
}
