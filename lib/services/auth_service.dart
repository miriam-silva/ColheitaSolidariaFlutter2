import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔐 REGISTRO
  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String password,
    required String cpf,
    required String role,
  }) async {
    try {
      // 🔹 Cria usuário no Auth
      UserCredential res = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = res.user;

      if (user == null) {
        throw Exception("Erro ao criar usuário");
      }

      // 🔹 Salva no Firestore
      await _db.collection("users").doc(user.uid).set({
        "email": email,
        "cpf": cpf,
        "role": role,
      });

      return {"success": true};
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  // 🔐 LOGIN
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // 🔹 Login no Auth
      UserCredential res = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = res.user;

      if (user == null) {
        throw Exception("Usuário não encontrado");
      }

      // 🔹 Busca dados no Firestore
      DocumentSnapshot userDoc =
          await _db.collection("users").doc(user.uid).get();

      if (!userDoc.exists) {
        throw Exception("Usuário não encontrado no Firestore");
      }

      return {
        "success": true,
        "data": userDoc.data(),
      };
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  // 🚪 LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }
}