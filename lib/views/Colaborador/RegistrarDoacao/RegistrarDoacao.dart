import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../widgets/layouts/Colab/DefaultLayoutColab.dart';
import '../../../widgets/Context/DoacoesContext.dart';
import '../../../widgets/Hooks/useDoacoes.dart';
import '../../../widgets/LoadingSpinner.dart';

class RegistrarDoacao extends StatefulWidget {
  const RegistrarDoacao({super.key});

  @override
  State<RegistrarDoacao> createState() => _RegistrarDoacaoState();
}

class _RegistrarDoacaoState extends State<RegistrarDoacao> {
  final TextEditingController produtoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();
  final TextEditingController validadeController = TextEditingController();

  File? imagemDoacao;
  bool loading = false;
  String mensagem = "";
  String tipoMensagem = "";

  final supabase = Supabase.instance.client;

  Future<void> selecionarImagem() async {
    final picker = ImagePicker();

    final XFile? imagem = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imagem != null) {
      setState(() {
        imagemDoacao = File(imagem.path);
      });
    }
  }

  Future<String?> uploadImagem(File imagem) async {
    try {
      final nomeArquivo =
          "${DateTime.now().millisecondsSinceEpoch}.jpg";

      await supabase.storage
          .from("doacoes")
          .upload(nomeArquivo, imagem);

      final imageUrl = supabase.storage
          .from("doacoes")
          .getPublicUrl(nomeArquivo);

      return imageUrl;
    } catch (e) {
      debugPrint("Erro ao enviar imagem para Supabase: $e");
      return null;
    }
  }

  void limparCampos() {
    produtoController.clear();
    descricaoController.clear();
    quantidadeController.clear();
    validadeController.clear();

    setState(() {
      imagemDoacao = null;
    });
  }

  void handleCancel() {
    limparCampos();

    Navigator.pushNamed(
      context,
      "/colaborador",
    );
  }

  Future<void> handleSubmit() async {
    setState(() {
      loading = true;
      mensagem = "";
    });

    try {
      if (produtoController.text.trim().isEmpty ||
          descricaoController.text.trim().isEmpty ||
          quantidadeController.text.trim().isEmpty ||
          validadeController.text.trim().isEmpty ||
          imagemDoacao == null) {
        setState(() {
          mensagem = "Preencha todos os campos corretamente.";
          tipoMensagem = "erro";
          loading = false;
        });
        return;
      }

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() {
          mensagem = "Usuário não autenticado.";
          tipoMensagem = "erro";
          loading = false;
        });
        return;
      }

      final imagemUrl = await uploadImagem(imagemDoacao!);

      if (imagemUrl == null) {
        setState(() {
          mensagem = "Erro ao enviar imagem.";
          tipoMensagem = "erro";
          loading = false;
        });
        return;
      }

      final doacoesContext = Provider.of<DoacoesContext>(
        context,
        listen: false,
      );

      final resultado = await registrarDoacao({
        "nome": produtoController.text.trim(),
        "descricao": descricaoController.text.trim(),
        "quantidade": quantidadeController.text.trim(),
        "validade": validadeController.text.trim(),
        "imagemUrl": imagemUrl,
        "usuarioId": user.uid,
      });

      if (resultado != null) {
        doacoesContext.adicionarDoacao(resultado);

        setState(() {
          mensagem = "Doação registrada com sucesso!";
          tipoMensagem = "sucesso";
        });

        limparCampos();

        Future.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.pushNamed(
              context,
              "/colaborador/DoacaoRegistrada",
            );
          },
        );
      } else {
        setState(() {
          mensagem = "Erro ao registrar doação.";
          tipoMensagem = "erro";
        });
      }
    } catch (e) {
      setState(() {
        mensagem = "Erro inesperado ao registrar doação.";
        tipoMensagem = "erro";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    produtoController.dispose();
    descricaoController.dispose();
    quantidadeController.dispose();
    validadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout4(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF6C973),
                border: Border.all(
                  color: const Color(0xFFC1554C),
                  width: 5,
                ),
              ),
              child: const Text(
                "Registrar Doação:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (mensagem.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: tipoMensagem == "sucesso"
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(mensagem),
              ),

            const Text(
              "Nome do produto:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            TextField(
              controller: produtoController,
              decoration: const InputDecoration(
                hintText: "Ex: Pepinos",
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Descrição do produto:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            TextField(
              controller: descricaoController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText:
                    "Ex: Pepinos maduros separados em caixas de 10kg",
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Quantidade:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            TextField(
              controller: quantidadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Ex: 10",
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Validade:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            TextField(
              controller: validadeController,
              decoration: const InputDecoration(
                hintText: "Ex: 2026-04-20",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: selecionarImagem,
              child: const Text(
                "Selecionar Foto da Doação",
              ),
            ),

            if (imagemDoacao != null)
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Image.file(
                  imagemDoacao!,
                  height: 200,
                ),
              ),

            const SizedBox(height: 30),

            if (loading)
              const Center(
                child: LoadingSpinner(),
              ),

            const SizedBox(height: 20),

            Row(
              children: [
                ElevatedButton(
                  onPressed: handleCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Cancelar"),
                ),

                const SizedBox(width: 12),

                ElevatedButton(
                  onPressed: loading ? null : handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text("Enviar"),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}