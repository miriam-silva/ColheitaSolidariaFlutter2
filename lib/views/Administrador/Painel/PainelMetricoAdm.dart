import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PainelMetrico extends StatelessWidget {
  final List<Map<String, dynamic>> usuarios;

  const PainelMetrico({
    super.key,
    required this.usuarios,
  });

  Map<String, int> calcularContagem() {
    Map<String, int> temp = {
      "Admin": 0,
      "Colaborador": 0,
      "Recebedor": 0,
    };

    for (var usuario in usuarios) {
      final role =
          (usuario["role"] ?? "").toString().toLowerCase();

      if (role == "admin") {
        temp["Admin"] = temp["Admin"]! + 1;
      } else if (role == "colaborador") {
        temp["Colaborador"] =
            temp["Colaborador"]! + 1;
      } else if (role == "recebedor") {
        temp["Recebedor"] =
            temp["Recebedor"]! + 1;
      }
    }

    return temp;
  }

  List<PieChartSectionData> getSections(
    Map<String, int> contagem,
  ) {
    final colors = [
      const Color(0xFFA50000),
      const Color(0xFFF5A623),
      const Color(0xFF4CAF50),
    ];

    final labels = contagem.keys.toList();
    final values = contagem.values.toList();

    final total =
        values.fold(0, (a, b) => a + b);

    return List.generate(labels.length, (i) {
      final value = values[i];

      final percent =
          total == 0 ? 0 : (value / total) * 100;

      return PieChartSectionData(
        value: value.toDouble(),
        title:
            "${labels[i]}\n${percent.toStringAsFixed(1)}%",
        radius: 90,
        color: colors[i],
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final contagem = calcularContagem();

    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Usuários por tipo",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: getSections(contagem),
                  centerSpaceRadius: 35,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}