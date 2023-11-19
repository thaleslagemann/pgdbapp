class Evaluation {
  Evaluation(
      {required this.id,
      required this.matricula,
      required this.disciplina,
      required this.aula,
      required this.data,
      required this.nota,
      required this.comentario,
      required this.evaluated,
      required this.evaluationAvailable});

  final int id;
  final int matricula;
  final String disciplina;
  final int aula;
  final DateTime data;
  double nota;
  String comentario;
  bool evaluated = false;
  bool evaluationAvailable = false;
}
