import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

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

  Widget _infoNutricional(
    String titulo,
    String valor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(valor),
        ],
      ),
    );
  }

  Future<void> abrirModalNutrientes() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: SizedBox(
          height: 120,
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                "Buscando informações nutricionais...",
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final result =
          await OpenFoodAPIClient.searchProducts(
        null,
        ProductSearchQueryConfiguration(
          version: ProductQueryVersion.v3,
          parametersList: [
            SearchTerms(
              terms: [
                widget.nome
                    .toLowerCase()
                    .trim(),
              ],
            ),
          ],
          language:
              OpenFoodFactsLanguage.PORTUGUESE,
        ),
      );

      Navigator.pop(context);

      if (result.products == null ||
          result.products!.isEmpty) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(
              "Produto não encontrado",
            ),
            content: const Text(
              "Não foi possível localizar informações nutricionais.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Fechar"),
              ),
            ],
          ),
        );

        return;
      }

      final produtosValidos = result.products!
          .where((p) => p.nutriments != null)
          .toList();

      if (produtosValidos.isEmpty) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(
              "Informações indisponíveis",
            ),
            content: const Text(
              "Não foram encontrados dados nutricionais para este alimento.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Fechar"),
              ),
            ],
          ),
        );

        return;
      }

      final produto = produtosValidos.first;

      final calorias =
          produto.nutriments?.getValue(
                Nutrient.energyKCal,
                PerSize.oneHundredGrams,
              ) ??
              0;

      final proteinas =
          produto.nutriments?.getValue(
                Nutrient.proteins,
                PerSize.oneHundredGrams,
              ) ??
              0;

      final carboidratos =
          produto.nutriments?.getValue(
                Nutrient.carbohydrates,
                PerSize.oneHundredGrams,
              ) ??
              0;

      final gorduras =
          produto.nutriments?.getValue(
                Nutrient.fat,
                PerSize.oneHundredGrams,
              ) ??
              0;

      final sodio =
          produto.nutriments?.getValue(
                Nutrient.sodium,
                PerSize.oneHundredGrams,
              ) ??
              0;

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              "Informações Nutricionais\n${widget.nome}",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _infoNutricional(
                  "Calorias",
                  "$calorias kcal",
                ),
                _infoNutricional(
                  "Proteínas",
                  "$proteinas g",
                ),
                _infoNutricional(
                  "Carboidratos",
                  "$carboidratos g",
                ),
                _infoNutricional(
                  "Gorduras",
                  "$gorduras g",
                ),
                _infoNutricional(
                  "Sódio",
                  "$sodio g",
                ),
                const SizedBox(height: 15),
                const Text(
                  "Valores por 100g",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
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
    } catch (e) {
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            "Informações indisponíveis",
          ),
          content: const Text(
            "Não foi possível carregar os dados nutricionais deste alimento no momento.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Fechar"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> toggleFavorito() async {
    final prefs = await SharedPreferences.getInstance();

    final dadosString =
        prefs.getString('dadosFavoritos');

    Map<String, dynamic> dados = {};

    if (dadosString != null &&
        dadosString.isNotEmpty) {
      dados = jsonDecode(dadosString)
          as Map<String, dynamic>;
    }

    setState(() {
      favorito = !favorito;
    });

    if (favorito) {
      dados[widget.id] = {
        "id": widget.id,
        "nome": widget.nome,
        "descricao": widget.descricao,
        "validade": widget.validade,
        "imagemUrl": widget.imagemUrl,
      };
    } else {
      dados.remove(widget.id);
    }

    await prefs.setString(
      'dadosFavoritos',
      jsonEncode(dados),
    );

    if (widget.onToggleFavorito != null) {
      widget.onToggleFavorito!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final urlImagem =
        obterUrlImagem(widget.imagemUrl);

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [

          if (urlImagem != null)
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(12),
              child: Image.network(
                urlImagem,
                width: 120,
                height: 120,
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
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: const Text(
                "Imagem",
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  widget.nome,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  widget.descricao,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Validade: ${formatarValidade(widget.validade)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  child: ElevatedButton.icon(
                    onPressed:
                        abrirModalNutrientes,

                    icon: const Icon(
                      Icons.restaurant_menu,
                      color: Colors.white,
                      size: 18,
                    ),

                    label: const Text(
                      "Informações Nutricionais",

                      overflow:
                          TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                              0xFFA42525),

                      foregroundColor:
                          Colors.white,

                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                14),
                      ),

                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

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
                  favorito
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color:
                      favorito ? Colors.red : null,
                ),
              ),

              if (widget.onRemoverFavorito !=
                  null)
                IconButton(
                  onPressed: () {
                    widget.onRemoverFavorito!(
                      widget.id,
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}