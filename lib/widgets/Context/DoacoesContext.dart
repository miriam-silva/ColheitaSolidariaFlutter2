import 'package:flutter/material.dart';
import '../Hooks/useDoacoes.dart';

class DoacoesContext extends ChangeNotifier {
  List<Map<String, dynamic>> doacoes = [];
  bool carregando = true;
  String? userId;
  String? token;

  void adicionarDoacao(Map<String, dynamic> novaDoacao) {
    doacoes.insert(0, novaDoacao);
    notifyListeners();
  }

  Future<void> carregarDoacoes({String? id}) async {
    carregando = true;
    notifyListeners();

    try {
      final userIdFinal = id ?? userId;

      if (userIdFinal == null || userIdFinal.isEmpty) {
        debugPrint(
          "Usuário não autenticado. Não foi possível carregar doações.",
        );

        doacoes = [];
        carregando = false;
        notifyListeners();
        return;
      }

      debugPrint(
        "Carregando doações para o usuário: $userIdFinal",
      );

      final doacoesDoUsuario =
          await buscarDoacoesPorColaborador(userIdFinal);

      debugPrint(
        "Doações recebidas: ${doacoesDoUsuario.length}",
      );

      doacoes = doacoesDoUsuario;
    } catch (e) {
      debugPrint(
        "Erro ao carregar doações: $e",
      );

      doacoes = [];
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> atualizarUsuario({
    required String novoUserId,
    required String novoToken,
  }) async {
    userId = novoUserId;
    token = novoToken;

    notifyListeners();

    await carregarDoacoes(id: novoUserId);
  }

  void limparDoacoes() {
    doacoes = [];
    carregando = false;
    notifyListeners();
  }
}