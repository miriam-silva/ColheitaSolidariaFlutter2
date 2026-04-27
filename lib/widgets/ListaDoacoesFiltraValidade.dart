import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/Card/CardDoacao.dart';
import '../widgets/LoadingSpinner.dart';

class ListaDoacoesFiltraValidade extends StatefulWidget {
  final Function(String)? onSelecionar;
  final List<String> selecionados;

  const ListaDoacoesFiltraValidade({
    super.key,
    this.onSelecionar,
    this.selecionados = const [],
  });

  @override
  State<ListaDoacoesFiltraValidade> createState() =>
      _ListaDoacoesFiltraValidadeState();
}

class _ListaDoacoesFiltraValidadeState
    extends State<ListaDoacoesFiltraValidade> {
  List<Map<String, dynamic>> doacoes = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    carregarDoacoes();
  }

  Future<void> carregarDoacoes() async {
    setState(() {
      loading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('doacoes')
          .orderBy('createdAt', descending: true)
          .get();

      final hoje = DateTime.now();

      final listaFiltrada = snapshot.docs
          .map((doc) {
            final data = doc.data();

            return {
              'id': doc.id,
              'nome': data['nome'] ?? '',
              'descricao': data['descricao'] ?? '',
              'validade': data['validade'],
              'imagemUrl': data['imagemUrl'] ?? '',
            };
          })
          .where((doacao) {
            if (doacao['validade'] == null) {
              return true;
            }

            try {
              DateTime validade;

              final valor = doacao['validade'];

              if (valor is Timestamp) {
                validade = valor.toDate();
              } else {
                validade = DateTime.parse(valor.toString());
              }

              return validade.isAfter(hoje) ||
                  validade.isAtSameMomentAs(hoje);
            } catch (e) {
              return true;
            }
          })
          .toList();

      setState(() {
        doacoes = listaFiltrada;
      });
    } catch (e) {
      debugPrint("Erro ao buscar doações: $e");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: LoadingSpinner(),
        ),
      );
    }

    if (doacoes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            "Nenhuma doação disponível no momento.",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Column(
      children: doacoes.map((doacao) {
        final String id = doacao['id'];

        return CardDoacao(
          id: id,
          imagemUrl: doacao['imagemUrl'],
          nome: doacao['nome'],
          validade: doacao['validade']?.toString(),
          descricao: doacao['descricao'],
          selecionado: widget.selecionados.contains(id),
          onToggle: () {
            if (widget.onSelecionar != null) {
              widget.onSelecionar!(id);
            }
          },
        );
      }).toList(),
    );
  }
}