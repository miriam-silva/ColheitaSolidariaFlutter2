import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../services/PerfilService.dart';
import '../../../widgets/Utils/Validacao.dart';

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

  Future<void> abrirEditarCadastro() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    final data = doc.data();

    final providerGoogle = user.providerData.any(
      (provider) => provider.providerId == "google.com",
    );

    final formKey = GlobalKey<FormState>();

    final nomeController = TextEditingController(text: data?["nome"] ?? "");

    final emailController = TextEditingController(text: data?["email"] ?? "");

    final telefoneController = TextEditingController(
      text: data?["telefone"] ?? "",
    );

    final enderecoController = TextEditingController(
      text: data?["endereco"] ?? "",
    );

    final dataNascimentoController = TextEditingController(
      text: data?["dataNascimento"] ?? "",
    );

    final cpfController = TextEditingController(text: data?["cpf"] ?? "");

    final cnpjController = TextEditingController(text: data?["cnpj"] ?? "");

    final senhaController = TextEditingController();

    final confirmarSenhaController = TextEditingController();

    bool loading = false;

    String mensagem = "";

    Color corMensagem = Colors.green;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,

              child: Container(
                width: 850,

                padding: const EdgeInsets.all(25),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Center(
                          child: Text(
                            "Editar cadastro",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        _label("Nome"),

                        _input(
                          nomeController,
                          "Digite seu nome completo",
                          validator: Validacao.validarNome,
                        ),

                        if (widget.role == "admin") ...[
                          _label("CNPJ"),

                          _input(
                            cnpjController,
                            "Digite seu CNPJ",
                            validator: Validacao.validarCNPJ,
                          ),
                        ],

                        if (widget.role == "colaborador") ...[
                          _label("CPF"),

                          _input(
                            cpfController,
                            "Digite seu CPF",
                            validator: Validacao.validarCPF,
                          ),
                        ],

                        _label("Data de nascimento"),

                        GestureDetector(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2000),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (picked != null) {
                              dataNascimentoController.text =
                                  "${picked.day}/${picked.month}/${picked.year}";
                            }
                          },

                          child: AbsorbPointer(
                            child: _input(
                              dataNascimentoController,
                              "Selecione sua data",
                              validator: Validacao.validarIdade,
                            ),
                          ),
                        ),

                        _label("E-mail"),

                        _input(
                          emailController,
                          "Digite seu e-mail",
                          validator: Validacao.validarEmail,
                        ),

                        _label("Telefone"),

                        _input(
                          telefoneController,
                          "Digite seu telefone",
                          validator: Validacao.validarTelefone,
                        ),

                        _label("Endereço"),

                        _input(
                          enderecoController,
                          "Rua, número, bairro...",
                          validator: Validacao.validarEndereco,
                        ),

                        if (!providerGoogle) ...[
                          _label("Nova senha"),

                          _input(
                            senhaController,
                            "Digite sua nova senha",
                            obscure: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }

                              return Validacao.validarSenha(value);
                            },
                          ),

                          _label("Confirmar nova senha"),

                          _input(
                            confirmarSenhaController,
                            "Confirme sua nova senha",
                            obscure: true,
                            validator: (value) {
                              if (senhaController.text.isEmpty) {
                                return null;
                              }

                              return Validacao.validarConfirmacaoSenha(
                                senhaController.text,
                                value ?? "",
                              );
                            },
                          ),
                        ],

                        const SizedBox(height: 10),

                        if (mensagem.isNotEmpty)
                          Container(
                            width: double.infinity,

                            padding: const EdgeInsets.all(12),

                            decoration: BoxDecoration(
                              color: corMensagem.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: corMensagem),
                            ),

                            child: Text(
                              mensagem,
                              style: TextStyle(
                                color: corMensagem,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA50000),
                                foregroundColor: Colors.white,
                              ),

                              onPressed: loading
                                  ? null
                                  : () {
                                      Navigator.pop(context);
                                    },

                              child: const Text("Cancelar"),
                            ),

                            const SizedBox(width: 10),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF276772),
                                foregroundColor: Colors.white,
                              ),

                              onPressed: loading
                                  ? null
                                  : () async {
                                      if (!formKey.currentState!.validate()) {
                                        return;
                                      }

                                      setStateDialog(() {
                                        loading = true;
                                        mensagem = "";
                                      });

                                      try {
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(user.uid)
                                            .update({
                                              "nome": nomeController.text
                                                  .trim(),
                                              "email": emailController.text
                                                  .trim(),
                                              "telefone": telefoneController
                                                  .text
                                                  .trim(),
                                              "endereco": enderecoController
                                                  .text
                                                  .trim(),
                                              "dataNascimento":
                                                  dataNascimentoController.text
                                                      .trim(),
                                              "cpf":
                                                  widget.role == "colaborador"
                                                  ? cpfController.text.trim()
                                                  : null,
                                              "cnpj": widget.role == "admin"
                                                  ? cnpjController.text.trim()
                                                  : null,
                                            });

                                        if (emailController.text.trim() !=
                                            user.email) {
                                          await user.verifyBeforeUpdateEmail(
                                            emailController.text.trim(),
                                          );
                                        }

                                        if (!providerGoogle &&
                                            senhaController.text.isNotEmpty) {
                                          await user.updatePassword(
                                            senhaController.text.trim(),
                                          );
                                        }

                                        await carregarUsuario();

                                        setStateDialog(() {
                                          loading = false;

                                          mensagem =
                                              "Dados alterados com sucesso!";

                                          corMensagem = Colors.green;
                                        });
                                      } catch (e) {
                                        setStateDialog(() {
                                          loading = false;

                                          mensagem =
                                              "Erro ao atualizar cadastro.";

                                          corMensagem = Colors.red;
                                        });
                                      }
                                    },

                              child: Text(loading ? "Salvando..." : "Salvar"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
          {"label": "Editar cadastro", "action": abrirEditarCadastro},
          {"label": "Alterar foto de perfil", "action": escolherImagem},
        ];

      case "colaborador":
        return [
          {"label": "Minhas doações", "route": "/colaborador"},
          {
            "label": "Registrar doações",
            "route": "/colaborador/Registrardoacao",
          },
          {"label": "Editar cadastro", "action": abrirEditarCadastro},
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
          {"label": "Editar cadastro", "action": abrirEditarCadastro},
          {"label": "Alterar foto de perfil", "action": escolherImagem},
        ];

      default:
        return [];
    }
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 5),

      child: Text(
        text,

        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String hint, {
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,

        decoration: InputDecoration(
          hintText: hint,

          filled: true,

          fillColor: const Color(0xFFD3D2D2),

          errorMaxLines: 2,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menus = getMenus();

    return Drawer(
      width: 300,

      backgroundColor: const Color.fromARGB(255, 255, 254, 252),

      child: Column(
        children: [
          Container(
            width: double.infinity,

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

                colors: [
                  Color.fromRGBO(247, 205, 122, 1),
                  Color.fromARGB(255, 255, 254, 252),
                ],
              ),
            ),

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
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  emailUsuario,

                  style: const TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
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
