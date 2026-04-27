import 'package:flutter/material.dart';
import '../../../widgets/layouts/Receb/DefaultLayoutReceb.dart';
import '../InicialReceb/InicialRecebedor.dart';

class PedidoEnviado extends StatelessWidget {
  const PedidoEnviado({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayoutRecebedor(
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            /// mensagem central
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.symmetric(
                  vertical: 60,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "Solicitação registrada!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            /// botão voltar
            Positioned(
              bottom: 20,
              right: 20,
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
      ),
    );
  }
}