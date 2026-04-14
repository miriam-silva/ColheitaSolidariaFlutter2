import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class PainelMetrico extends StatefulWidget {
  final List<dynamic>? usuarios;

  const PainelMetrico({super.key, this.usuarios});

  @override
  State<PainelMetrico> createState() => _PainelMetricoState();
}

class _PainelMetricoState extends State<PainelMetrico> {
  List<Map<String, dynamic>> dados = [];

  final List<Color> cores = [
    Color(0xFFA50000),
    Color(0xFFF5A623),
    Color(0xFF4CAF50),
  ];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    try {
      List usuarios = widget.usuarios ?? [];

      if (usuarios.isEmpty) {
        final response = await http.get(
          Uri.parse("SUA_API_URL/Admin/usuarios-gerais"),
        );

        if (response.statusCode == 200) {
          usuarios = jsonDecode(response.body);
        }
      }

      Map<String, int> contagem = {
        "Admin": 0,
        "Colaborador": 0,
        "Recebedor": 0,
      };

      for (var u in usuarios) {
        contagem[u['role']] = (contagem[u['role']] ?? 0) + 1;
      }

      List<Map<String, dynamic>> grafico = contagem.entries.map((entry) {
        return {
          "name": entry.key,
          "value": entry.value,
        };
      }).toList();

      setState(() {
        dados = grafico;
      });
    } catch (e) {
      print("Erro ao carregar métricas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            "Usuários separados por tipo",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA50000),
            ),
          ),
          SizedBox(height: 20),

          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sections: dados.asMap().entries.map((entry) {
                  int index = entry.key;
                  var data = entry.value;

                  return PieChartSectionData(
                    value: data["value"].toDouble(),
                    title: "${data["name"]}: ${data["value"]}",
                    color: cores[index % cores.length],
                    radius: 100,
                    titleStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}