import 'package:flutter/material.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({super.key});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  bool menuAberto = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16), // distância das bordas
      //padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFA42525),
        borderRadius: BorderRadius.circular(20), // bordas arredondadas
      ),
      child: Column(
        children: [
          // TOPO
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    menuAberto = !menuAberto;
                  });
                },
                icon: Icon(
                  menuAberto ? Icons.close : Icons.menu,
                  size: 30,
                  color: const Color.fromARGB(255, 255, 218, 181),
                ),
              ),
              const SizedBox(width: 0),
              if (menuAberto)
                Expanded(
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _menuItem(context, 'Home', '/home'),
                      _menuItem(context, 'Sobre nós', '/sobrenos'),
                      _menuItem(context, 'Colaboradores', '/colaboradores'),
                      _menuItem(context, 'Como ajudar?', '/comoajudar'),
                      _menuItem(context, 'Contato', '/contato'),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context, String texto, String rota) {
    final String rotaAtual = ModalRoute.of(context)?.settings.name ?? '';

    final bool ativo = rotaAtual == rota;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextButton(
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () {
          Navigator.pushNamed(context, rota);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: ativo
                ? const Color(0xFFB31200) // destaque da página ativa
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              texto,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
