import 'package:flutter/material.dart';
import '../../../widgets/LoadingSpinner.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String activeTab = "Administrador";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController chaveController = TextEditingController();

  bool loading = false;
  String error = "";

  void handleLogin() async {
    setState(() {
      loading = true;
      error = "";
    });

    await Future.delayed(const Duration(seconds: 2)); // simulação

    setState(() {
      loading = false;
      error = "Login simulado (integre com API depois)";
    });
  }

  void changeTab(String tab) {
    setState(() {
      activeTab = tab;
      error = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8CF9C),

      body: Center(
        child: Container(
          width: 900,
          constraints: const BoxConstraints(maxWidth: 1000),
          margin: const EdgeInsets.all(20),

          child: Row(
            children: [

              // 🔴 LADO ESQUERDO
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: const BoxDecoration(
                    color: Color(0xFFA42525),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Bem-vindo de volta à Colheita Solidária!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Faça o login e vamos juntos colher frutos de esperança e distribuir solidariedade.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),

              // ⚪ LADO DIREITO
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // 🔷 TABS
                      Wrap(
                        spacing: 10,
                        children: [
                          _buildTab("Administrador"),
                          _buildTab("colaborador"),
                          _buildTab("recebedor"),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Login ${activeTab[0].toUpperCase()}${activeTab.substring(1)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ❌ ERRO
                      if (error.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            error,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      // 🔄 LOADING (SEU WIDGET)
                      if (loading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: LoadingSpinner(size: 60),
                        ),

                      // 🔶 CAMPOS ADMIN
                      if (activeTab == "Administrador") ...[
                        _input(cnpjController, "CNPJ"),
                        const SizedBox(height: 10),
                        _input(chaveController, "Chave de Acesso"),
                        const SizedBox(height: 10),
                      ],

                      // 🔶 CAMPOS COMUNS
                      _input(emailController, "E-mail"),
                      const SizedBox(height: 10),
                      _input(senhaController, "Senha", isPassword: true),

                      const SizedBox(height: 20),

                      // 🔘 BOTÃO
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading ? null : handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA42525),
                            padding: const EdgeInsets.all(15),
                          ),
                          child: Text(
                            loading ? "Carregando..." : "Acessar",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔗 LINKS
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/cadastro");
                        },
                        child: const Text("Não possui cadastro? Clique aqui"),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔷 TAB
  Widget _buildTab(String nome) {
    final isActive = activeTab == nome;

    return GestureDetector(
      onTap: () => changeTab(nome),
      child: Column(
        children: [
          Text(
            nome[0].toUpperCase() + nome.substring(1),
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

  // 🔷 INPUT
  Widget _input(TextEditingController controller, String hint,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFD3D2D2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}