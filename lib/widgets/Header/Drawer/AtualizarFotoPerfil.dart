import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/PerfilService.dart';

class AtualizarFotoPerfil extends StatefulWidget {
  const AtualizarFotoPerfil({super.key});

  @override
  State<AtualizarFotoPerfil> createState() => _AtualizarFotoPerfilState();
}

class _AtualizarFotoPerfilState extends State<AtualizarFotoPerfil> {
  File? imagem;
  bool loading = false;

  final picker = ImagePicker();
  final PerfilService perfilService = PerfilService();

  Future<void> selecionarImagem() async {
    final XFile? file =
        await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    setState(() {
      imagem = File(file.path);
    });
  }

  Future<void> salvarFoto() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || imagem == null) return;

    setState(() => loading = true);

    final url = await perfilService.uploadFotoPerfil(
      imagem!,
      user.uid,
    );

    if (!mounted) return;

    if (url == null) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao atualizar foto")),
      );
      return;
    }

    setState(() {
      imagem = null;
      loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Foto atualizada com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Atualizar Foto de Perfil",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        GestureDetector(
          onTap: selecionarImagem,
          child: CircleAvatar(
            radius: 60,
            backgroundImage:
                imagem != null ? FileImage(imagem!) : null,
            child: imagem == null
                ? const Icon(Icons.camera_alt, size: 40)
                : null,
          ),
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: loading ? null : salvarFoto,
          child: loading
              ? const CircularProgressIndicator()
              : const Text("Salvar Foto"),
        ),
      ],
    );
  }
}