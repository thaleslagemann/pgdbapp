// ignore_for_file: prefer_final_fields, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'disciplina.dart';
import 'aula.dart';
import 'evaluation.dart';
import 'turma.dart';
import 'usuario.dart';

class Data extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Usuario> _usuarios = [
    Usuario(
      id: 1,
      matricula: 201821179,
      email: 'thalesalaugustol@gmail.com',
      nome: 'Thales Lagemann',
      cargo: 1,
    ),
    Usuario(
      id: 2,
      matricula: 123456789,
      email: 'admin@admin.com',
      nome: 'Admin',
      cargo: 0,
    ),
    Usuario(
      id: 3,
      matricula: 19891989,
      email: 'professor@professor.com',
      nome: 'Prof',
      cargo: 2,
    ),
  ];

  List<Disciplina> _disciplinas = [
    Disciplina(codigo: 'ELC1071', nome: 'PROJETO E GERÊNCIA DE BANCO DE DADOS'),
    Disciplina(codigo: 'ELC137', nome: 'SISTEMAS DE INFORMACAO DISTRIBUIDOS "A"'),
    Disciplina(codigo: 'ELC1088', nome: 'IMPLEMENTAÇÃO DE LINGUAGENS DE PROGRAMAÇÃO'),
    Disciplina(codigo: 'DPADI0185', nome: 'SISTEMAS OPERACIONAIS'),
    Disciplina(codigo: 'EDE1131', nome: 'LIBRAS: BACHARELADO'),
  ];

  List<Turma> _turmas = [
    Turma(id: 1, disciplina: 'ELC1071', matProfessor: 123456789, matAlunos: [201821179, 123456789, 000000000])
  ];

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

  late int _permission;

  int getUsuarioPermission() {
    for (var usuario in _usuarios) {
      if (_auth.currentUser!.email == usuario.email) {
        _permission = usuario.cargo;
      }
    }
    return _permission;
  }

  void createEvaluationForStudents(Aula aula) {
    for (var turma in _turmas) {
      if (turma.disciplina == aula.disciplina) {
        for (var aluno in turma.matAlunos) {
          addEvaluation(
              Evaluation(findNextEvaluationId(0), aluno, aula.disciplina, aula.aula, aula.data, 0.0, '', false, true));
        }
      }
    }
    notifyListeners();
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
    notifyListeners();
  }

  void removeTurma(int index) {
    _turmas.removeAt(index);
    notifyListeners();
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
    notifyListeners();
  }

  void removeDisciplina(int index) {
    _disciplinas.removeAt(index);
    notifyListeners();
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

  bool checkCodDisciplina(String cod) {
    for (var disc in _disciplinas) {
      if (disc.codigo == cod) {
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
    createEvaluationForStudents(aula);
    notifyListeners();
  }

  void removeAula(int index) {
    _aulas.removeAt(index);
    notifyListeners();
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
