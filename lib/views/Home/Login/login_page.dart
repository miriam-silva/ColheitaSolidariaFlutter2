import 'package:flutter/material.dart';
import '../../../widgets/LoadingSpinner.dart';
import '../../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String activeTab = "colaborador"; 

  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool loading = false;
  String error = "";

  final AuthService authService = AuthService();

  // 🔐 LOGIN COM FIREBASE
  void handleLogin() async {
    if (emailController.text.isEmpty || senhaController.text.isEmpty) {
      setState(() {
        error = "Preencha todos os campos";
      });
      return;
    }

    setState(() {
      loading = true;
      error = "";
    });

    final result = await authService.loginUser(
      email: emailController.text,
      password: senhaController.text,
    );

    setState(() {
      loading = false;
    });

    if (result["success"]) {
      final userData = result["data"];

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login realizado com sucesso!")),
      );

      // 🔀 REDIRECIONAMENTO PELO ROLE
      final role = userData["role"];

      if (role == "admin") {
        Navigator.pushReplacementNamed(context, "/admin");
      } else if (role == "colaborador") {
        Navigator.pushReplacementNamed(context, "/colaborador");
      } else {
        Navigator.pushReplacementNamed(context, "/recebedor");
      }
    } else {
      setState(() {
        error = result["error"];
      });
    }
  }

  void changeTab(String tab) {
    setState(() {
      activeTab = tab.toLowerCase();
      error = "";
    });
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
                          _buildHero(isMobile),
                          _buildForm(isMobile),
                        ],
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

  // 🔴 HERO
  Widget _buildHero(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
    );
  }

  // ⚪ FORMULÁRIO
  Widget _buildForm(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isMobile
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // 🔷 TABS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTab("admin"),
              _buildTab("colaborador"),
              _buildTab("recebedor"),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            "Login ${activeTab.toUpperCase()}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          if (error.isNotEmpty)
            Text(error, style: const TextStyle(color: Colors.red)),

          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: LoadingSpinner(size: 50),
            ),

          _input(emailController, "E-mail"),
          const SizedBox(height: 10),
          _input(senhaController, "Senha", isPassword: true),

          const SizedBox(height: 20),

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
            nome.toUpperCase(),
            style: TextStyle(
              color: isActive ? const Color(0xFFA42525) : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: 3,
              width: 40,
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