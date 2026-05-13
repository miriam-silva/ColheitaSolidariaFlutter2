import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// LOGIN EMAIL E SENHA
  Future<Map<String, dynamic>> loginUser({

    required String email,
    required String password,

    String? cnpj,
    String? chaveAcesso,

    required String tipoUsuario,

  }) async {

    try {

      final userCredential =
          await _auth
              .signInWithEmailAndPassword(

        email: email,
        password: password,
      );

      final user =
          userCredential.user;

      if (user == null) {

        return {
          "success": false,
          "error":
              "Usuário não autenticado"
        };
      }

      await user.reload();

      await user.getIdToken(true);

      final uid = user.uid;

      final userDoc =
          await _firestore
              .collection('users')
              .doc(uid)
              .get();

      if (!userDoc.exists) {

        await logout();

        return {
          "success": false,
          "error":
              "Usuário não encontrado"
        };
      }

      final userData =
          userDoc.data()!;

      /// ROLE
      if (userData['role'] !=
          tipoUsuario) {

        await logout();

        return {
          "success": false,
          "error":
              "Tipo de usuário incorreto"
        };
      }

      /// ADMIN
      if (tipoUsuario == "admin") {

        if (userData['cnpj'] !=
            cnpj) {

          await logout();

          return {
            "success": false,
            "error":
                "CNPJ inválido"
          };
        }

        final configDoc =
            await _firestore
                .collection('config')
                .doc(
                    'chaves_de_acesso')
                .get();

        if (!configDoc.exists) {

          await logout();

          return {
            "success": false,
            "error":
                "Configuração não encontrada"
          };
        }

        final chaves =
            List<String>.from(

          configDoc.data()![
              'chaves_de_acesso'],
        );

        if (!chaves.contains(
            chaveAcesso)) {

          await logout();

          return {
            "success": false,
            "error":
                "Chave de acesso inválida"
          };
        }
      }

      return {
        "success": true,
        "data": userData,
      };

    } on FirebaseAuthException catch (e) {

      return {
        "success": false,
        "error":
            e.message ??
                "Erro autenticação"
      };

    } catch (e) {

      return {
        "success": false,
        "error":
            "Erro ao fazer login"
      };
    }
  }

  /// LOGIN GOOGLE
  Future<Map<String, dynamic>>
      signInWithGoogle({

    required String tipoUsuario,

    bool cadastro = false,

  }) async {

    try {

      UserCredential
          userCredential;

      /// WEB
      if (kIsWeb) {

        final googleProvider =
            GoogleAuthProvider();

        userCredential =
            await _auth
                .signInWithPopup(
          googleProvider,
        );

      }

      /// MOBILE
      else {

        final googleProvider =
            GoogleAuthProvider();

        userCredential =
            await _auth
                .signInWithProvider(
          googleProvider,
        );
      }

      final user =
          userCredential.user;

      if (user == null) {

        return {
          "success": false,
          "error":
              "Usuário não autenticado"
        };
      }

      final uid = user.uid;

      /// BUSCA USER
      final userDoc =
          await _firestore
              .collection('users')
              .doc(uid)
              .get();

      /// CADASTRO GOOGLE
      if (cadastro) {

        if (userDoc.exists) {

          await logout();

          return {
            "success": false,
            "error":
                "Conta já cadastrada"
          };
        }

        await _firestore
            .collection('users')
            .doc(uid)
            .set({

          "email": user.email,

          "nome":
              user.displayName ?? "",

          "fotoPerfil":
              user.photoURL ?? "",

          "role": tipoUsuario,

          "telefone": "",

          "cpf": "",

          "cnpj": null,

          "endereco": "",

          "dataNascimento": "",

          "createdAt":
              FieldValue
                  .serverTimestamp(),
        });

        final createdDoc =
            await _firestore
                .collection('users')
                .doc(uid)
                .get();

        return {
          "success": true,
          "data":
              createdDoc.data(),
        };
      }

      /// LOGIN GOOGLE
      else {

        /// NÃO CADASTRADO
        if (!userDoc.exists) {

          await logout();

          return {
            "success": false,
            "error":
                "Conta não cadastrada. Faça o cadastro primeiro."
          };
        }

        final userData =
            userDoc.data()!;

        /// ROLE
        if (userData["role"] !=
            tipoUsuario) {

          await logout();

          return {
            "success": false,
            "error":
                "Tipo de usuário incorreto"
          };
        }

        return {
          "success": true,
          "data": userData,
        };
      }

    } on FirebaseAuthException catch (e) {

      return {
        "success": false,
        "error":
            e.message ??
                "Erro autenticação Google"
      };

    } catch (e) {

      debugPrint(
          "ERRO GOOGLE LOGIN: $e");

      return {
        "success": false,
        "error":
            "Erro login Google"
      };
    }
  }

  /// LOGOUT
  Future<void> logout() async {

    await FirebaseAuth.instance
        .signOut();
  }
}