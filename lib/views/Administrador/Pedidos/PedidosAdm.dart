import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  List pedidos = [];
  bool loading = true;
  int? updatingId;

  final String baseUrl = "SUA_API_URL"; 

  @override
  void initState() {
    super.initState();
    carregarPedidos();
  }

  Future<void> carregarPedidos() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/Solicitacao"),
      );

      if (response.statusCode == 200) {
        setState(() {
          pedidos = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print("Erro ao carregar solicitações: $e");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> handleStatusChange(int id, String novoStatus) async {
    try {
      setState(() {
        updatingId = id;
      });

      await http.put(
        Uri.parse("$baseUrl/Solicitacao/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": novoStatus}),
      );

      setState(() {
        pedidos = pedidos.map((p) {
          if (p["id"] == id) {
            p["status"] = novoStatus;
          }
          return p;
        }).toList();
      });
    } catch (e) {
      print("Erro ao atualizar status: $e");
    } finally {
      setState(() {
        updatingId = null;
      });
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Aprovado":
        return Color(0xFF276772);
      case "Protelado":
        return Color(0xFFA50000);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedidos"),
        backgroundColor: Color(0xFFF6C973),
        foregroundColor: Colors.black,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: pedidos.length,
                    itemBuilder: (context, index) {
                      final pedido = pedidos[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "#${(index + 1).toString().padLeft(3, "0")} - ${pedido["recebedorNome"] ?? "Usuário desconhecido"}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              pedido["doacaoNome"] != null
                                  ? "Solicitou: ${pedido["doacaoNome"]}"
                                  : "Item não identificado",
                              style: const TextStyle(fontSize: 18),
                            ),

                            if (pedido["doacaoDescricao"] != null)
                              Text(
                                "Descrição: ${pedido["doacaoDescricao"]}",
                                style: const TextStyle(fontSize: 16),
                              ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: pedido["status"] != "pendente"
                                      ? null
                                      : () => handleStatusChange(
                                          pedido["id"], "Aprovado"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF276772),
                                  ),
                                  child: updatingId == pedido["id"]
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child:
                                              CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                        )
                                      : const Text("Aprovar"),
                                ),

                                const SizedBox(width: 10),

                                ElevatedButton(
                                  onPressed: pedido["status"] != "pendente"
                                      ? null
                                      : () => handleStatusChange(
                                          pedido["id"], "Protelado"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFA50000),
                                  ),
                                  child: updatingId == pedido["id"]
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child:
                                              CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                        )
                                      : const Text("Protelar"),
                                ),
                              ],
                            ),

                            if (pedido["status"] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "Status: ${pedido["status"]}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        getStatusColor(pedido["status"]),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA50000),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text("Exportar PDF Pedidos"),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF276772),
                    ),
                    child: const Text("Voltar"),
                  ),
                ),
              ],
            ),
    );
  }
}