// ignore_for_file: prefer_final_fields, avoid_print

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'disciplina.dart';
import 'aula.dart';
import 'evaluation.dart';
import 'turma.dart';
import 'usuario.dart';

class Data extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Usuario? _usuario;
  bool _usuarioLogado = false;

  List<Disciplina> _disciplinas = [
    Disciplina(codigo: 'ELC1071', nome: 'PROJETO E GERÊNCIA DE BANCO DE DADOS'),
    Disciplina(codigo: 'ELC137', nome: 'SISTEMAS DE INFORMACAO DISTRIBUIDOS "A"'),
    Disciplina(codigo: 'ELC1088', nome: 'IMPLEMENTAÇÃO DE LINGUAGENS DE PROGRAMAÇÃO'),
    Disciplina(codigo: 'DPADI0185', nome: 'SISTEMAS OPERACIONAIS'),
    Disciplina(codigo: 'EDE1131', nome: 'LIBRAS: BACHARELADO'),
  ];

  List<Turma> _turmas = [
    Turma(
        id: 1, disciplina: 'ELC1071', matProfessor: 123456789, matAlunos: [201821179, 123456789, 000000000, 201811779])
  ];

  List<Aula> _aulas = [];

  List<Evaluation> _aulasAvaliar = [
    // Evaluation(1, 201811779, 'ELC1071', 01, DateTime(2023, 1, 1), 10.0, 'boa aula do professor', true, false),
    // Evaluation(2, 201811779, 'EDE1131', 02, DateTime(2023, 1, 1), 0.0, '', false, true),
    // Evaluation(3, 201811779, 'ELC137', 03, DateTime(2023, 1, 1), 8.0, 'boa aula da professora', true, false),
    // Evaluation(4, 201811779, 'MAT1123', 04, DateTime(2023, 1, 1), 9.0, 'boa aula da professora', true, false),
    // Evaluation(5, 201811779, 'DPADI0185', 05, DateTime(2023, 1, 1), 10.0, 'boa aula da professora', true, false),
    // Evaluation(6, 201811779, 'DPADI0155', 05, DateTime(2023, 1, 2), 2.0, 'uma bosta', true, false),
    // Evaluation(7, 201811779, 'ELC5561', 02, DateTime(2022, 10, 12), 0.0, '', false, false),
  ];

  Future<void> setUser() async {
    await db.collection("usuarios").where("email", isEqualTo: _auth.currentUser!.email).get().then((querySnapshot) {
      print("Successfully completed");
      for (var docSnapshot in querySnapshot.docs) {
        _usuario = Usuario(
            id: docSnapshot.data()['id'],
            matricula: docSnapshot.data()['matricula'],
            email: docSnapshot.data()['email'],
            nome: docSnapshot.data()['nome'],
            cargo: docSnapshot.data()['cargo']);
        print('SNAPSHOT DATA -> ${docSnapshot.data()['email']}');
        print('${docSnapshot.id} => ${docSnapshot.data()}');
      }
      print(_auth.currentUser!.email);
      if (_usuario != null) {
        print("${_usuario!.id} ${_usuario!.nome} ${_usuario!.email} ${_usuario!.matricula}");
        userLogin();
      } else {
        print("No such document.");
      }
    });
    notifyListeners();
  }

  Future<void> addNewUsuario(Usuario user) async {
    final newUser = <String, dynamic>{
      "id": user.id,
      "nome": user.nome,
      "matricula": user.matricula,
      "email": user.email,
      "cargo": user.cargo
    };

    db.collection("usuarios").doc(_auth.currentUser!.uid).set(newUser, SetOptions(merge: true)).then((doc) {
      print('Usuario added with ID: ${_auth.currentUser!.uid}');
    });
    notifyListeners();
  }

  void userLogin() {
    _usuarioLogado = true;
    notifyListeners();
  }

  void userLogout() {
    _usuarioLogado = false;
    notifyListeners();
  }

  bool usuarioLogado() {
    return _usuarioLogado;
  }

  Usuario? getCurrentUsuario() {
    if (_usuario!.email == _auth.currentUser!.email) {
      return _usuario;
    }
    return null;
  }

  int? getUsuarioPermission() {
    return _usuario!.cargo;
  }

  void addNewAula(Aula aula) {
    final newAula = <String, dynamic>{
      "id": aula.id,
      "disciplina": aula.disciplina,
      "aula": aula.aula,
      "data": aula.data,
    };

    _aulas.add(aula);

    db.collection("aulas").add(newAula).then((DocumentReference doc) => print('Aula added with ID: ${doc.id}'));

    for (var turma in _turmas) {
      if (turma.disciplina == aula.disciplina) {
        for (var matricula in turma.matAlunos) {
          addEvaluation(Evaluation(
              id: findNextEvaluationId(0),
              matricula: matricula,
              disciplina: aula.disciplina,
              aula: aula.aula,
              data: aula.data,
              nota: 0.0,
              comentario: '',
              evaluated: false,
              evaluationAvailable: true));
        }
      }
    }

    notifyListeners();
  }

  void addAula(Aula aula) {
    _aulas.add(aula);
    notifyListeners();
  }

  int getEvaluationIndex(Evaluation evaluation) {
    print(_aulasAvaliar.indexWhere((x) => x.id == evaluation.id));
    return _aulasAvaliar.indexWhere((x) => x.id == evaluation.id);
  }

  void getAvaliacoesDB() {
    db
        .collection("avaliacoes")
        .where("matricula", isEqualTo: getCurrentUsuario()!.matricula)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        Evaluation newEvaluation = Evaluation(
            id: docSnapshot.data()['id'],
            matricula: docSnapshot.data()['matricula'],
            disciplina: docSnapshot.data()['disciplina'],
            aula: docSnapshot.data()['aula'],
            data: (docSnapshot.data()['data'] as Timestamp).toDate(),
            nota: docSnapshot.data()['nota'],
            comentario: docSnapshot.data()['comentario'],
            evaluated: docSnapshot.data()['avaliado'],
            evaluationAvailable: docSnapshot.data()['podeAvaliar']);
        print('${newEvaluation.id},${newEvaluation.matricula},${newEvaluation.disciplina},${newEvaluation.data}');
        _aulasAvaliar.add(newEvaluation);
      }
      _aulasAvaliar.sort((a, b) => a.data.compareTo(b.data));
    });
    notifyListeners();
  }

  List<Evaluation> getAulasAvaliar() {
    return _aulasAvaliar;
  }

  List<Aula> getAulas() {
    return _aulas;
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

  bool containsUsuario(elementToCheck) {
    List<dynamic> list = [];
    db.collection("usuarios").get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          list.add(docSnapshot.data()['id']);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    for (var element in list) {
      if (element.id == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  int findNextUsuarioId(int id) {
    if (containsUsuario(id)) {
      id = id + 1;
      findNextUsuarioId(id);
    }
    return id;
  }

  void addEvaluation(Evaluation evaluation) {
    final newEvaluation = <String, dynamic>{
      "id": evaluation.id,
      "matricula": evaluation.matricula,
      "disciplina": evaluation.disciplina,
      "aula": evaluation.aula,
      "data": evaluation.data,
      "nota": 0.0,
      "comentario": '',
      "avaliado": evaluation.evaluated,
      "podeAvaliar": evaluation.evaluationAvailable,
    };
    _aulasAvaliar.add(evaluation);

    db
        .collection("avaliacoes")
        .add(newEvaluation)
        .then((DocumentReference doc) => print('Avaliação added with ID: ${doc.id}'));
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

  Future<void> executeEvaluation(List<dynamic> result, Evaluation e) async {
    final newEvaluation = <String, dynamic>{
      "id": e.id,
      "matricula": e.matricula,
      "disciplina": e.disciplina,
      "aula": e.aula,
      "data": e.data,
      "nota": result[0],
      "comentario": result[1],
      "avaliado": true,
      "podeAvaliar": false,
    };
    _aulasAvaliar[_aulasAvaliar.indexOf(e)].nota = result[0];
    _aulasAvaliar[_aulasAvaliar.indexOf(e)].comentario = result[1];
    _aulasAvaliar[_aulasAvaliar.indexOf(e)].evaluated = true;
    _aulasAvaliar[_aulasAvaliar.indexOf(e)].evaluationAvailable = false;
    print('${_aulasAvaliar[_aulasAvaliar.indexOf(e)].nota} ${_aulasAvaliar[_aulasAvaliar.indexOf(e)].comentario}');
    var _docName;
    await db.collection("avaliacoes").where("id", isEqualTo: e.id).get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          _docName = docSnapshot.id;
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    final ref = db.collection("avaliacoes").doc(_docName);
    ref.update({"nota": result[0], "comentario": result[1], "avaliado": true, "podeAvaliar": false}).then(
        (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
    notifyListeners();
  }
}
