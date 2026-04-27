import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

Future<List<Map<String, dynamic>>> buscarHistoricoSolicitacoes() async {
  try {
    final user = auth.currentUser;

    if (user == null) {
      print("Usuário não identificado.");
      return [];
    }

    final usuarioId = user.uid;

    final snapshot = await firestore
        .collection("solicitacoes")
        .where("recebedorId", isEqualTo: usuarioId)
        .orderBy("createdAt", descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return {
        "id": doc.id,
        "status": data["status"] ?? "",
        "dataSolicitacao": data["createdAt"],

        /// cria o objeto doacao que sua tela espera
        "doacao": {
          "titulo": data["nomeDoacao"] ?? "",
          "descricao": data["descricaoDoacao"] ?? "",
          "imagemUrl": data["imagemUrl"] ?? "",
        }
      };
    }).toList();
  } catch (e) {
    print("Erro ao buscar histórico: $e");
    return [];
  }
}