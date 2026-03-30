import 'package:flutter/material.dart';
import '../headerinicio_widget.dart';
import '../navbarinicio_widget.dart';
import '../footer_widget.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;

  const DefaultLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          // 🔷 HEADER
          const HeaderWidget(),

          // 🔴 NAVBAR
          const NavbarWidget(),

          // 🔻 CONTEÚDO
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  child, // 👈 aqui entra o conteúdo da página
                  const SizedBox(height: 30),
                  const FooterWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}