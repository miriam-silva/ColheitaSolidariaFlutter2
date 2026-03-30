import 'package:flutter/material.dart';

class ColaboradorCard extends StatelessWidget {
  final String nome;
  final String texto;
  final String imagem;
  final bool direita;

  const ColaboradorCard({
    super.key,
    required this.nome,
    required this.texto,
    required this.imagem,
    required this.direita,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: direita
              ? [Colors.transparent, const Color(0xFFE5A016)]
              : [const Color(0xFFE5A016), Colors.transparent],
        ),
      ),
      child: Row(
        children: direita
            ? [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D0101),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(texto),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Image.asset(imagem, width: 120),
              ]
            : [
                Image.asset(imagem, width: 120),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D0101),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(texto),
                    ],
                  ),
                ),
              ],
      ),
    );
  }
}