import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      automaticallyImplyLeading: false, // remove botão de voltar automático

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // 🔷 LOGO
          Image.asset(
            'assets/logotp.png',
            width: 140,
          ),

          // 🔶 BOTÕES
          Row(
            children: [
              _buildButton(context, 'Entrar', '/login'),
              const SizedBox(width: 10),
              _buildButton(context, 'Cadastrar-se', '/cadastro'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String texto, String rota) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(rota);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE3DAA7),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(texto),
    );
  }
}