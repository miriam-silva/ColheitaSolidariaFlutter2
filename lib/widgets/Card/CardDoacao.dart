import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CardDoacao extends StatefulWidget {
  final String id;
  final String? imagemUrl;
  final String nome;
  final String? validade;
  final String descricao;
  final bool selecionado;
  final VoidCallback onToggle;
  final bool selecionavel;
  final VoidCallback? onToggleFavorito;
  final Function(String)? onRemoverFavorito;

  const CardDoacao({
    super.key,
    required this.id,
    required this.nome,
    required this.descricao,
    required this.selecionado,
    required this.onToggle,
    this.imagemUrl,
    this.validade,
    this.selecionavel = true,
    this.onToggleFavorito,
    this.onRemoverFavorito,
  });

  @override
  State<CardDoacao> createState() => _CardDoacaoState();
}

class _CardDoacaoState extends State<CardDoacao> {
  bool favorito = false;

  @override
  void initState() {
    super.initState();
    carregarFavorito();
  }

  String? obterUrlImagem(String? imagemDoacao) {
    if (imagemDoacao == null || imagemDoacao.isEmpty) {
      return null;
    }

    if (imagemDoacao.startsWith('http')) {
      return imagemDoacao;
    }

    return "https://pyjqpkkscqlokgmdtslk.supabase.co/storage/v1/object/public/doacoes/$imagemDoacao";
  }

  String formatarValidade(String? validade) {
    if (validade == null || validade.isEmpty) {
      return "Não informada";
    }

    try {
      final data = DateTime.parse(validade);
      return DateFormat("dd/MM/yyyy").format(data);
    } catch (e) {
      return validade;
    }
  }

  Future<void> carregarFavorito() async {
    final prefs = await SharedPreferences.getInstance();

    final dadosString = prefs.getString('dadosFavoritos');

    if (dadosString == null || dadosString.isEmpty) return;

    final Map<String, dynamic> dados =
        jsonDecode(dadosString) as Map<String, dynamic>;

    setState(() {
      favorito = dados.containsKey(widget.id);
    });
  }

  void abrirModalNutrientes() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Informações Nutricionais de ${widget.nome}",
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                if (obterUrlImagem(widget.imagemUrl) != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      obterUrlImagem(widget.imagemUrl)!,
                      height: 180,
                    ),
                  ),

                const SizedBox(height: 20),

                const Text(
                  "Informações nutricionais serão exibidas aqui.\n(Integrar API OpenFoodFacts depois)",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 15),

                const Text(
                  "Valores por 100g do alimento",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> toggleFavorito() async {
    final prefs = await SharedPreferences.getInstance();

    final dadosString = prefs.getString('dadosFavoritos');

    Map<String, dynamic> dados = {};

    if (dadosString != null && dadosString.isNotEmpty) {
      dados = jsonDecode(dadosString) as Map<String, dynamic>;
    }

    setState(() {
      favorito = !favorito;
    });

    if (favorito) {
      /// adiciona aos favoritos
      dados[widget.id] = {
        "id": widget.id,
        "nome": widget.nome,
        "descricao": widget.descricao,
        "validade": widget.validade,
        "imagemUrl": widget.imagemUrl,
      };
    } else {
      /// remove dos favoritos
      dados.remove(widget.id);
    }

    await prefs.setString('dadosFavoritos', jsonEncode(dados));

    if (widget.onToggleFavorito != null) {
      widget.onToggleFavorito!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final urlImagem = obterUrlImagem(widget.imagemUrl);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(blurRadius: 5, offset: Offset(2, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// imagem
          if (urlImagem != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                urlImagem,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: 120,
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF5C16C),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Imagens dos alimentos",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),

          const SizedBox(width: 20),

          /// conteúdo
          Expanded(
            child: Column(
              children: [
                Text(
                  widget.nome,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  widget.descricao,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Validade: ${formatarValidade(widget.validade)}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                OutlinedButton(
                  onPressed: abrirModalNutrientes,
                  child: const Text("Ver informações nutricionais"),
                ),
              ],
            ),
          ),

          const SizedBox(width: 15),

          /// ações
          Column(
            children: [
              if (widget.selecionavel)
                Checkbox(
                  value: widget.selecionado,
                  onChanged: (_) {
                    widget.onToggle();
                  },
                ),

              IconButton(
                onPressed: toggleFavorito,
                icon: Icon(
                  favorito ? Icons.favorite : Icons.favorite_border,
                  color: favorito ? Colors.red : null,
                ),
              ),

              if (widget.onRemoverFavorito != null)
                IconButton(
                  onPressed: () {
                    widget.onRemoverFavorito!(widget.id);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
