import 'package:flutter/material.dart';
import '../../widgets/layouts/default_layout.dart';

class ComoAjudarPage extends StatelessWidget {
  const ComoAjudarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        children: [

          const SizedBox(height: 20),

          // 🌱 SEÇÃO 1
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Faça a diferença!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D0101),
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset(
                  'assets/plantinha.png',
                  width: 100,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Há várias maneiras de se envolver e apoiar nossa causa! Veja como você pode ajudar:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          // 🍲 SEÇÃO 2
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Doe alimentos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D0101),
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset(
                  'assets/sopinha.png',
                  width: 120,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Se você é agricultor, cadastre-se e doe seus excedentes de produção.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          // 🤝 SEÇÃO 3
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Divulgue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D0101),
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset(
                  'assets/maosdadas.png',
                  width: 120,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Espalhe a palavra sobre nossa missão e ajude-nos a alcançar mais pessoas necessitadas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          // 💬 FINAL
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                Text(
                  'Juntos, podemos fazer uma grande diferença na luta contra o desperdício de alimentos e a fome.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Cadastre-se hoje mesmo e junte-se a nós nessa causa!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF5D0101),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}