import 'package:flutter/material.dart';
import '../../../widgets/layouts/Adm/DefaultLayoutAdm.dart'; 

class InicialAdministrador extends StatelessWidget {
  const InicialAdministrador({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayoutAdmin(
      child: Container(
        color: const Color(0xFFE8CF9C), 
        child: Center(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2, 
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            padding: const EdgeInsets.all(16),
            children: [
              _buildButton(context, "Pedidos", "/adm/pedidos"),
              _buildButton(context, "Doações", "/adm/doacoes"),
              _buildButton(context, "Cadastrar Recebedor", "/adm/cadastrar"),
              _buildButton(context, "Gerenciar Usuários", "/adm/usuarios"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, String route) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
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