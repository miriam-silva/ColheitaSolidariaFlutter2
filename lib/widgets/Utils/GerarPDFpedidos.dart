import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> gerarPDFPedidos(List<Map<String, dynamic>> pedidos) async {
  final pdf = pw.Document();

  if (pedidos.isEmpty) return;

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Relatório de Pedidos",
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
              headers: ["Usuário", "Produto", "Descrição", "Status"],
              data: pedidos.map((p) {
                return [
                  p["recebedorNome"] ?? "Desconhecido",
                  p["doacaoNome"] ?? "Item não identificado",
                  p["doacaoDescricao"] ?? "Sem descrição",
                  p["status"] ?? "pendente",
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              cellStyle: const pw.TextStyle(fontSize: 10),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (format) async => pdf.save(),
  );
}