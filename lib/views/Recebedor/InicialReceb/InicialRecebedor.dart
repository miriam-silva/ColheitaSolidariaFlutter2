import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../widgets/layouts/Receb/DefaultLayoutReceb.dart';
import '../../../widgets/LoadingSpinner.dart';
import '../../../widgets/ListaDoacoesFiltraValidade.dart';
import '../../../widgets/Hooks/useDoacoes.dart';
import '../../../widgets/Hooks/useSolicitacoes.dart';

import '../PedidoEnviado/PedidoEnviado.dart';

class InicialRecebedor extends StatefulWidget {
  const InicialRecebedor({super.key});

  @override
  State<InicialRecebedor> createState() => _InicialRecebedorState();
}

class _InicialRecebedorState extends State<InicialRecebedor> {
  List<Map<String, dynamic>> doacoes = [];

  List<String> selecionados = [];

  bool loadingDoacoes = false;

  final SolicitacaoService _solicitacaoService = SolicitacaoService();

  @override
  void initState() {
    super.initState();

    carregarDoacoes();
  }

  Future<void> carregarDoacoes() async {
    try {
      setState(() {
        loadingDoacoes = true;
      });

      final response = await buscarTodasDoacoes();

      setState(() {
        doacoes = response;
      });
    } catch (e) {
      debugPrint("Erro ao carregar doações: $e");
    } finally {
      setState(() {
        loadingDoacoes = false;
      });
    }
  }

  Future<bool> confirmarSaida(BuildContext context) async {
    final result = await showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,

          title: const Text(
            "Sair da conta?",

            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          content: const Text(
            "Você está saindo da área do recebedor. Para acessar novamente será necessário realizar login.",
          ),

          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA50000),

                foregroundColor: Colors.white,
              ),

              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF276772),

                foregroundColor: Colors.white,
              ),

              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                if (!context.mounted) {
                  return;
                }

                Navigator.pop(context, true);
              },

              child: const Text("Sair"),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  void handleCancel() {
    setState(() {
      selecionados = [];
    });
  }

  Future<void> handleSubmit() async {
    if (selecionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione pelo menos uma doação.")),
      );

      return;
    }

    try {
      for (String doacaoId in selecionados) {
        final resultado = await _solicitacaoService.registrarSolicitacao(
          doacaoId: doacaoId,
          quantidade: 1,
        );

        if (!resultado) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Erro ao registrar alguma solicitação."),
            ),
          );

          return;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Solicitação realizada com sucesso!")),
      );

      setState(() {
        selecionados = [];
      });

      Navigator.push(
        context,

        MaterialPageRoute(builder: (_) => const PedidoEnviado()),
      );
    } catch (e) {
      debugPrint("Erro ao enviar solicitação: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao enviar solicitação.")),
      );
    }
  }

  void onSelecionar(String id) {
    setState(() {
      if (selecionados.contains(id)) {
        selecionados.remove(id);
      } else {
        selecionados.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final sair = await confirmarSaida(context);

        if (sair && context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
        }
      },

      child: DefaultLayoutRecebedor(
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
                "Selecione uma doação que você gostaria de receber:",

                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            if (loadingDoacoes) const LoadingSpinner(),

            if (!loadingDoacoes)
              ListaDoacoesFiltraValidade(
                selecionados: selecionados,

                onSelecionar: onSelecionar,
              ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                ElevatedButton(
                  onPressed: handleCancel,

                  child: const Text("Cancelar"),
                ),

                const SizedBox(width: 20),

                ElevatedButton(
                  onPressed: handleSubmit,

                  child: const Text("Enviar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
