class Usuario {
  Usuario({required this.id, required this.matricula, required this.email, required this.nome, required this.cargo});

  final int id;
  final int matricula;
  final String email;
  final String nome;
  final int cargo; // 0 -> admin, 1-> student, 2 -> teacher
}
