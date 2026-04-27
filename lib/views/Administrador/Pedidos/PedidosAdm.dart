import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../widgets/layouts/Adm/DefaultLayoutAdm.dart';
import '../../../widgets/LoadingSpinner.dart';
import '../InicialAdm/InicialAdm.dart';
import '../../../widgets/Utils/GerarPDFpedidos.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  List<Map<String, dynamic>> pedidos = [];
  bool loading = true;
  String updatingId = "";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    carregarPedidos();
  }

  Future<void> carregarPedidos() async {
    try {
      final snapshot = await _firestore
          .collection("solicitacoes")
          .orderBy("createdAt", descending: true)
          .get();

      List<Map<String, dynamic>> listaPedidos = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();

        String recebedorNome = "Usuário desconhecido";

        /// pega o uid salvo na solicitação
        final recebedorId = data["recebedorId"];

        /// busca o nome do usuário na coleção users
        if (recebedorId != null) {
          final userDoc = await _firestore
              .collection("users")
              .doc(recebedorId)
              .get();

          if (userDoc.exists) {
            recebedorNome = userDoc.data()?["nome"] ?? "Usuário desconhecido";
          }
        }

        listaPedidos.add({
          "id": doc.id,
          "recebedorNome": recebedorNome,
          "doacaoNome": data["nomeDoacao"] ?? "Item não identificado",
          "doacaoDescricao": data["descricaoDoacao"] ?? "",
          "status": data["status"] ?? "pendente",
        });
      }

      setState(() {
        pedidos = listaPedidos;
        loading = false;
      });
    } catch (e) {
      debugPrint("Erro ao carregar pedidos: $e");

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> atualizarStatus(String id, String novoStatus) async {
    try {
      setState(() {
        updatingId = id;
      });

      await _firestore.collection("solicitacoes").doc(id).update({
        "status": novoStatus,
      });

      setState(() {
        pedidos = pedidos.map((pedido) {
          if (pedido["id"] == id) {
            pedido["status"] = novoStatus;
          }
          return pedido;
        }).toList();

        updatingId = "";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status alterado para $novoStatus")),
      );
    } catch (e) {
      debugPrint("Erro ao atualizar status: $e");

      setState(() {
        updatingId = "";
      });
    }
  }

  Color corStatus(String status) {
    if (status == "Aprovado") {
      return const Color(0xFF276772);
    }

    if (status == "Protelado") {
      return const Color(0xFFA50000);
    }

    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayoutAdmin(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// faixa laranja
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF6C973),
              border: Border.all(color: const Color(0xFFC1554C), width: 5),
            ),
            child: const Text(
              "Pedidos:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),

          if (loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: LoadingSpinner(),
              ),
            )
          else if (pedidos.isEmpty)
            const Center(
              child: Text(
                "Nenhum pedido encontrado.",
                style: TextStyle(fontSize: 18),
              ),
            )
          else
            Column(
              children: pedidos.asMap().entries.map((entry) {
                final index = entry.key;
                final pedido = entry.value;

                final status = pedido["status"] ?? "pendente";
                final podeAlterar =
                    status.toString().toLowerCase() == "pendente";

                return Container(
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
                        "#${(index + 1).toString().padLeft(3, '0')} - ${pedido["recebedorNome"]}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Solicitou: ${pedido["doacaoNome"]}",
                        style: const TextStyle(fontSize: 20),
                      ),

                      if (pedido["doacaoDescricao"] != null &&
                          pedido["doacaoDescricao"] != "")
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Descrição: ${pedido["doacaoDescricao"]}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: podeAlterar
                                ? () =>
                                      atualizarStatus(pedido["id"], "Aprovado")
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF276772),
                            ),
                            child: updatingId == pedido["id"]
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Aprovar"),
                          ),

                          const SizedBox(width: 15),

                          ElevatedButton(
                            onPressed: podeAlterar
                                ? () =>
                                      atualizarStatus(pedido["id"], "Protelado")
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA50000),
                            ),
                            child: updatingId == pedido["id"]
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Protelar"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "Status: $status",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: corStatus(status),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 30),

          Center(
              child: ElevatedButton(
                onPressed: () => gerarPDFPedidos(pedidos),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA50000),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  "Exportar PDF Pedidos",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Voltar",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
