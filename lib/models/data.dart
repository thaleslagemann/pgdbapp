// ignore_for_file: prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'disciplina.dart';
import 'aula.dart';
import 'evaluation.dart';
import 'turma.dart';

class Data extends ChangeNotifier {
  List<Disciplina> _disciplinas = [
    Disciplina(codigo: 'ELC1071', nome: 'PROJETO E GERÊNCIA DE BANCO DE DADOS'),
    Disciplina(codigo: 'ELC137', nome: 'SISTEMAS DE INFORMACAO DISTRIBUIDOS "A"'),
    Disciplina(codigo: 'ELC1088', nome: 'IMPLEMENTAÇÃO DE LINGUAGENS DE PROGRAMAÇÃO'),
    Disciplina(codigo: 'DPADI0185', nome: 'SISTEMAS OPERACIONAIS'),
    Disciplina(codigo: 'EDE1131', nome: 'LIBRAS: BACHARELADO'),
  ];

  List<Turma> _turmas = [];

  List<Aula> _aulas = [];

  List<Evaluation> _aulasAvaliar = [
    Evaluation(1, 201821179, 'ELC1071', 01, DateTime(2023, 1, 1), 10.0, 'boa aula do professor', true, false),
    Evaluation(2, 201821179, 'EDE1131', 02, DateTime(2023, 1, 1), 0.0, '', false, true),
    Evaluation(3, 201821179, 'ELC137', 03, DateTime(2023, 1, 1), 8.0, 'boa aula da professora', true, false),
    Evaluation(4, 201821179, 'MAT1123', 04, DateTime(2023, 1, 1), 9.0, 'boa aula da professora', true, false),
    Evaluation(5, 201821179, 'DPADI0185', 05, DateTime(2023, 1, 1), 10.0, 'boa aula da professora', true, false),
    Evaluation(6, 201821179, 'DPADI0155', 05, DateTime(2023, 1, 2), 2.0, 'uma bosta', true, false),
    Evaluation(7, 201821179, 'ELC5561', 02, DateTime(2022, 10, 12), 0.0, '', false, false),
  ];

  int _permission = 1;

  int getUserPermission() {
    return _permission;
  }

  int getEvaluationIndex(Evaluation evaluation) {
    print(_aulasAvaliar.indexWhere((x) => x.id == evaluation.id));
    return _aulasAvaliar.indexWhere((x) => x.id == evaluation.id);
  }

  List<Evaluation> getAulas() {
    return _aulasAvaliar;
  }

  void addTurma(Turma turma) {
    _turmas.add(turma);
  }

  void removeTurma(int index) {
    _turmas.removeAt(index);
  }

  bool containsTurma(elementToCheck) {
    List<dynamic> list = _turmas;
    for (var element in list) {
      if (element.id == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  int findNextTurmaId(int id) {
    if (containsTurma(id)) {
      id = id + 1;
      findNextTurmaId(id);
    }
    return id;
  }

  void addDisciplina(Disciplina disciplina) {
    _disciplinas.add(disciplina);
  }

  void removeDisciplina(int index) {
    _disciplinas.removeAt(index);
  }

  bool containsDisciplina(elementToCheck) {
    List<dynamic> list = _disciplinas;
    for (var element in list) {
      if (element.id == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  int findNextDisciplinaId(int id) {
    if (containsDisciplina(id)) {
      id = id + 1;
      findNextDisciplinaId(id);
    }
    return id;
  }

  void addAula(Aula aula) {
    _aulas.add(aula);
  }

  void removeAula(int index) {
    _aulas.removeAt(index);
  }

  bool containsAula(elementToCheck) {
    List<dynamic> list = _aulas;
    for (var element in list) {
      if (element.id == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  int findNextAulaId(int id) {
    if (containsAula(id)) {
      id = id + 1;
      findNextAulaId(id);
    }
    return id;
  }

  void addEvaluation(Evaluation aula) {
    _aulasAvaliar.add(aula);
  }

  void removeEvaluation(int index) {
    _aulasAvaliar.removeAt(index);
  }

  bool containsEvaluation(elementToCheck) {
    List<dynamic> list = _aulasAvaliar;
    for (var element in list) {
      if (element.id == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  int findNextEvaluationId(int id) {
    if (containsEvaluation(id)) {
      id = id + 1;
      findNextEvaluationId(id);
    }
    return id;
  }

  void executeEvaluation(List<dynamic> result, Evaluation e) {
    _aulasAvaliar[getEvaluationIndex(e)].nota = result[0];
    _aulasAvaliar[getEvaluationIndex(e)].comentario = result[1];
    _aulasAvaliar[getEvaluationIndex(e)].evaluated = true;
    print('${_aulasAvaliar[getEvaluationIndex(e)].nota} ${_aulasAvaliar[getEvaluationIndex(e)].comentario}');
    notifyListeners();
  }
}
