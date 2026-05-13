import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  }) async {

    try {

      /// GOOGLE SIGN IN
      final GoogleSignIn
          googleSignIn =
          GoogleSignIn(
        scopes: ['email'],
      );

      /// FORÇA ESCOLHA DE CONTA
      await googleSignIn.signOut();

      /// ABRE CONTAS GOOGLE
      final GoogleSignInAccount?
          googleUser =
          await googleSignIn
              .signIn();

      /// CANCELADO
      if (googleUser == null) {

        return {
          "success": false,
          "error":
              "Login cancelado"
        };
      }

      /// TOKENS GOOGLE
      final googleAuth =
          await googleUser
              .authentication;

      /// CREDENCIAL FIREBASE
      final credential =
          GoogleAuthProvider
              .credential(

        accessToken:
            googleAuth.accessToken,

        idToken:
            googleAuth.idToken,
      );

      /// LOGIN FIREBASE
      final userCredential =
          await _auth
              .signInWithCredential(
        credential,
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

      final uid = user.uid;

      /// BUSCA USER
      final userDoc =
          await _firestore
              .collection('users')
              .doc(uid)
              .get();

      /// CRIA USUÁRIO
      if (!userDoc.exists) {

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

          "dataNascimento": "",

          "createdAt":
              FieldValue
                  .serverTimestamp(),
        });
      }

      /// BUSCA NOVAMENTE
      final updatedDoc =
          await _firestore
              .collection('users')
              .doc(uid)
              .get();

      final userData =
          updatedDoc.data()!;

      /// ROLE
      if (userData["role"] !=
          tipoUsuario) {

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

    } on FirebaseAuthException catch (e) {

      return {
        "success": false,
        "error":
            e.message ??
                "Erro autenticação Google"
      };

    } catch (e) {

      return {
        "success": false,
        "error":
            "Erro login Google"
      };
    }
  }

  /// LOGOUT
  Future<void> logout() async {

    await GoogleSignIn().signOut();

    await FirebaseAuth.instance
        .signOut();
  }
}