import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../widgets/layouts/Colab/DefaultLayoutColab.dart';
import '../../../widgets/Context/DoacoesContext.dart';
import '../../../widgets/Card/CardHistoricoDoacao.dart';

class InicialColaborador extends StatefulWidget {
  const InicialColaborador({super.key});

  @override
  State<InicialColaborador> createState() => _InicialColaboradorState();
}

class _InicialColaboradorState extends State<InicialColaborador> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final doacoesContext = Provider.of<DoacoesContext>(
        context,
        listen: false,
      );

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await doacoesContext.atualizarUsuario(
          novoUserId: user.uid,
          novoToken: "firebase_auth",
        );
      } else {
        debugPrint("Usuário não autenticado no Firebase");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final doacoesContext = Provider.of<DoacoesContext>(context);

    final doacoes = doacoesContext.doacoes;
    final carregando = doacoesContext.carregando;

    return DefaultLayout4(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 220,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/colaborador/Registrardoacao",
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 2,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              child: const Text(
                "Realizar doação",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

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
              "Minhas doações:",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 30),

          if (carregando)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (doacoes.isEmpty)
            const Center(
              child: Text(
                "Nenhuma doação foi feita",
                style: TextStyle(
                  color: Color(0xFFA18654),
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            Column(
              children: doacoes.asMap().entries.map((entry) {
                final index = entry.key;
                final doacao = entry.value;

                return CardHistoricoDoacao(
                  index: index,
                  doacao: doacao,
                );
              }).toList(),
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}