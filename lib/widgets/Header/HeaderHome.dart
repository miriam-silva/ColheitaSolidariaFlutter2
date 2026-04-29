import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:  Color.fromRGBO(249, 225, 178, 100),
      elevation: 2,
      automaticallyImplyLeading: false, 

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/logotp.png',
            width: 140,
          ),
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
        backgroundColor: const Color.fromARGB(255, 241, 236, 204),
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