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
    // Disciplina(codigo: 'ELC1071', nome: 'PROJETO E GERÊNCIA DE BANCO DE DADOS'),
    // Disciplina(codigo: 'ELC137', nome: 'SISTEMAS DE INFORMACAO DISTRIBUIDOS "A"'),
    // Disciplina(codigo: 'ELC1088', nome: 'IMPLEMENTAÇÃO DE LINGUAGENS DE PROGRAMAÇÃO'),
    // Disciplina(codigo: 'DPADI0185', nome: 'SISTEMAS OPERACIONAIS'),
    // Disciplina(codigo: 'EDE1131', nome: 'LIBRAS: BACHARELADO'),
  ];

  List<Turma> _turmas = [];
  List<Aula> _aulas = [];
  List<Evaluation> _aulasAvaliar = [];

  Future<bool> loadData() async {
    try {
      await getAvaliacoesDB();
      await getAulasDB();
      await getTurmasDB();
      await getDisciplinasDB();
      return true;
    } catch (e) {
      print("Error $e");
      return false;
    }
  }

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

  void addNewAula(Aula aula) async {
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
              id: await findNextEvaluationId(0),
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

  Future<void> getAvaliacoesDB() async {
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
        if (!_aulasAvaliar.contains(newEvaluation)) {
          _aulasAvaliar.add(newEvaluation);
        }
      }
      _aulasAvaliar.sort((a, b) => a.data.compareTo(b.data));
    });
    notifyListeners();
  }

  Future<void> getAulasDB() async {
    db.collection("aulas").get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        Aula newAula = Aula(
          id: docSnapshot.data()['id'],
          disciplina: docSnapshot.data()['disciplina'],
          aula: docSnapshot.data()['aula'],
          data: (docSnapshot.data()['data'] as Timestamp).toDate(),
        );
        print('${newAula.id},${newAula.aula},${newAula.disciplina},${newAula.data}');
        if (!_aulas.contains(newAula)) {
          _aulas.add(newAula);
        }
      }
      _aulas.sort((a, b) => a.data.compareTo(b.data));
    });
    notifyListeners();
  }

  Future<void> getTurmasDB() async {
    db.collection("turmas").get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        List<int> matAlunos = <int>[];
        List.from(docSnapshot.data()['matAlunos']).forEach((mat) {
          int data = int.parse(mat.toString());
          matAlunos.add(data);
        });
        Turma newTurma = Turma(
          id: int.parse(docSnapshot.data()['id'].toString()),
          disciplina: docSnapshot.data()['disciplina'],
          matProfessor: int.parse(docSnapshot.data()['matProfessor'].toString()),
          matAlunos: matAlunos,
        );
        print('${newTurma.id},${newTurma.matProfessor},${newTurma.disciplina},${newTurma.matAlunos}');
        if (!turmaExists(newTurma)) {
          _turmas.add(newTurma);
        }
      }
      _turmas.sort((a, b) => a.id.compareTo(b.id));
      int i = 0;
      for (var turma in _turmas) {
        print(i);
        i++;
        print("Inside getTurmasDB ${turma.disciplina}");
        for (int matAluno in turma.matAlunos) {
          print(matAluno.toString());
        }
      }
    });
    notifyListeners();
  }

  Future<void> getDisciplinasDB() async {
    db.collection("disciplinas").get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        Disciplina newDisciplina = Disciplina(
          codigo: docSnapshot.data()['codigo'],
          nome: docSnapshot.data()['nome'],
        );
        print('${newDisciplina.codigo}, "${newDisciplina.nome}"');
        if (!_disciplinas.contains(newDisciplina)) {
          _disciplinas.add(newDisciplina);
        }
      }
    });
    notifyListeners();
  }

  bool turmaExists(Turma turmaToCheck) {
    for (Turma turma in _turmas) {
      if (turma.id == turmaToCheck.id) return true;
    }
    return false;
  }

  Disciplina? getDisciplina(String cod) {
    for (var disc in _disciplinas) {
      if (disc.codigo == cod) {
        return disc;
      }
    }
    return null;
  }

  List<Evaluation> getAulasAvaliar() {
    return _aulasAvaliar;
  }

  List<Aula> getAulas() {
    return _aulas;
  }

  List<Turma> getTurmas() {
    return _turmas;
  }

  Future<List<Usuario>> getAlunos(Turma turma) async {
    List<Usuario> alunos = [];
    for (var mat in turma.matAlunos) {
      await db.collection("usuarios").where("matricula", isEqualTo: mat).get().then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          alunos.add(Usuario(
              id: docSnapshot.data()['id'],
              matricula: docSnapshot.data()['matricula'],
              email: docSnapshot.data()['email'],
              nome: docSnapshot.data()['nome'],
              cargo: docSnapshot.data()['cargo']));
        }
      });
    }
    return alunos;
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

    db
        .collection("avaliacoes")
        .add(newEvaluation)
        .then((DocumentReference doc) => print('Avaliação added with ID: ${doc.id}'));
  }

  Future<void> clearEvaluations() async {
    _aulasAvaliar.clear();
  }

  Future<void> clearAulas() async {
    _aulas.clear;
  }

  Future<void> clearTurmas() async {
    _turmas.clear;
  }

  Future<void> removeEvaluation(int index) async {
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

  Future<int> findNextEvaluationId(int id) async {
    await db.collection("aulas").get().then(
      (querySnapshot) {
        for (var i = 0; i < querySnapshot.docs.length; i++) {
          if (querySnapshot.docs[i].data()['id'] > id) {
            id = querySnapshot.docs[i].data()['id'] + 1;
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
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
    await db.collection("avaliacoes").where("matricula", isEqualTo: _usuario!.matricula).get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          _docName = docSnapshot.id;
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    final ref = db.collection("avaliacoes").doc(_docName);
    ref.update({"nota": result[0], "comentario": result[1], "avaliado": true, "podeAvaliar": false}).then(
        (value) => print("DocumentSnapshot successfully updated! ${ref.id}"),
        onError: (e) => print("Error updating document $e"));
    notifyListeners();
  }
}
