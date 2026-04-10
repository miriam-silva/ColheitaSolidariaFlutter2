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
  String activeTab = 'adm';
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

  bool validarCPF(String cpf) => cpf.length >= 11;
  bool validarCNPJ(String cnpj) => cnpj.length >= 14;

  void handleSubmit() async {
  if (!_formKey.currentState!.validate()) return;

  if (senha.text != confirmarSenha.text) {
    _showError("As senhas não coincidem!");
    return;
  }

  final tipo = activeTab == "adm" ? "admin" : "colaborador";

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
    // 🔐 CRIA USUÁRIO
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email.text,
      password: senha.text,
    );

    final user = userCredential.user;

    if (user == null) throw Exception("Usuário não criado");

    // 🔥 GARANTE QUE O FIRESTORE RECONHEÇA O AUTH
   await user.getIdToken(true);
    // 📦 SALVA NO FIRESTORE
    await _firestore.collection("users").doc(userCredential.user!.uid).set({
      "nome": nome.text,
      "email": email.text,
      "telefone": telefone.text,
      "endereco": endereco.text,
      "dataNascimento": dataNascimento.text,
      "role": tipo,
      "cnpj": tipo == "admin" ? cnpj.text : null,
      "cpf": tipo == "colaborador" ? cpf.text : null,
    }, SetOptions(merge: false));

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cadastro realizado com sucesso!")),
    );

    Navigator.pushNamed(context, "/login");

  } catch (e) {
    setState(() => loading = false);

  if (e is FirebaseAuthException) {
    print("CÓDIGO: ${e.code}");
    print("MENSAGEM: ${e.message}");

    _showError(e.message ?? "Erro no cadastro");
  } else {
    print("ERRO COMPLETO: $e");
    _showError("Erro inesperado");
  }
}
}
  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
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
          "${picked.year}-${picked.month}-${picked.day}";
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
                        children: [
                          _buildHero(),
                          _buildForm(),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(child: _buildHero()),
                          Expanded(child: _buildForm()),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFA42525),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Column(
        children: [
          Text(
            "Junte-se a nós!",
            style: TextStyle(fontSize: 32, color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            "Faça o seu cadastro e ajude a contribuir para um futuro mais sustentável.",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _tabButton("Administrador", "adm"),
              _tabButton("Colaborador", "colaborador"),
            ],
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  activeTab == "adm"
                      ? "Cadastro Administrador"
                      : "Cadastro Colaborador",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                if (loading) const LoadingSpinner(),
                _input(nome, "Nome completo"),
                if (activeTab == "adm")
                  _input(cnpj, "CNPJ")
                else
                  _input(cpf, "CPF"),
                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer(
                    child: _input(dataNascimento, "Data de nascimento"),
                  ),
                ),
                _input(email, "Email"),
                _input(telefone, "Telefone"),
                _input(endereco, "Endereço"),
                _input(senha, "Senha", obscure: true),
                _input(confirmarSenha, "Confirme sua senha", obscure: true),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA42525),
                    ),
                    child: Text(
                      loading ? "Carregando..." : "Cadastrar",
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
                  child: const Text("Já possui cadastro? Faça login"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/home");
                  },
                  child: const Text("Voltar para início"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String texto, String valor) {
    final isActive = activeTab == valor;

    return GestureDetector(
      onTap: () => setState(() => activeTab = valor),
      child: Column(
        children: [
          Text(
            texto,
            style: TextStyle(
              color: isActive ? const Color(0xFFA42525) : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: 3,
              width: 50,
              color: const Color(0xFFA42525),
            )
        ],
      ),
    );
  }

  Widget _input(TextEditingController controller, String label,
      {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: (value) =>
            value == null || value.isEmpty ? "Campo obrigatório" : null,
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: const Color(0xFFD3D2D2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}