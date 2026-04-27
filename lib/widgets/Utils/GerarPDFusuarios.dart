import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> gerarPDFUsuarios(List<Map<String, dynamic>> usuarios) async {
  final pdf = pw.Document();
  final firestore = FirebaseFirestore.instance;

  try {
    final doacoesSnap =
        await firestore.collection("doacoes").get();

    final solicitacoesSnap =
        await firestore.collection("solicitacoes").get();

    /// 🔥 DOAÇÕES por colaborador (usuarioId)
    final Map<String, int> qtdDoacoesPorUser = {};

    for (var doc in doacoesSnap.docs) {
      final data = doc.data();

      final usuarioId = data["usuarioId"]; // 👈 CORRETO

      if (usuarioId != null) {
        qtdDoacoesPorUser[usuarioId] =
            (qtdDoacoesPorUser[usuarioId] ?? 0) + 1;
      }
    }

    /// 🔥 SOLICITAÇÕES por recebedor
    final Map<String, int> qtdSolicitacoesPorUser = {};

    for (var doc in solicitacoesSnap.docs) {
      final data = doc.data();

      final recebedorId = data["recebedorId"]; // 👈 CORRETO

      if (recebedorId != null) {
        qtdSolicitacoesPorUser[recebedorId] =
            (qtdSolicitacoesPorUser[recebedorId] ?? 0) + 1;
      }
    }

    final dados = usuarios
        .where((u) =>
            (u["role"] ?? "").toString().toLowerCase() != "admin")
        .toList();

    if (dados.isEmpty) return;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Relatório de Usuários",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Text(
                "Gerado em: ${DateTime.now().toString().substring(0, 10)}",
                style: const pw.TextStyle(fontSize: 10),
              ),

              pw.SizedBox(height: 20),

              pw.Table.fromTextArray(
                headers: [
                  "Nome",
                  "Email",
                  "Cargo",
                  "Doações",
                  "Solicitações"
                ],
                data: dados.map((u) {
                  final role =
                      (u["role"] ?? "").toString().toLowerCase();

                  final id = u["id"];

                  final doacoes = qtdDoacoesPorUser[id] ?? 0;
                  final solicitacoes =
                      qtdSolicitacoesPorUser[id] ?? 0;

                  return [
                    u["nome"] ?? "---",
                    u["email"] ?? "---",
                    u["role"] ?? "---",
                    role == "colaborador"
                        ? doacoes.toString()
                        : "-",
                    role == "recebedor"
                        ? solicitacoes.toString()
                        : "-",
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  } catch (e) {
    print("Erro ao gerar PDF: $e");
  }
}