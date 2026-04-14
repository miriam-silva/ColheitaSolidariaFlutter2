import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AtualizarFotoPerfil extends StatefulWidget {
  const AtualizarFotoPerfil({super.key});

  @override
  State<AtualizarFotoPerfil> createState() => _AtualizarFotoPerfilState();
}

class _AtualizarFotoPerfilState extends State<AtualizarFotoPerfil> {
  final ImagePicker _picker = ImagePicker();
  XFile? imagemSelecionada;

  // 📸 selecionar imagem
  Future<void> selecionarImagem() async {
    final XFile? imagem =
        await _picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      setState(() {
        imagemSelecionada = imagem;
      });
    }
  }

  // 🚀 upload (equivalente ao handleUpload)
  Future<void> handleUpload() async {
    if (imagemSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione uma imagem primeiro!")),
      );
      return;
    }

    try {
      // 🔥 AQUI você conecta com seu hook / API
      // exemplo:
      // final resultado = await uploadFotoPerfil(imagemSelecionada);

      await Future.delayed(const Duration(seconds: 1)); // simulação

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto atualizada com sucesso!")),
      );

      setState(() {
        imagemSelecionada = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atualizar Foto de Perfil"),
        backgroundColor: const Color(0xFFA50000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Atualizar Foto de Perfil",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // 🖼️ preview da imagem
            GestureDetector(
              onTap: selecionarImagem,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[300],
                backgroundImage: imagemSelecionada != null
                    ? FileImage(File(imagemSelecionada!.path))
                    : null,
                child: imagemSelecionada == null
                    ? const Icon(Icons.camera_alt, size: 40)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            // 📸 botão selecionar
            ElevatedButton(
              onPressed: selecionarImagem,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF276772),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Selecionar imagem"),
            ),

            const SizedBox(height: 10),

            // 🚀 botão enviar
            ElevatedButton(
              onPressed: handleUpload,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA50000),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Enviar foto"),
            ),
          ],
        ),
      ),
    );
  }
}