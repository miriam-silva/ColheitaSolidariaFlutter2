import 'package:flutter/material.dart';

class RecebedorPage extends StatelessWidget {
  const RecebedorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recebedor')),
      body: const Center(
        child: Text('Área do Recebedor'),
      ),
    );
  }
}