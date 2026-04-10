import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
    String? cnpj,
    String? chaveAcesso,
    required String tipoUsuario,
  }) async {
    try {
      // 🔐 LOGIN
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user == null) {
        return {"success": false, "error": "Usuário não autenticado"};
      }

      // 🔥 GARANTE TOKEN ATUALIZADO
      await user.reload();
      await user.getIdToken(true);

      final uid = user.uid;

      // 📄 BUSCA USER
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        return {"success": false, "error": "Usuário não encontrado"};
      }

      final userData = userDoc.data()!;

      // 🔐 VERIFICA ROLE
      if (userData['role'] != tipoUsuario) {
        return {"success": false, "error": "Tipo de usuário incorreto"};
      }

      // 🔐 ADMIN
      if (tipoUsuario == "admin") {
        if (userData['cnpj'] != cnpj) {
          return {"success": false, "error": "CNPJ inválido"};
        }

        // 🔥 tenta pegar config
        final configDoc = await _firestore
            .collection('config')
            .doc('chaves_de_acesso')
            .get();

        if (!configDoc.exists) {
          return {"success": false, "error": "Configuração não encontrada"};
        }

        final chaves =
            List<String>.from(configDoc.data()!['chaves_de_acesso']);

        if (!chaves.contains(chaveAcesso)) {
          return {"success": false, "error": "Chave de acesso inválida"};
        }
      }

      return {"success": true, "data": userData};
    } on FirebaseAuthException catch (e) {
      return {
        "success": false,
        "error": e.message ?? "Erro de autenticação"
      };
    } catch (e) {
      return {"success": false, "error": "Erro ao fazer login"};
    }
  }
}