import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            // 🔶 FAIXA BEM-VINDO
            Container(
              width: double.infinity,
              color: const Color(0xFFF5E2BF),
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

            // 🎠 CARROSSEL
            SizedBox(
              height: 200,
              child: PageView(
                children: const [
                  Image(image: AssetImage('assets/img2.jpg'), fit: BoxFit.cover),
                  Image(image: AssetImage('assets/img3.jpg'), fit: BoxFit.cover),
                  Image(image: AssetImage('assets/img4.jpg'), fit: BoxFit.cover),
                  Image(image: AssetImage('assets/img5.jpg'), fit: BoxFit.cover),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🟡 SEÇÃO COM IMAGEM + TEXTO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Color(0xFFF5C25C)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  Image.asset('assets/agricultoraicon.png', width: 120),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'No Colheita Solidária, acreditamos que todos merecem acesso a alimentos frescos e nutritivos...',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔴 TÍTULO
            const Text(
              'Como Funciona?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D0101),
              ),
            ),

            const SizedBox(height: 20),

            // 📦 CARDS
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [

                  _buildCard(
                    titulo: 'Doe alimentos',
                    texto: 'Agricultores cadastrados podem listar alimentos.',
                    imagem: 'assets/alimentos2.png',
                    cor: const Color(0xFF66A276),
                  ),

                  _buildCard(
                    titulo: 'Receba alimentos',
                    texto: 'Pessoas podem se cadastrar para receber.',
                    imagem: 'assets/receba.png',
                    cor: const Color(0xFF6CA899),
                  ),

                  _buildCard(
                    titulo: 'Conecte-se',
                    texto: 'Conectamos doadores e recebedores.',
                    imagem: 'assets/coracao_plantinha.png',
                    cor: const Color(0xFF276772),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔘 BOTÕES (suas rotas)
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/admin');
              },
              child: const Text('Administrador'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/recebedor');
              },
              child: const Text('Recebedor'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/colaborador');
              },
              child: const Text('Colaborador'),
            ),
          ],
        ),
      ),
    );
  }

  // 🔧 COMPONENTE REUTILIZÁVEL (igual React components)
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