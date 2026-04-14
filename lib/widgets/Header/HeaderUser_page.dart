import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CustomHeader extends StatefulWidget implements PreferredSizeWidget {
  final String role;

  const CustomHeader({super.key, required this.role});

  @override
  State<CustomHeader> createState() => _CustomHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _CustomHeaderState extends State<CustomHeader> {
  String nomeUsuario = "Usuário";
  String emailUsuario = "";
  String fotoPerfil = "";

  @override
  void initState() {
    super.initState();
    buscarDadosUsuario();
  }

  Future<void> buscarDadosUsuario() async {
    try {
      final response = await http.get(
        Uri.parse("http://SEU_BACKEND/api/Auth/me"),
        headers: {
          "Authorization": "Bearer SEU_TOKEN",
        },
      );

      if (response.statusCode == 200) {
        final usuario = jsonDecode(response.body);

        setState(() {
          nomeUsuario = usuario["nomeCompleto"] ?? "Usuário";
          emailUsuario = usuario["email"] ?? "";
          fotoPerfil = usuario["fotoPerfil"] ?? "";
        });
      }
    } catch (e) {
      print("Erro ao carregar usuário: $e");
    }
  }

  Future<void> selecionarFoto() async {
    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      File file = File(imagem.path);

      // ⚠️ Aqui você integra com seu upload (Supabase/Firebase)
      print("Imagem selecionada: ${file.path}");
    }
  }

  List<Map<String, dynamic>> getMenus() {
    switch (widget.role) {
      case "admin":
        return [
          {"label": "Início", "route": "/InicialAdministrador"},
          {"label": "Pedidos", "route": "/adm/Pedidos"},
          {"label": "Doações", "route": "/adm/Doacoes"},
          {"label": "Cadastrar recebedor", "route": "/adm/cadastrar"},
          {"label": "Gerenciar usuários", "route": "/adm/usuarios"},
        ];

      case "colaborador":
        return [
          {"label": "Minhas doações", "route": "/InicialColaborador"},
          {"label": "Registrar doações", "route": "/registrar"},
        ];

      case "recebedor":
        return [
          {"label": "Doações", "route": "/InicialRecebedor"},
          {"label": "Minhas solicitações", "route": "/solicitacoes"},
          {"label": "Favoritos", "route": "/favoritos"},
        ];

      default:
        return [];
    }
  }

  void abrirPerfilModal() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Meu Perfil"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: fotoPerfil.isNotEmpty
                  ? NetworkImage(fotoPerfil)
                  : null,
              child: fotoPerfil.isEmpty ? Icon(Icons.person, size: 50) : null,
            ),
            const SizedBox(height: 10),
            Text(nomeUsuario),
            Text(emailUsuario),
            Text("Tipo: ${widget.role}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/atualizarDados");
            },
            child: const Text("Atualizar dados"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  void logout() {
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      title: Image.asset("assets/logotp.png", height: 50),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {
              Scaffold.of(context).openEndDrawer();
            },
            child: CircleAvatar(
              backgroundImage:
                  fotoPerfil.isNotEmpty ? NetworkImage(fotoPerfil) : null,
              child: fotoPerfil.isEmpty ? Icon(Icons.person) : null,
            ),
          ),
        )
      ],
    );
  }
}