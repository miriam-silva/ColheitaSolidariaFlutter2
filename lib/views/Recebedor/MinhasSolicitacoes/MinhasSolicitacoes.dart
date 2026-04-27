import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../widgets/layouts/Receb/DefaultLayoutReceb.dart';
import '../../../widgets/LoadingSpinner.dart';
import '../../../widgets/Hooks/useHistoricoDoacoes.dart';
import '../InicialReceb/InicialRecebedor.dart';

class MinhasSolicitacoes extends StatefulWidget {
  const MinhasSolicitacoes({super.key});

  @override
  State<MinhasSolicitacoes> createState() => _MinhasSolicitacoesState();
}

class _MinhasSolicitacoesState extends State<MinhasSolicitacoes> {
  List<Map<String, dynamic>> historico = [];
  bool loading = true;
  String erro = "";

  @override
  void initState() {
    super.initState();
    carregarHistorico();
  }

  Future<void> carregarHistorico() async {
    try {
      final resultado = await buscarHistoricoSolicitacoes();

      setState(() {
        historico = resultado;
        loading = false;
      });
    } catch (e) {
      setState(() {
        erro = "Erro ao carregar solicitações.";
        loading = false;
      });
    }
  }

  String formatarData(dynamic data) {
  if (data == null) {
    return "Data não disponível";
  }

  try {
    if (data is Timestamp) {
      return DateFormat("dd/MM/yyyy").format(data.toDate());
    }

    if (data is DateTime) {
      return DateFormat("dd/MM/yyyy").format(data);
    }

    final dataConvertida = DateTime.parse(data.toString());
    return DateFormat("dd/MM/yyyy").format(dataConvertida);
  } catch (e) {
    return "Data não disponível";
  }
}

  @override
  Widget build(BuildContext context) {
    return DefaultLayoutRecebedor(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// faixa laranja
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF6C973),
              border: Border.all(
                color: const Color(0xFFC1554C),
                width: 5,
              ),
            ),
            child: const Text(
              "Minhas solicitações:",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
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
          else if (erro.isNotEmpty)
            Center(
              child: Text(
                erro,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFA18654),
                ),
              ),
            )
          else if (historico.isEmpty)
            const Center(
              child: Text(
                "Nenhuma solicitação foi feita",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFA18654),
                ),
              ),
            )
          else
            Column(
              children: historico.map((sol) {
                final doacao = sol["doacao"];

                if (doacao == null) {
                  return const SizedBox();
                }

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      /// imagem
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          doacao["imagemUrl"] ?? "",
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Container(
                              width: 180,
                              height: 180,
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: Text("Sem imagem"),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 20),

                      /// texto
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              doacao["titulo"] ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              doacao["descricao"] ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "Data de solicitação: ${formatarData(sol["dataSolicitacao"])}"
                              " | Status: ${sol["status"] ?? ""}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 30),

          /// botão voltar
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InicialRecebedor(),
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}