import 'package:flutter/material.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFA42525),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        children: [
          _navItem(context, 'Home', '/home'),
          _navItem(context, 'Sobre Nós', '/sobrenos'),
          _navItem(context, 'Colaboradores', '/colaboradores'),
          _navItem(context, 'Como ajudar?', '/comoajudar'),
          _navItem(context, 'Contato', '/contato'),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, String texto, String rota) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, rota);
      },
      child: Text(
        texto,
        style: const TextStyle(
          color: Color(0xFFF9E1B2),
          fontSize: 16,
        ),
      ),
    );
  }
}