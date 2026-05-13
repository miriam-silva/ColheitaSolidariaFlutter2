import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../widgets/layouts/Adm/DefaultLayoutAdm.dart';

class InicialAdministrador extends StatelessWidget {
  const InicialAdministrador({super.key});

  Future<bool> confirmarSaida(BuildContext context) async {
    final result = await showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,

          title: const Text(
            "Sair da conta?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: const Text(
            "Você está saindo da área administrativa. Para acessar novamente será necessário realizar login.",
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

                if (!context.mounted) return;

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvoked: (didPop) async {
        if (didPop) return;

        final sair = await confirmarSaida(context);

        if (sair && context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/home",
            (route) => false,
          );
        }
      },

      child: DefaultLayoutAdmin(
        child: Center(
          child: GridView.count(
            shrinkWrap: true,

            crossAxisCount: 2,

            crossAxisSpacing: 16,

            mainAxisSpacing: 16,

            padding: const EdgeInsets.all(16),

            children: [
              _buildButton(
                context,
                "Pedidos",
                "/adm/pedidos",
              ),

              _buildButton(
                context,
                "Doações",
                "/adm/doacoes",
              ),

              _buildButton(
                context,
                "Cadastrar Recebedor",
                "/adm/cadastrar",
              ),

              _buildButton(
                context,
                "Gerenciar Usuários",
                "/adm/usuarios",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    String route,
  ) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },

      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color.fromRGBO(
          164,
          37,
          37,
          1,
        ),

        foregroundColor: Colors.white,

        padding: const EdgeInsets.all(20),

        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(30),
        ),

        elevation: 5,
      ),

      child: Text(
        text,

        textAlign: TextAlign.center,

        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}