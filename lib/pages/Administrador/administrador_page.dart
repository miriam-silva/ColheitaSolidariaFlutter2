import 'package:flutter/material.dart';

class AdministradorPage extends StatelessWidget {
  const AdministradorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrador')),
      body: const Center(
        child: Text('Painel do Administrador'),
      ),
    );
  }
}