import 'package:flutter/material.dart';
import '../../../widgets/layouts/Adm/default_layout_admin.dart';
import '../../../widgets/Card/CardHistoricoDoacao/CardHistoricoDoacao.dart';

class DoacoesPage extends StatefulWidget {
  const DoacoesPage({super.key});

  @override
  State<DoacoesPage> createState() => _DoacoesPageState();
}

class _DoacoesPageState extends State<DoacoesPage> {
  List<dynamic> doacoes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    buscarDoacoes();
  }

  Future<void> buscarDoacoes() async {
    try {
      // 🔹 Simulação da API (substituir depois pelo seu service)
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        doacoes = [
          {"id": 1, "nome": "Arroz", "quantidade": 10},
          {"id": 2, "nome": "Feijão", "quantidade": 5},
        ];
      });
    } catch (e) {
      debugPrint("Erro ao buscar doações: $e");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void exportarPDF() {
    // 🔥 depois a gente implementa com pacote pdf
    debugPrint("Exportando PDF...");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayoutAdmin(
      child: Column(
        children: [
          // 🔶 Barra estilo navbar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF6C973),
              border: Border.all(color: const Color(0xFFC1554C), width: 5),
            ),
            child: const Text(
              "Doações:",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Conteúdo
          Expanded(
  child: loading
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : doacoes.isNotEmpty
          ? ListView.builder(
              itemCount: doacoes.length,
              itemBuilder: (context, index) {
                final doacao = doacoes[index];

                return CardHistoricoDoacao(
                  index: index,
                  doacao: doacao,
                );
              },
            )
          : const Center(
              child: Text("Nenhuma doação foi encontrada."),
            ),
),

          const SizedBox(height: 20),

          // 🔴 Botão exportar PDF
          ElevatedButton(
            onPressed: exportarPDF,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA50000),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text("Exportar PDF Doações"),
          ),

          const SizedBox(height: 20),

          // 🔵 Botão voltar
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/adm");
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF276772),
                foregroundColor: Colors.white,
              ),
              child: const Text("Voltar"),
            ),
          ),
        ],
      ),
    );
  }
}