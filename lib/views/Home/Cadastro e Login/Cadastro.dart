import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../widgets/LoadingSpinner.dart';

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

  bool validarCPF(String cpf) => cpf.length >= 11;
  bool validarCNPJ(String cnpj) => cnpj.length >= 14;

  void handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (senha.text != confirmarSenha.text) {
      _showError("As senhas não coincidem!");
      return;
    }

    final tipo = activeTab;

    if (tipo == "admin" && !validarCNPJ(cnpj.text)) {
      _showError("CNPJ inválido!");
      return;
    }

    if (tipo == "colaborador" && !validarCPF(cpf.text)) {
      _showError("CPF inválido!");
      return;
    }

    setState(() => loading = true);

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.text,
        password: senha.text,
      );

      final user = userCredential.user;

      if (user == null) throw Exception("Usuário não criado");

      await user.reload();
      await user.getIdToken(true);

      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        throw Exception("Usuário não autenticado");
      }

      await _firestore.collection("users").doc(currentUser.uid).set({
        "nome": nome.text,
        "email": email.text,
        "telefone": telefone.text,
        "endereco": endereco.text,
        "dataNascimento": dataNascimento.text,
        "role": tipo,
        "cnpj": tipo == "admin" ? cnpj.text : null,
        "cpf": tipo == "colaborador" ? cpf.text : null,
      });

      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cadastro realizado com sucesso!")),
      );

      Navigator.pushNamed(context, "/login");
    } catch (e) {
      setState(() => loading = false);
      _showError("Erro ao cadastrar");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
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
      dataNascimento.text =
          "${picked.day}/${picked.month}/${picked.year}";
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
            children: [
              _buildTab("admin"),
              _buildTab("colaborador"),
            ],
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
                _input(nome, "Nome completo"),

                if (activeTab == "admin")
                  _input(cnpj, "CNPJ")
                else
                  _input(cpf, "CPF"),

                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer(
                    child: _input(dataNascimento, "Data de nascimento"),
                  ),
                ),

                _input(email, "E-mail"),
                _input(telefone, "Telefone"),
                _input(endereco, "Endereço"),
                _input(senha, "Senha", obscure: true),
                _input(confirmarSenha, "Confirmar senha", obscure: true),

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
                    child: Text(
                      loading ? "Carregando..." : "Cadastrar",
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () => Navigator.pushNamed(context, "/login"),
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                  child: const Text("Já possui cadastro? Faça login"),
                ),

                TextButton(
                  onPressed: () => Navigator.pushNamed(context, "/home"),
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
              width: label.length * 8.0, // 🔥 largura baseada no texto
              color: const Color(0xFFA42525),
            ),
        ],
      ),
    );
  }

  Widget _input(TextEditingController controller, String hint,
      {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: (value) =>
            value == null || value.isEmpty ? "Campo obrigatório" : null,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFD3D2D2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}