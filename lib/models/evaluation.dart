class Evaluation {
  Evaluation(this.id, this.matricula, this.disciplina, this.aula, this.data, this.nota, this.comentario, this.evaluated,
      this.evaluationAvailable);

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
