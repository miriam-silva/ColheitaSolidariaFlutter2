import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../../widgets/layouts/Colab/DefaultLayoutColab.dart';
import '../../../widgets/Context/DoacoesContext.dart';
import '../../../widgets/Card/CardHistoricoDoacao.dart';
import '../../../widgets/LoadingSpinner.dart';

class MinhasDoacoes extends StatefulWidget {
  const MinhasDoacoes({super.key});

  @override
  State<MinhasDoacoes> createState() => _MinhasDoacoesState();
}

class _MinhasDoacoesState extends State<MinhasDoacoes> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final token = await user.getIdToken();

        final doacoesContext = Provider.of<DoacoesContext>(
          context,
          listen: false,
        );

        await doacoesContext.atualizarUsuario(
          novoUserId: user.uid,
          novoToken: token ?? "",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final doacoesContext = Provider.of<DoacoesContext>(context);

    final doacoes = doacoesContext.doacoes;
    final loading = doacoesContext.carregando;

    return DefaultLayout4(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Minhas Doações",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            if (loading)
              const Center(
                child: LoadingSpinner(
                  size: 60,
                ),
              )

            else if (doacoes.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    "Nenhuma doação cadastrada por você",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
              )

            else
              Column(
                children: doacoes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final doacao = entry.value;

                  return CardHistoricoDoacao(
                    key: ValueKey(doacao["id"] ?? index),
                    index: index,
                    doacao: doacao,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}