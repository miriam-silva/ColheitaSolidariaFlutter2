import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/Card/CardDoacao.dart';
import '../../../widgets/layouts/Receb/DefaultLayoutReceb.dart';
import '../InicialReceb/InicialRecebedor.dart';

class Favoritos extends StatefulWidget {
  const Favoritos({super.key});

  @override
  State<Favoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  List<Map<String, dynamic>> favoritos = [];

  @override
  void initState() {
    super.initState();
    atualizarFavoritos();
  }

  Future<void> atualizarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();

    /// equivalente ao localStorage.getItem('dadosFavoritos')
    final dadosString = prefs.getString('dadosFavoritos');

    if (dadosString == null || dadosString.isEmpty) {
      setState(() {
        favoritos = [];
      });
      return;
    }

    final Map<String, dynamic> dados =
        jsonDecode(dadosString) as Map<String, dynamic>;

    final listaFavoritos = dados.values
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    setState(() {
      favoritos = listaFavoritos;
    });
  }

  Future<void> removerFavorito(String id) async {
    final prefs = await SharedPreferences.getInstance();

    final dadosString = prefs.getString('dadosFavoritos');

    if (dadosString == null || dadosString.isEmpty) return;

    final Map<String, dynamic> dados =
        jsonDecode(dadosString) as Map<String, dynamic>;

    dados.remove(id);

    await prefs.setString('dadosFavoritos', jsonEncode(dados));

    atualizarFavoritos();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayoutRecebedor(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// faixa laranja
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF6C973),
              border: Border.all(color: const Color(0xFFC1554C), width: 5),
            ),
            child: const Text(
              "Minhas doações favoritas:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),

          favoritos.isNotEmpty
              ? Column(
                  children: favoritos.map((doacao) {
                    return CardDoacao(
                      id: doacao["id"] ?? "",
                      imagemUrl: doacao["imagemUrl"],
                      nome: doacao["nome"] ?? "",
                      validade: doacao["validade"]?.toString(),
                      descricao: doacao["descricao"] ?? "",

                      selecionavel: false,

                      /// obrigatórios
                      selecionado: false,
                      onToggle: () {},

                      /// remover favorito
                      onRemoverFavorito: (id) {
                        removerFavorito(id);
                      },
                    );
                  }).toList(),
                )
              : Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 30),
                  child: const Center(
                    child: Text(
                      "Você não tem doações favoritas",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFA18654),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

          const SizedBox(height: 40),

          /// botão voltar
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const InicialRecebedor()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF276772),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Voltar",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
