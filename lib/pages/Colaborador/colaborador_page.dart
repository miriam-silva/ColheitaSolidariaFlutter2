import 'package:flutter/material.dart';

class ColaboradorPage extends StatelessWidget {
  const ColaboradorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Colaborador')),
      body: const Center(
        child: Text('Painel do Colaborador'),
      ),
    );
  }
}