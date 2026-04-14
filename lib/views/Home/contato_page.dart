import 'package:flutter/material.dart';
import '../../widgets/layouts/Home/default_layout.dart';

class ContatoPage extends StatelessWidget {
  const ContatoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        children: [

          const SizedBox(height: 20),

          // 🔶 TÍTULO
          const Text(
            'Entre em contato conosco!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D0101),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Seja para sanar dúvidas ou fazer sugestões :)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 20),

          // 📝 FORMULÁRIO
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Primeiro nome',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Último sobrenome',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Assunto',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                // 🔘 BOTÕES
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA50000),
                      ),
                      onPressed: () {},
                      child: const Text('Cancelar'),
                    ),

                    const SizedBox(width: 10),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF276772),
                      ),
                      onPressed: () {},
                      child: const Text('Enviar'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 📞 FORMAS DE CONTATO
          const Text(
            'Veja nossas formas de contato:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D0101),
            ),
          ),

          const SizedBox(height: 20),

          // 📦 CARDS
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [

              _contatoCard(
                titulo: 'Instagram',
                imagem: 'assets/icon instagram.png',
                texto: '@Colheita.solidaria',
                cor: const LinearGradient(
                  colors: [
                    Color(0xFFC13584),
                    Color(0xFFFF2D53),
                    Color(0xFFFFBB00),
                  ],
                ),
              ),

              _contatoCard(
                titulo: 'Email',
                imagem: 'assets/icon email.png',
                texto: 'colheitasolidariafatec@gmail.com',
                cor: const LinearGradient(
                  colors: [
                    Color(0xFF0051FF),
                    Color(0xFFABC0F0),
                  ],
                ),
              ),

              _contatoCard(
                titulo: 'WhatsApp',
                imagem: 'assets/icone whats.png',
                texto: '(16) 2359-9851',
                cor: const LinearGradient(
                  colors: [
                    Color(0xFF0FB40A),
                    Color(0xFFA9EC8A),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // 🙏 FINAL
          const Text(
            'A equipe da Colheita Solidária agradece o seu contato!!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D0101),
            ),
          ),

          const SizedBox(height: 10),

          Image.asset(
            'assets/maosdadas.png',
            width: 120,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // 🔧 CARD DE CONTATO
  static Widget _contatoCard({
    required String titulo,
    required String imagem,
    required String texto,
    required Gradient cor,
  }) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: cor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Image.asset(imagem, width: 50),
          const SizedBox(height: 10),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}