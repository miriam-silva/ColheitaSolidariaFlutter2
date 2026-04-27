import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class PainelMetrico extends StatefulWidget {
  final List<Map<String, dynamic>> usuarios;

  const PainelMetrico({super.key, required this.usuarios});

  @override
  State<PainelMetrico> createState() => _PainelMetricoState();
}

class _PainelMetricoState extends State<PainelMetrico> {
  Map<String, int> contagem = {"Admin": 0, "Colaborador": 0, "Recebedor": 0};

  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .get();

      Map<String, int> temp = {"Admin": 0, "Colaborador": 0, "Recebedor": 0};

      for (var doc in snapshot.docs) {
        final role = (doc.data()["role"] ?? "").toString().toLowerCase();

        if (role == "admin")
          temp["Admin"] = temp["Admin"]! + 1;
        else if (role == "colaborador")
          temp["Colaborador"] = temp["Colaborador"]! + 1;
        else if (role == "recebedor")
          temp["Recebedor"] = temp["Recebedor"]! + 1;
      }

      setState(() {
        contagem = temp;
        loading = false;
      });
    } catch (e) {
      debugPrint("Erro ao carregar métricas: $e");
      setState(() => loading = false);
    }
  }

  List<PieChartSectionData> getSections() {
    final colors = [
      const Color(0xFFA50000),
      const Color(0xFFF5A623),
      const Color(0xFF4CAF50),
    ];

    final labels = contagem.keys.toList();
    final values = contagem.values.toList();
    final total = values.fold(0, (a, b) => a + b);

    return List.generate(labels.length, (i) {
      final value = values[i];
      final percent = total == 0 ? 0 : (value / total) * 100;

      return PieChartSectionData(
        value: value.toDouble(),
        title: "${labels[i]}\n${percent.toStringAsFixed(1)}%",
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
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 🔥 ISSO AQUI RESOLVE O OVERFLOW
          children: [
            const Text(
              "Usuários por tipo",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            if (loading)
              const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            else
              SizedBox(
                height: 220, // 🔥 menor = não quebra layout
                child: PieChart(
                  PieChartData(
                    sections: getSections(),
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
