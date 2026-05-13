import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../widgets/LoadingSpinner.dart';
import '../../../widgets/Utils/Validacao.dart';
import '../../../services/AuthService.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  String activeTab = "admin";

  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  final nome = TextEditingController();

  final cnpj = TextEditingController();

  final cpf = TextEditingController();

  final dataNascimento = TextEditingController();

  final email = TextEditingController();

  final telefone = TextEditingController();

  final endereco = TextEditingController();

  final senha = TextEditingController();

  final confirmarSenha = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final AuthService authService = AuthService();

  String getTitulo() {
    switch (activeTab) {
      case "admin":
        return "Administrador";

      case "colaborador":
        return "Colaborador";

      default:
        return "";
    }
  }

  String getLabelTab(String tab) {
    switch (tab) {
      case "admin":
        return "ADMINISTRADOR";

      case "colaborador":
        return "COLABORADOR";

      default:
        return "";
    }
  }

  void handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final tipo = activeTab;

    if (tipo == "admin" && Validacao.validarCNPJ(cnpj.text) != null) {
      _showError("CNPJ inválido");

      return;
    }

    if (tipo == "colaborador" && Validacao.validarCPF(cpf.text) != null) {
      _showError("CPF inválido");

      return;
    }

    setState(() {
      loading = true;
    });

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.text.trim(),

            password: senha.text.trim(),
          );

      final user = userCredential.user;

      if (user == null) {
        throw Exception("Usuário não criado");
      }

      await _firestore.collection("users").doc(user.uid).set({
        "nome": nome.text.trim(),

        "email": email.text.trim(),

        "telefone": telefone.text.trim(),

        "endereco": endereco.text.trim(),

        "dataNascimento": dataNascimento.text.trim(),

        "role": tipo,

        "cnpj": tipo == "admin" ? cnpj.text.trim() : null,

        "cpf": tipo == "colaborador" ? cpf.text.trim() : null,
      });

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cadastro realizado com sucesso!")),
      );

      Navigator.pushNamed(context, "/login");
    } catch (e) {
      setState(() {
        loading = false;
      });

      _showError("Erro ao cadastrar usuário");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void changeTab(String tab) {
    setState(() {
      activeTab = tab;
    });
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,

      initialDate: DateTime(2000),

      firstDate: DateTime(1900),

      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dataNascimento.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8CF9C),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),

            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 768;

                return isMobile
                    ? Column(
                        children: [_buildHero(isMobile), _buildForm(isMobile)],
                      )
                    : Row(
                        children: [
                          Expanded(child: _buildHero(isMobile)),

                          Expanded(child: _buildForm(isMobile)),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// HERO
  Widget _buildHero(bool isMobile) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(30),

      decoration: BoxDecoration(
        color: const Color(0xFFA42525),

        borderRadius: isMobile
            ? const BorderRadius.only(
                topLeft: Radius.circular(30),

                topRight: Radius.circular(30),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(30),

                bottomLeft: Radius.circular(30),
              ),
      ),

      child: const Column(
        children: [
          Text(
            "Junte-se a nós!",

            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),

            child: Text(
              "Faça o seu cadastro e ajude a contribuir para um futuro mais sustentável e solidário.",

              textAlign: TextAlign.center,

              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  /// FORM
  Widget _buildForm(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(30),

      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),

          bottomRight: Radius.circular(30),
        ),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [_buildTab("admin"), _buildTab("colaborador")],
          ),

          const SizedBox(height: 20),

          Text(
            "Cadastro ${getTitulo()}",

            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          if (loading)
            const Padding(
              padding: EdgeInsets.all(10),

              child: LoadingSpinner(size: 50),
            ),

          Form(
            key: _formKey,

            child: Column(
              children: [
                _input(nome, "Nome completo", validator: Validacao.validarNome),

                if (activeTab == "admin")
                  _input(cnpj, "CNPJ", validator: Validacao.validarCNPJ)
                else
                  _input(cpf, "CPF", validator: Validacao.validarCPF),

                GestureDetector(
                  onTap: _selectDate,

                  child: AbsorbPointer(
                    child: _input(
                      dataNascimento,
                      "Data de nascimento",
                      validator: Validacao.validarIdade,
                    ),
                  ),
                ),

                _input(email, "E-mail", validator: Validacao.validarEmail),

                _input(
                  telefone,
                  "Telefone",
                  validator: Validacao.validarTelefone,
                ),

                _input(
                  endereco,
                  "Endereço",
                  validator: Validacao.validarEndereco,
                ),

                _input(
                  senha,
                  "Senha",
                  obscure: true,
                  validator: Validacao.validarSenha,
                ),

                _input(
                  confirmarSenha,
                  "Confirmar senha",
                  obscure: true,

                  validator: (value) {
                    return Validacao.validarConfirmacaoSenha(
                      senha.text,

                      value ?? "",
                    );
                  },
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: loading ? null : handleSubmit,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA42525),

                      foregroundColor: Colors.white,

                      minimumSize: const Size(double.infinity, 45),
                    ),

                    child: Text(loading ? "Carregando..." : "Cadastrar"),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await authService.signInWithGoogle(
                        tipoUsuario: activeTab,

                        cadastro: true,
                      );

                      if (!mounted) {
                        return;
                      }

                      if (result["success"]) {
                        /// LOGOUT APÓS CADASTRO
                        await authService.logout();

                        if (!mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Cadastro Google realizado com sucesso!",
                            ),
                          ),
                        );

                        /// VOLTA LOGIN
                        Navigator.pushReplacementNamed(context, "/login");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result["error"])),
                        );
                      }
                    },

                    icon: const Icon(Icons.login, color: Colors.black),

                    label: const Text("Cadastrar com Google"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,

                      foregroundColor: Colors.black,

                      minimumSize: const Size(double.infinity, 45),

                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },

                  style: TextButton.styleFrom(foregroundColor: Colors.black),

                  child: const Text("Já possui cadastro? Faça login"),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/home");
                  },

                  style: TextButton.styleFrom(foregroundColor: Colors.black),

                  child: const Text("Voltar"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String tab) {
    final isActive = activeTab == tab;

    final label = getLabelTab(tab);

    return GestureDetector(
      onTap: () => changeTab(tab),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Text(
            label,

            style: TextStyle(
              color: isActive ? const Color(0xFFA42525) : Colors.grey,

              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),

          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 5),

              height: 3,

              width: label.length * 8.0,

              color: const Color(0xFFA42525),
            ),
        ],
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
}
