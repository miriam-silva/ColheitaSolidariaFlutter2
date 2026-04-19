import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<Map<String, dynamic>?> registrarDoacao(
  Map<String, dynamic> dados,
) async {
  try {
    final docRef = await firestore.collection("doacoes").add({
      "nome": dados["nome"],
      "descricao": dados["descricao"],
      "quantidade": dados["quantidade"],
      "validade": dados["validade"],
      "imagemUrl": dados["imagemUrl"],

      "usuarioId": dados["usuarioId"],

      "status": "Disponível",

      "createdAt": FieldValue.serverTimestamp(),
    });

    final novoDoc = await docRef.get();

    return {
      "id": docRef.id,
      ...?novoDoc.data(),
    };
  } catch (e) {
    print("Erro ao registrar doação: $e");
    return null;
  }
}

Future<List<Map<String, dynamic>>> buscarDoacoesPorColaborador(
  String usuarioId,
) async {
  try {
    final snapshot = await firestore
        .collection("doacoes")
        .where(
          "usuarioId",
          isEqualTo: usuarioId,
        )
        .orderBy(
          "createdAt",
          descending: true,
        )
        .get();

    return snapshot.docs.map((doc) {
      return {
        "id": doc.id,
        ...doc.data(),
      };
    }).toList();
  } catch (e) {
    print("Erro ao buscar doações: $e");
    return [];
  }
}

Future<List<Map<String, dynamic>>> buscarTodasDoacoes() async {
  try {
    final snapshot = await firestore
        .collection("doacoes")
        .orderBy(
          "createdAt",
          descending: true,
        )
        .get();

    return snapshot.docs.map((doc) {
      return {
        "id": doc.id,
        ...doc.data(),
      };
    }).toList();
  } catch (e) {
    print("Erro ao buscar todas as doações: $e");
    return [];
  }
}

Future<bool> atualizarDoacao(
  String id,
  Map<String, dynamic> dados,
) async {
  try {
    await firestore
        .collection("doacoes")
        .doc(id)
        .update(dados);

    return true;
  } catch (e) {
    print("Erro ao atualizar doação: $e");
    return false;
  }
}

Future<bool> deletarDoacao(
  String id,
) async {
  try {
    await firestore
        .collection("doacoes")
        .doc(id)
        .delete();

    return true;
  } catch (e) {
    print("Erro ao deletar doação: $e");
    return false;
  }
}