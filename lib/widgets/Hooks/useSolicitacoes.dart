import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

class SolicitacaoService {
  Future<bool> registrarSolicitacao({
    required String doacaoId,
    int quantidade = 1,
  }) async {
    try {
      /// pega usuário autenticado
      final user = auth.currentUser;

      if (user == null) {
        print("Usuário não identificado.");
        return false;
      }

      final usuarioId = user.uid;

      /// busca dados da doação
      final doacaoDoc = await firestore
          .collection("doacoes")
          .doc(doacaoId)
          .get();

      if (!doacaoDoc.exists) {
        print("Doação não encontrada.");
        return false;
      }

      final dadosDoacao = doacaoDoc.data();

      /// registra solicitação
      await firestore.collection("solicitacoes").add({
        "doacaoId": doacaoId,
        "recebedorId": usuarioId,
        "quantidadeSolicitada": quantidade,

        "nomeDoacao": dadosDoacao?["nome"] ?? "",
        "descricaoDoacao": dadosDoacao?["descricao"] ?? "",
        "imagemUrl": dadosDoacao?["imagemUrl"] ?? "",
        "status": "Pendente",

        "createdAt": FieldValue.serverTimestamp(),
      });

      print("Solicitação registrada com sucesso.");
      return true;
    } catch (e) {
      print("Erro ao registrar solicitação: $e");
      return false;
    }
  }
}