import 'package:flutter/material.dart';
import '../../widgets/layouts/Home/DefaultLayoutHome.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        children: [
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset('assets/sacola.png', width: 120),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'No Colheita Solidária, somos uma equipe dedicada a reduzir o desperdício de alimentos e combater a fome.\n\n'
                    'Fundado em 2024, nosso objetivo é criar uma ponte entre agricultores com alimentos excedentes e pessoas necessitadas.\n\n'
                    'Acreditamos que, juntos, podemos construir uma comunidade mais solidária e sustentável!',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Nossa Missão',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D0101),
            ),
          ),

          const SizedBox(height: 20),

          _buildMissao(
            imagem: 'assets/tomatos.png',
            titulo: 'Reduzir o Desperdício',
            texto: 'Minimizar a perda de alimentos por meio de doações.',
            cor: const Color.fromARGB(255, 188, 42, 37),
            direita: true,
          ),

          _buildMissao(
            imagem: 'assets/maos.png',
            titulo: 'Combater a Fome',
            texto: 'Fornecer alimentos frescos e nutritivos para quem mais precisa.',
            cor: const Color.fromARGB(255, 83, 151, 73),
            direita: false,
          ),

          _buildMissao(
            imagem: 'assets/doisamigos.png',
            titulo: 'Fortalecer Comunidades',
            texto: 'Conectar doadores e recebedores, promovendo a solidariedade.',
            cor: const Color.fromARGB(255, 255, 170, 0),
            direita: true,
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Sobre o Projeto',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D0101),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'O Colheita Solidária é uma plataforma que conecta agricultores com comunidades em situação de vulnerabilidade.',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                const Text(
                  'Objetivos SMART',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D0101),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  '• Específico: Conectar agricultores e pessoas vulneráveis\n'
                  '• Mensurável: Funcionalidades completas\n'
                  '• Atingível: Equipe capacitada\n'
                  '• Relevante: Combate fome e desperdício\n'
                  '• Temporal: Até 2025',
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Equipe',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D0101),
            ),
          ),

          const SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: const [
              _Membro(nome: 'Miriam', imagem: 'assets/miriam.jpg'),
              _Membro(nome: 'Isadora', imagem: 'assets/isa.jpg'),
              _Membro(nome: 'Caroline', imagem: 'assets/carol.jpg'),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            'Tecnologias',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D0101),
            ),
          ),

          const SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: const [
              _Tech(nome: 'React', img: 'assets/react.png'),
              _Tech(nome: 'Bootstrap', img: 'assets/bootstrap.png'),
              _Tech(nome: 'Firebase', img: 'assets/firebase.png'),
              _Tech(nome: 'Notion', img: 'assets/notion.png'),
              _Tech(nome: 'GitHub', img: 'assets/github.png'),
              _Tech(nome: 'Figma', img: 'assets/figma.png'),
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  static Widget _buildMissao({
    required String imagem,
    required String titulo,
    required String texto,
    required Color cor,
    required bool direita,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(109, 249, 213, 154),
            cor,
          ],
          stops: const [0.25, 0.75],
          begin: direita
              ? Alignment.centerLeft
              : Alignment.centerRight,
          end: direita
              ? Alignment.centerRight
              : Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: direita
            ? [
                Image.asset(
                  imagem,
                  width: 100,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        titulo,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        texto,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            : [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        texto,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Image.asset(
                  imagem,
                  width: 100,
                ),
              ],
      ),
    );
  }
}

class _Membro extends StatelessWidget {
  final String nome;
  final String imagem;

  const _Membro({required this.nome, required this.imagem});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(imagem),
        ),
        const SizedBox(height: 5),
        Text(nome),
      ],
    );
  }
}

class _Tech extends StatelessWidget {
  final String nome;
  final String img;

  const _Tech({required this.nome, required this.img});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(img, width: 50),
        const SizedBox(height: 5),
        Text(nome),
      ],
    );
  }
}
