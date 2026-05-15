import 'package:flutter/material.dart';
import '../../widgets/layouts/Home/DefaultLayoutHome.dart';
import '../../widgets/Card/CardColaborador.dart';

class ColaboradoresPage extends StatelessWidget {
  const ColaboradoresPage({super.key});

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
                Expanded(
                  child: Image.asset('assets/icon.png', height: 80),
                ),

                const SizedBox(width: 10),

                const Expanded(
                  flex: 2,
                  child: Text(
                    'Nosso trabalho não seria possível sem a dedicação e o apoio dos nossos colaboradores.\n\n'
                    'Agricultores desempenham um papel crucial em nossa missão.\n\n'
                    'Conheça alguns dos nossos colaboradores e veja como eles estão ajudando a transformar vidas!',
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Image.asset('assets/icon.png', height: 80),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          ColaboradorCard(
            nome: 'Agricultor Roberto',
            texto: 'Roberto Rodriguez ajudou doando verduras da sua horta! Como: Alface tomates e pimentões',
            imagem: 'assets/fotocolaborador.png',
            direita: false,
          ),

          ColaboradorCard(
            nome: 'Agricultora Márcia',
            texto: 'Márcia Gonzales ajudou doando muitos alimentos de sua própria lavoura! Alimentos como: Arroz, milho e feijão.',
            imagem: 'assets/Fotocolaboradora.png',
            direita: true,
          ),

          ColaboradorCard(
            nome: 'Fazendeiro Carlos',
            texto: 'Carlos Silva contribuiu generosamente doando muitos alimentos de sua própria fazenda! Alimentos como: batata, cenoura e tomate.',
            imagem: 'assets/fotocolaborador.png',
            direita: false,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}