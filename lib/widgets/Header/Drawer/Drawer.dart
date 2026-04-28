import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/PerfilService.dart';

class MeuDrawer extends StatefulWidget {
  final String role;

  const MeuDrawer({super.key, required this.role});

  @override
  State<MeuDrawer> createState() => _MeuDrawerState();
}

class _MeuDrawerState extends State<MeuDrawer> {
  String nomeUsuario = "Carregando...";
  String emailUsuario = "";
  String fotoPerfil = "assets/receptor.png";

  final ImagePicker _picker = ImagePicker();
  final PerfilService perfilService = PerfilService();

  @override
  void initState() {
    super.initState();
    carregarUsuario();
  }

  Future<void> carregarUsuario() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      final data = doc.data();

      if (!mounted) return;

      setState(() {
        nomeUsuario = data?["nome"] ?? "Usuário";
        emailUsuario = data?["email"] ?? user.email ?? "";

        fotoPerfil = data != null && data.containsKey("fotoPerfil")
            ? data["fotoPerfil"]
            : fotoPerfil;
      });
    } catch (e) {
      print("Erro ao carregar usuário: $e");
    }
  }

  Future<void> escolherImagem() async {
    final XFile? imagem = await _picker.pickImage(source: ImageSource.gallery);

    if (imagem == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final url = await perfilService.uploadFotoPerfil(
      File(imagem.path),
      user.uid,
    );

    if (!mounted) return;

    if (url != null) {
      setState(() {
        fotoPerfil = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto atualizada com sucesso!")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Erro ao atualizar foto")));
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pop(context);
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamedAndRemoveUntil("/home", (route) => false);
  }

  List<Map<String, dynamic>> getMenus() {
    switch (widget.role) {
      case "admin":
        return [
          {"label": "Início", "route": "/admin"},
          {"label": "Pedidos", "route": "/adm/pedidos"},
          {"label": "Doações", "route": "/adm/doacoes"},
          {"label": "Cadastrar recebedor", "route": "/adm/cadastrar"},
          {"label": "Gerenciar usuários", "route": "/adm/usuarios"},
          {"label": "Alterar foto de perfil", "action": escolherImagem},
        ];

      case "colaborador":
        return [
          {"label": "Minhas doações", "route": "/colaborador"},
          {
            "label": "Registrar doações",
            "route": "/colaborador/Registrardoacao",
          },
          {"label": "Minhas doações", "route": "/colaborador/MinhasDoacoes"},
          {"label": "Alterar foto de perfil", "action": escolherImagem},
        ];

      case "recebedor":
        return [
          {"label": "Doações", "route": "/recebedor"},
          {
            "label": "Minhas solicitações",
            "route": "/recebedor/MinhasSolicitacoes",
          },
          {"label": "Favoritos", "route": "/recebedor/Favoritos"},
          {"label": "Alterar foto de perfil", "action": escolherImagem},
        ];

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final menus = getMenus();

    return Drawer(
      width: 300,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFFA50000),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: escolherImagem,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: fotoPerfil.startsWith("http")
                        ? NetworkImage(fotoPerfil)
                        : AssetImage(fotoPerfil) as ImageProvider,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  nomeUsuario,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  emailUsuario,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView(
              children: menus.map((menu) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF276772),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    onPressed: () {
                      Navigator.pop(context);

                      if (menu["route"] != null) {
                        Navigator.pushNamed(context, menu["route"]);
                      } else {
                        (menu["action"] as Function)();
                      }
                    },
                    child: Text(menu["label"]),
                  ),
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA50000),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: logout,
              child: const Text("Sair"),
            ),
          ),
        ],
      ),
    );
  }
}
