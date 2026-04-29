import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../widgets/layouts/Adm/DefaultLayoutAdm.dart';
import '../InicialAdm/InicialAdm.dart';
import '../../../widgets/Utils/GerarPDFdoacoes.dart';

class DoacoesPage extends StatefulWidget {
  const DoacoesPage({super.key});

  @override
  State<DoacoesPage> createState() => _DoacoesPageState();
}

class _DoacoesPageState extends State<DoacoesPage> {
  List<Map<String, dynamic>> doacoes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarDoacoes();
  }

  Future<void> carregarDoacoes() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("doacoes")
          .orderBy("createdAt", descending: true)
          .get();

      final lista = await Future.wait(
        snapshot.docs.map((doc) async {
          final data = doc.data();

          String usuarioNome = "Desconhecido";

          final usuarioId = data["usuarioId"];

          if (usuarioId != null) {
            final userDoc = await FirebaseFirestore.instance
                .collection("users")
                .doc(usuarioId)
                .get();

            if (userDoc.exists) {
              usuarioNome =
                  userDoc.data()?["nomeCompleto"] ??
                  userDoc.data()?["nome"] ??
                  "Desconhecido";
            }
          }

          return {
            "id": doc.id,
            "nome": data["nome"] ?? "",
            "descricao": data["descricao"] ?? "",
            "quantidade": data["quantidade"] ?? "",
            "validade": data["validade"] ?? "",
            "imagemUrl": data["imagemUrl"],
            "usuarioNome": usuarioNome,
            "createdAt": data["createdAt"],
          };
        }),
      );

      setState(() {
        doacoes = lista;
        loading = false;
      });
    } catch (e) {
      debugPrint("Erro ao buscar doações: $e");

      setState(() {
        loading = false;
      });
    }
  }

  String formatarData(dynamic timestamp) {
    if (timestamp == null) return "Data desconhecida";

    DateTime data = (timestamp as Timestamp).toDate();

    return "${data.day.toString().padLeft(2, '0')}/"
        "${data.month.toString().padLeft(2, '0')}/"
        "${data.year}";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayoutAdmin(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF6C973),
              border: Border.all(color: const Color(0xFFC1554C), width: 5),
            ),
            child: const Text(
              "Doações:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),

          /// 🔥 TUDO AGORA DENTRO DO SCROLL
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                if (doacoes.isEmpty)
                  const Center(
                    child: Text(
                      "Nenhuma doação foi encontrada.",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                else
                  for (int i = 0; i < doacoes.length; i++)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "#${(doacoes.length - i).toString().padLeft(3, '0')} - ${doacoes[i]["nome"] ?? ""}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          if (doacoes[i]["imagemUrl"] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                doacoes[i]["imagemUrl"],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                          const SizedBox(height: 10),

                          Text("Descrição: ${doacoes[i]["descricao"] ?? ""}"),
                          Text("Quantidade: ${doacoes[i]["quantidade"] ?? ""}"),

                          Text(
                            "Validade: ${doacoes[i]["validade"] is Timestamp ? formatarData(doacoes[i]["validade"]) : doacoes[i]["validade"] ?? ""}",
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Doado por: ${doacoes[i]["usuarioNome"] ?? "Desconhecido"}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "Registrado em: ${formatarData(doacoes[i]["createdAt"])}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                const SizedBox(height: 20),

                Center(
              child: ElevatedButton(
                onPressed: () => gerarPDFDoacoes(doacoes),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA50000),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  "Exportar PDF Doações",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const InicialAdministrador(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF276772),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Voltar"),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
