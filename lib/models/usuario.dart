// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  Usuario({required this.id, required this.matricula, required this.email, required this.nome, required this.cargo});

  final int id;
  final int matricula;
  final String email;
  final String nome;
  final int cargo; // 0 -> admin, 1-> student, 2 -> teacher

  factory Usuario.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Usuario(
      id: data?['id'],
      matricula: data?['matricula'],
      email: data?['email'],
      nome: data?['nome'],
      cargo: data?['cargo'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (matricula != null) "matricula": matricula,
      if (email != null) "email": email,
      if (nome != null) "nome": nome,
      if (cargo != null) "cargo": cargo,
    };
  }
}
