import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MeuDrawer extends StatefulWidget {
  final String role;

  const MeuDrawer({super.key, required this.role});

  @override
  State<MeuDrawer> createState() => _MeuDrawerState();
}

class _MeuDrawerState extends State<MeuDrawer> {
  String nomeUsuario = "Usuário";
  String emailUsuario = "email@email.com";
  String fotoPerfil = "assets/receptor.png";

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    carregarUsuario();
  }

  void carregarUsuario() {
    setState(() {
      nomeUsuario = "Miriam";
      emailUsuario = "miriam@email.com";
    });
  }

  // 📸 Escolher imagem (IGUAL React - só seleciona)
  Future<void> escolherImagem() async {
    final XFile? imagem =
        await _picker.pickImage(source: ImageSource.gallery);

    if (imagem == null) return;

    // 👉 aqui você chama seu "usePerfil"
    final resultado = await uploadFotoPerfil(File(imagem.path));

    if (resultado["sucesso"]) {
      setState(() {
        fotoPerfil = resultado["fotoUrl"];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto atualizada com sucesso!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: ${resultado["mensagem"]}")),
      );
    }
  }

  // 🚪 Logout
  void logout() {
    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
  }

  // 📌 Menus dinâmicos (igual React)
  List<Map<String, dynamic>> getMenus() {
    switch (widget.role) {
      case "admin":
        return [
          {"label": "Início", "route": "/InicialAdministrador"},
          {"label": "Pedidos", "route": "/adm/pedidos"},
          {"label": "Doações", "route": "/adm/doacoes"},
          {"label": "Cadastrar recebedor", "route": "/adm/cadastrar"},
          {"label": "Gerenciar usuários", "route": "/adm/usuarios"},
          {"label": "Alterar foto de perfil", "action": escolherImagem},
        ];

      case "colaborador":
        return [
          {"label": "Minhas doações", "route": "/InicialColaborador"},
          {"label": "Registrar doações", "route": "/colaborador/registrar"},
          {"label": "Alterar foto de perfil", "action": escolherImagem},
        ];

      case "recebedor":
        return [
          {"label": "Doações", "route": "/InicialRecebedor"},
          {"label": "Minhas solicitações", "route": "/recebedor/solicitacoes"},
          {"label": "Favoritos", "route": "/recebedor/favoritos"},
          {"label": "Alterar foto de perfil", "action": escolherImagem},
        ];

      default:
        return [];
    }
  }

  // 🔥 SIMULA SEU usePerfil (depois você liga com Firebase/Supabase)
  Future<Map<String, dynamic>> uploadFotoPerfil(File imagem) async {
    try {
      // aqui vai sua lógica real (Firebase ou Supabase)
      await Future.delayed(const Duration(seconds: 1));

      return {
        "sucesso": true,
        "fotoUrl": imagem.path, // simulação
      };
    } catch (e) {
      return {
        "sucesso": false,
        "mensagem": e.toString(),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final menus = getMenus();

    return Drawer(
      width: 300, // igual seu CSS
      child: Column(
        children: [
          // 🔴 HEADER
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
                    backgroundImage: fotoPerfil.startsWith("assets")
                        ? AssetImage(fotoPerfil) as ImageProvider
                        : FileImage(File(fotoPerfil)),
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

          // 📌 MENUS
          Expanded(
            child: ListView(
              children: menus.map((menu) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF276772),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, menu["route"]);
                    },
                    child: Text(menu["label"]),
                  ),
                );
              }).toList(),
            ),
          ),

          // 🚪 LOGOUT
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