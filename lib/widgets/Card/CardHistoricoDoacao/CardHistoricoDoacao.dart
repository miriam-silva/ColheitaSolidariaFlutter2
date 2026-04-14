import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardHistoricoDoacao extends StatelessWidget {
  final int index;
  final Map<String, dynamic> doacao;

  const CardHistoricoDoacao({
    super.key,
    required this.index,
    required this.doacao,
  });

  String? obterUrlImagem(String? imagemUrl) {
    if (imagemUrl == null) return null;
    return imagemUrl.startsWith("http") ? imagemUrl : null;
  }

  String formatarData(String? data) {
    if (data == null) return "Data indisponível";
    try {
      final dt = DateTime.parse(data);
      return DateFormat('dd/MM/yyyy').format(dt);
    } catch (e) {
      return "Data inválida";
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagemUrl = obterUrlImagem(doacao["imagemUrl"]);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTexto(),
                    const SizedBox(height: 10),
                    if (imagemUrl != null) _buildImagem(imagemUrl),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildTexto()),
                    const SizedBox(width: 10),
                    if (imagemUrl != null)
                      SizedBox(
                        width: 150,
                        child: _buildImagem(imagemUrl),
                      ),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildTexto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "#${index + 1}° Doação - ${doacao["nome"]}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "${doacao["descricao"]} - ${doacao["quantidade"]} unidades",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          "Data de registro: ${formatarData(doacao["dataRegistro"])} | "
          "Validade: ${formatarData(doacao["validade"])}",
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildImagem(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        height: 120,
        fit: BoxFit.cover,
      ),
    );
  }
}