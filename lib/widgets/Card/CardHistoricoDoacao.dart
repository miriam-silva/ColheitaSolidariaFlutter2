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
    if (imagemUrl == null || imagemUrl.isEmpty) return null;

    if (imagemUrl.startsWith("http")) {
      return imagemUrl;
    }

    return null;
  }

  String formatarData(dynamic data) {
    if (data == null) return "Data indisponível";

    try {
      if (data is String) {
        final dt = DateTime.parse(data);
        return DateFormat('dd/MM/yyyy').format(dt);
      }

      if (data.runtimeType.toString() == "Timestamp") {
        final dt = data.toDate();
        return DateFormat('dd/MM/yyyy').format(dt);
      }

      return "Data inválida";
    } catch (e) {
      return "Data inválida";
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagemUrl = obterUrlImagem(doacao["imagemUrl"]);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
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
                    const SizedBox(height: 12),
                    if (imagemUrl != null)
                      _buildImagem(imagemUrl),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildTexto(),
                    ),
                    const SizedBox(width: 12),
                    if (imagemUrl != null)
                      SizedBox(
                        width: 160,
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
          "#${index + 1}° Doação - ${doacao["nome"] ?? "Sem nome"}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Descrição: ${doacao["descricao"] ?? "Não informada"}",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          "Quantidade: ${doacao["quantidade"] ?? "0"} unidades",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          "Data de registro: ${formatarData(doacao["createdAt"])}",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          "Validade: ${formatarData(doacao["validade"])}",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          "Status: ${doacao["status"] ?? "Disponível"}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildImagem(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        url,
        height: 130,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 130,
            alignment: Alignment.center,
            child: const Text(
              "Imagem indisponível",
            ),
          );
        },
      ),
    );
  }
}