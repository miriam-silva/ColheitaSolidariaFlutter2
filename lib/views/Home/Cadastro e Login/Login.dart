import 'package:flutter/material.dart';
import '../../../widgets/LoadingSpinner.dart';
import '../../../services/AuthService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {

  String activeTab = "admin";

  final emailController =
      TextEditingController();

  final senhaController =
      TextEditingController();

  final cnpjController =
      TextEditingController();

  final chaveController =
      TextEditingController();

  bool loading = false;

  String error = "";

  final AuthService authService =
      AuthService();

  String getTituloLogin() {

    switch (activeTab) {

      case "admin":
        return "Administrador";

      case "colaborador":
        return "Colaborador";

      case "recebedor":
        return "Recebedor";

      default:
        return "";
    }
  }

  String getLabelTab(String tab) {

    switch (tab) {

      case "admin":
        return "ADMIN";

      case "colaborador":
        return "COLABORADOR";

      case "recebedor":
        return "RECEBEDOR";

      default:
        return "";
    }
  }

  Future<void> handleLogin() async {

    if (loading) return;

    if (emailController.text.isEmpty ||
        senhaController.text.isEmpty) {

      setState(() {
        error =
            "Preencha email e senha";
      });

      return;
    }

    if (activeTab == "admin") {

      if (cnpjController.text.isEmpty ||
          chaveController.text.isEmpty) {

        setState(() {
          error =
              "Preencha CNPJ e chave de acesso";
        });

        return;
      }
    }

    setState(() {
      loading = true;
      error = "";
    });

    try {

      final result =
          await authService.loginUser(

        email:
            emailController.text.trim(),

        password:
            senhaController.text.trim(),

        tipoUsuario: activeTab,

        cnpj:
            activeTab == "admin"
                ? cnpjController.text
                : null,

        chaveAcesso:
            activeTab == "admin"
                ? chaveController.text
                : null,
      );

      if (!mounted) return;

      if (result["success"]) {

        final role =
            result["data"]["role"];

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              "Login realizado com sucesso!",
            ),
          ),
        );

        if (role == "admin") {

          Navigator.pushReplacementNamed(
            context,
            "/admin",
          );

        } else if (
            role == "colaborador") {

          Navigator.pushReplacementNamed(
            context,
            "/colaborador",
          );

        } else {

          Navigator.pushReplacementNamed(
            context,
            "/recebedor",
          );
        }

      } else {

        setState(() {
          error =
              result["error"] ??
                  "Erro ao fazer login";
        });
      }

    } catch (e) {

      setState(() {
        error =
            "Erro inesperado ao fazer login";
      });
    }

    setState(() {
      loading = false;
    });
  }

  void changeTab(String tab) {

    setState(() {

      activeTab = tab;

      error = "";

      emailController.clear();
      senhaController.clear();
      cnpjController.clear();
      chaveController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFE8CF9C),

      body: Center(

        child: SingleChildScrollView(

          child: Container(

            margin:
                const EdgeInsets.all(16),

            child: LayoutBuilder(

              builder:
                  (context, constraints) {

                bool isMobile =
                    constraints.maxWidth < 768;

                return isMobile

                    ? Column(
                        children: [

                          _buildHero(isMobile),

                          _buildForm(isMobile),
                        ],
                      )

                    : Row(
                        children: [

                          Expanded(
                            child:
                                _buildHero(
                                    isMobile),
                          ),

                          Expanded(
                            child:
                                _buildForm(
                                    isMobile),
                          ),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero(bool isMobile) {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(30),

      decoration: BoxDecoration(

        color:
            const Color(0xFFA42525),

        borderRadius: isMobile

            ? const BorderRadius.only(
                topLeft:
                    Radius.circular(30),

                topRight:
                    Radius.circular(30),
              )

            : const BorderRadius.only(
                topLeft:
                    Radius.circular(30),

                bottomLeft:
                    Radius.circular(30),
              ),
      ),

      child: const Column(

        children: [

          Text(
            "Bem-vindo de volta à Colheita Solidária!",

            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),

          Padding(

            padding:
                EdgeInsets.symmetric(
                    horizontal: 20),

            child: Text(
              "Faça o login e vamos juntos colher frutos de esperança e distribuir solidariedade para quem mais precisa.",

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(bool isMobile) {

    return Container(

      padding:
          const EdgeInsets.all(30),

      decoration: const BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.only(

          bottomLeft:
              Radius.circular(30),

          bottomRight:
              Radius.circular(30),
        ),
      ),

      child: Column(

        children: [

          Row(

            mainAxisAlignment:
                MainAxisAlignment
                    .spaceAround,

            children: [

              _buildTab("admin"),

              _buildTab("colaborador"),

              _buildTab("recebedor"),
            ],
          ),

          const SizedBox(height: 20),

          Text(

            "Login ${getTituloLogin()}",

            style: const TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          if (error.isNotEmpty)

            Text(
              error,

              style: const TextStyle(
                color: Colors.red,
              ),
            ),

          if (loading)

            const Padding(

              padding:
                  EdgeInsets.all(10),

              child:
                  LoadingSpinner(
                size: 50,
              ),
            ),

          if (activeTab == "admin") ...[

            _input(
              cnpjController,
              "CNPJ",
            ),

            const SizedBox(height: 10),

            _input(
              chaveController,
              "Chave de acesso",
            ),

            const SizedBox(height: 10),
          ],

          _input(
            emailController,
            "E-mail",
          ),

          const SizedBox(height: 10),

          _input(
            senhaController,
            "Senha",
            isPassword: true,
          ),

          const SizedBox(height: 20),

          ElevatedButton(

            onPressed:
                loading
                    ? null
                    : handleLogin,

            style:
                ElevatedButton
                    .styleFrom(

              backgroundColor:
                  const Color(
                      0xFFA42525),

              foregroundColor:
                  Colors.white,

              minimumSize:
                  const Size(
                      double.infinity,
                      45),
            ),

            child: Text(
              loading
                  ? "Carregando..."
                  : "Acessar",
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(

            width: double.infinity,

            child:
                ElevatedButton.icon(

              onPressed: () async {

                if (loading) return;

                setState(() {

                  loading = true;

                  error = "";
                });

                final result =
                    await authService
                        .signInWithGoogle(
                  tipoUsuario:
                      activeTab,
                );

                if (!mounted) return;

                setState(() {
                  loading = false;
                });

                if (result["success"]) {

                  final role =
                      result["data"]
                          ["role"];

                  ScaffoldMessenger.of(
                          context)
                      .showSnackBar(

                    const SnackBar(
                      content: Text(
                        "Login Google realizado!",
                      ),
                    ),
                  );

                  if (role == "admin") {

                    Navigator
                        .pushReplacementNamed(
                      context,
                      "/admin",
                    );

                  } else if (
                      role ==
                          "colaborador") {

                    Navigator
                        .pushReplacementNamed(
                      context,
                      "/colaborador",
                    );

                  } else {

                    Navigator
                        .pushReplacementNamed(
                      context,
                      "/recebedor",
                    );
                  }

                } else {

                  setState(() {

                    error =
                        result["error"];
                  });
                }
              },

              icon: const Icon(
                Icons.login,
                color: Colors.black,
              ),

              label: const Text(
                "Entrar com Google",
              ),

              style:
                  ElevatedButton
                      .styleFrom(

                backgroundColor:
                    Colors.white,

                foregroundColor:
                    Colors.black,

                minimumSize:
                    const Size(
                        double.infinity,
                        45),

                side:
                    const BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          TextButton(

            onPressed: () {

              Navigator.pushNamed(
                context,
                "/cadastro",
              );
            },

            style:
                TextButton.styleFrom(
              foregroundColor:
                  Colors.black,
            ),

            child: const Text(
              "Não possui cadastro?",
            ),
          ),

          TextButton(

            onPressed: () {

              Navigator.pushNamed(
                context,
                "/home",
              );
            },

            style:
                TextButton.styleFrom(
              foregroundColor:
                  Colors.black,
            ),

            child:
                const Text("Voltar"),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String tab) {

    final isActive =
        activeTab == tab;

    final label =
        getLabelTab(tab);

    return GestureDetector(

      onTap: () =>
          changeTab(tab),

      child: Column(

        mainAxisSize:
            MainAxisSize.min,

        children: [

          Text(

            label,

            style: TextStyle(

              color: isActive
                  ? const Color(
                      0xFFA42525)
                  : Colors.grey,

              fontWeight: isActive
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),

          if (isActive)

            Container(

              margin:
                  const EdgeInsets.only(
                      top: 5),

              height: 3,

              width:
                  label.length * 8.0,

              color: const Color(
                  0xFFA42525),
            ),
        ],
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String hint, {
    bool isPassword = false,
  }) {

    return TextField(

      controller: controller,

      obscureText: isPassword,

      decoration: InputDecoration(

        hintText: hint,

        filled: true,

        fillColor:
            const Color(0xFFD3D2D2),

        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(5),

          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }
}