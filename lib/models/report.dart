class Report {
  Report(this.disciplina, this.data, this.nota);

  final String disciplina;
  final DateTime data;
  final double nota;
}

double calcularMediaDiaria(List<Report> relatorios, int ano, int mes, int dia) {
  if (relatorios.isEmpty) return 0.0;

  List<Report> relatoriosDiarios = relatorios.where((report) {
    return report.data.year == ano && report.data.month == mes && report.data.day == dia;
  }).toList();

  if (relatoriosDiarios.isEmpty) return 0.0;

  double soma = 0.0;
  for (var relatorio in relatoriosDiarios) {
    soma += relatorio.nota;
  }

  return soma / relatoriosDiarios.length;
}

double calcularMediaMensal(List<Report> relatorios, int ano, int mes) {
  if (relatorios.isEmpty) return 0.0;

  List<Report> relatoriosMensais = relatorios.where((report) {
    return report.data.year == ano && report.data.month == mes;
  }).toList();

  if (relatoriosMensais.isEmpty) return 0.0;

  double soma = 0.0;
  for (var relatorio in relatoriosMensais) {
    soma += relatorio.nota;
  }

  return soma / relatoriosMensais.length;
}

double calcularMediaAnual(List<Report> relatorios, int ano) {
  if (relatorios.isEmpty) return 0.0;

  List<Report> relatoriosAnuais = relatorios.where((report) {
    return report.data.year == ano;
  }).toList();

  if (relatoriosAnuais.isEmpty) return 0.0;

  double soma = 0.0;
  for (var relatorio in relatoriosAnuais) {
    soma += relatorio.nota;
  }

  return soma / relatoriosAnuais.length;
}