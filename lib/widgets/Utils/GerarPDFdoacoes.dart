import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> gerarPDFDoacoes(List<Map<String, dynamic>> doacoes) async {
  final pdf = pw.Document();

  if (doacoes.isEmpty) return;

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Relatório de Doações",
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
                "Colaborador",
                "Produto",
                "Quantidade",
                "Validade"
              ],
              data: doacoes.map((d) {
                return [
                  d["usuarioNome"] ?? "Desconhecido",
                  d["nome"] ?? "---",
                  d["quantidade"] ?? "---",
                  _formatarData(d["validade"]),
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

String _formatarData(dynamic data) {
  if (data == null) return "---";

  try {
    DateTime date;

    if (data is Timestamp) {
      date = data.toDate(); 
    } else if (data is DateTime) {
      date = data;
    } else {
      date = DateTime.parse(data.toString());
    }

    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  } catch (_) {
    return "---";
  }
}