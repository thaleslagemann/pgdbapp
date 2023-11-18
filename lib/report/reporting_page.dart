import 'package:flutter/material.dart';
import 'report.dart';

class ReportingPage extends StatefulWidget {
  const ReportingPage({super.key});

  @override
  ReportingPageState createState() => ReportingPageState();
}

class ReportingPageState extends State<ReportingPage> {
  List<Report> relatorios = [
    Report('ELC1071', DateTime(2023, 1, 1), 10.0),
    Report('EDE1131', DateTime(2023, 1, 1), 0.0),
    Report('ELC137', DateTime(2023, 1, 1), 8.0),
    Report('MAT1123', DateTime(2023, 1, 1), 9.0),
    Report('DPADI0185', DateTime(2023, 1, 1), 10.0),
  ];

  double calcularMedia() {
    if (relatorios.isEmpty) return 0.0;

    double soma = 0.0;
    for (var relatorio in relatorios) {
      soma += relatorio.nota;
    }

    return soma / relatorios.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aulas',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Colors.black, Colors.black87, Colors.white]),
            ),
          ),
        ),
      ),
      body: 
        Column(
          children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Text('Relatório', style: TextStyle(fontSize: 18.0)),
              Divider(
                  height: 0,
                  color: Colors.black54,
                  thickness: 0.5,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 300, 0),
                child: Text('A média é:'),
              ),
             Padding(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 60),
                child:
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 2.0  
                    ),
                    shape: BoxShape.circle,  
                  ),
                  child: Center(
                      child: Text(
                        '${calcularMedia().toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                  ),
                ),
              ),        
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 300, 0),
                child: Text('A aula está:'),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 60),
                child:
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 2.0  
                    ),
                    shape: BoxShape.circle,  
                  ),

                  child: Center(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        calcularMedia() > 7.0
                        ? 'Healthy'
                        : 'Sick',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        )
                      )
                    )
                  ), 
              )),
            ]),
        ]),
    );
  }
}