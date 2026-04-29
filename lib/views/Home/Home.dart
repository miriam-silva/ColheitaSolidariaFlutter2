import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../widgets/layouts/Home/DefaultLayoutHome.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        children: [

          Container(
            width: double.infinity,
            color: const Color(0xFFFFFCE0),
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Bem-Vindo a Colheita Solidária!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B392A),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // CARROSSEL DE IMAGENS
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
            ),
            items: [
              'assets/img2.jpg',
              'assets/img3.jpg',
              'assets/img4.jpg',
              'assets/img5.jpg',
            ].map((imagePath) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 30),

          Container(
  padding: const EdgeInsets.all(16),
  decoration: const BoxDecoration(
    gradient: const LinearGradient(
  colors: [
    Color.fromARGB(14, 245, 194, 92),
    Color(0xFFF5C25C),
  ],
  stops: [0.05, 0.95],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
),
  ),
  child: Row(
    children: [
      Image.asset(
        'assets/agricultoraicon.png',
        width: 120,
      ),

      const SizedBox(width: 10),

      Expanded(
        child: RichText(
          textAlign: TextAlign.right,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: 'No Colheita Solidária, acreditamos que ',
              ),
              TextSpan(
                text: 'todos merecem',
                style: TextStyle(
                  color: Color(0xFFB22222),
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text:
                    ' acesso a alimentos frescos e nutritivos.\n\nNossa missão é ',
              ),
              TextSpan(
                text: 'conectar agricultores',
                style: TextStyle(
                  color: Color(0xFFB22222),
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text:
                    ' com excedentes de produção a pessoas e ',
              ),
              TextSpan(
                text: 'famílias que necessitam',
                style: TextStyle(
                  color: Color(0xFFB22222),
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text:
                    ', reduzindo o desperdício de alimentos e ajudando a combater a fome.\n\n',
              ),
              TextSpan(
                text: 'Junte-se a nós nesta causa',
                style: TextStyle(
                  color: Color(0xFFB22222),
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text:
                    ' e faça a diferença na vida de alguém hoje mesmo.',
              ),
            ],
          ),
        ),
      ),
    ],
  ),
),

          const SizedBox(height: 30),

          const Text(
            'Como Funciona?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D0101),
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                _buildCard(
                  titulo: 'Doe alimentos',
                  texto: 'Agricultores cadastrados podem listar os alimentos disponíveis para doação.',
                  imagem: 'assets/alimentos2.png',
                  cor: const Color(0xFF66A276),
                ),

                _buildCard(
                  titulo: 'Receba alimentos',
                  texto: 'Pessoas carentes se cadastram para receber alimentos doados.',
                  imagem: 'assets/receba.png',
                  cor: const Color(0xFF6CA899),
                ),

                _buildCard(
                  titulo: 'Conecte-se',
                  texto: 'Nossa plataforma facilita a conexão entre doadores e recebedores, garantindo que os alimentos cheguem a quem mais precisa.',
                  imagem: 'assets/coracao_plantinha.png',
                  cor: const Color(0xFF276772),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  static Widget _buildCard({
    required String titulo,
    required String texto,
    required String imagem,
    required Color cor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Image.asset(imagem, height: 80),
          const SizedBox(height: 10),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}