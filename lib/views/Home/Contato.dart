import 'package:flutter/material.dart';
import '../../widgets/layouts/Home/DefaultLayoutHome.dart';

class ContatoPage extends StatelessWidget {
  const ContatoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        children: [
          const SizedBox(height: 20),

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

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Primeiro nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Último sobrenome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Assunto',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA50000),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF276772),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Enviar',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

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

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _contatoCard(
                titulo: 'Instagram',
                imagem: 'assets/instabranco.png',
                texto: '@colheita.solidaria',
                cor: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFC13584),
                    Color(0xFFFF2D53),
                    Color(0xFFFFBB00),
                  ],
                ),
              ),

              _contatoCard(
                titulo: 'Email',
                imagem: 'assets/emailbranco.png',
                texto: 'colheitasolidariafatec@gmail.com',
                cor: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0051FF),
                    Color(0xFFABC0F0),
                  ],
                ),
              ),

              _contatoCard(
                titulo: 'WhatsApp',
                imagem: 'assets/whatsbranco.png',
                texto: '(16) 2359-9851',
                cor: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0FB40A),
                    Color(0xFFA9EC8A),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: 'A equipe da Colheita Solidária\n',
                ),

                TextSpan(
                  text: 'agradece o seu contato!!',
                  style: TextStyle(
                    color: Color(0xFF5D0101),
                  ),
                ),
              ],
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

  static Widget _contatoCard({
    required String titulo,
    required String imagem,
    required String texto,
    required Gradient cor,
  }) {
    return Container(
      width: 320,
      height: 230,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: cor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 15),

          Image.asset(
            imagem,
            width: 100,
          ),

          const SizedBox(height: 15),

          Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}