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
      // 🔐 Login com Firebase Auth
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // 📄 Buscar dados do usuário no Firestore
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        return {"success": false, "error": "Usuário não encontrado"};
      }

      final userData = userDoc.data()!;

      // 🔐 Verifica tipo
      if (userData['role'] != tipoUsuario) {
        return {"success": false, "error": "Tipo de usuário incorreto"};
      }

      // 🔐 Se for admin → validar CNPJ + chave
      if (tipoUsuario == "admin") {
        if (userData['cnpj'] != cnpj) {
          return {"success": false, "error": "CNPJ inválido"};
        }

        final configDoc =
            await _firestore.collection('config').doc('chaves_de_acesso').get();

        final chaves = List<String>.from(configDoc['chaves_de_acesso']);

        if (!chaves.contains(chaveAcesso)) {
          return {"success": false, "error": "Chave de acesso inválida"};
        }
      }

      return {"success": true, "data": userData};
    } catch (e) {
      return {"success": false, "error": "Erro ao fazer login"};
    }
  }
}