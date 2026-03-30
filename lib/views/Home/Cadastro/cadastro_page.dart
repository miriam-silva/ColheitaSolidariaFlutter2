import 'package:flutter/material.dart';
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

  // Controllers
  final nome = TextEditingController();
  final cnpj = TextEditingController();
  final cpf = TextEditingController();
  final dataNascimento = TextEditingController();
  final email = TextEditingController();
  final telefone = TextEditingController();
  final endereco = TextEditingController();
  final senha = TextEditingController();
  final confirmarSenha = TextEditingController();

  void handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (senha.text != confirmarSenha.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não coincidem!")),
      );
      return;
    }

    setState(() => loading = true);

    await Future.delayed(const Duration(seconds: 2)); // simulação API

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cadastro realizado com sucesso!")),
    );

    if (activeTab == 'adm') {
      Navigator.pushNamed(context, '/InicialAdministrador');
    } else {
      Navigator.pushNamed(context, '/InicialColaborador');
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
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

  // 🔴 LADO ESQUERDO
  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
        color: Color(0xFFA42525),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Junte-se a nós!",
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            "Faça o seu cadastro e ajude a contribuir para um futuro mais sustentável e solidário.",
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ⚪ LADO DIREITO
  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // 🔘 TABS
          Row(
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

                _input(dataNascimento, "Data de nascimento"),
                _input(email, "Email"),
                _input(telefone, "Telefone"),
                _input(endereco, "Endereço"),
                _input(senha, "Senha", obscure: true),
                _input(confirmarSenha, "Confirmar senha", obscure: true),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: loading ? null : handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA42525),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    loading ? "Carregando..." : "Cadastrar",
                  ),
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text("Já possui cadastro? Faça login"),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
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

  // 🔘 BOTÃO DE TAB
  Widget _tabButton(String texto, String valor) {
    final isActive = activeTab == valor;

    return Expanded(
      child: TextButton(
        onPressed: () {
          setState(() => activeTab = valor);
        },
        child: Text(
          texto,
          style: TextStyle(
            color: isActive ? Colors.red : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // 🔤 INPUT PADRÃO
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
          labelText: label,
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}