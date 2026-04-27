import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../widgets/layouts/Adm/DefaultLayoutAdm.dart';

class CadastrarRecebedorAdmPage extends StatefulWidget {
  const CadastrarRecebedorAdmPage({super.key});

  @override
  State<CadastrarRecebedorAdmPage> createState() =>
      _CadastrarRecebedorAdmPageState();
}

class _CadastrarRecebedorAdmPageState extends State<CadastrarRecebedorAdmPage> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final dataNascimentoController = TextEditingController();
  final numFamiliaresController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  bool loading = false;
  String mensagemErro = "";
  String mensagemSucesso = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (senhaController.text != confirmarSenhaController.text) {
      setState(() {
        mensagemErro = "As senhas não coincidem.";
      });
      return;
    }

    setState(() {
      mensagemErro = "";
      mensagemSucesso = "";
      loading = true;
    });

    try {
      // 🔐 1. CRIA USUÁRIO NO AUTH
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      final user = userCredential.user;

      if (user == null) {
        throw Exception("Erro ao criar usuário");
      }

      // 📄 2. SALVA NO FIRESTORE COM UID
      await _firestore.collection("users").doc(user.uid).set({
        "nome": nomeController.text,
        "cpf": cpfController.text,
        "dataNascimento": dataNascimentoController.text,
        "numFamiliares": int.tryParse(numFamiliaresController.text) ?? 0,
        "email": emailController.text,
        "telefone": telefoneController.text,
        "role": "recebedor",
        "createdAt": FieldValue.serverTimestamp(),
      });

      setState(() {
        mensagemSucesso = "Recebedor cadastrado com sucesso!";
        loading = false;
      });

      // 🔁 Redireciona depois de 2s
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushNamed(context, "/InicialAdministrador");
      });
    } on FirebaseAuthException catch (e) {
      String erro = "Erro ao cadastrar";

      if (e.code == 'email-already-in-use') {
        erro = "Esse email já está em uso";
      } else if (e.code == 'weak-password') {
        erro = "A senha deve ter pelo menos 6 caracteres";
      } else if (e.code == 'invalid-email') {
        erro = "Email inválido";
      }

      setState(() {
        mensagemErro = erro;
        loading = false;
      });
    } catch (e) {
      setState(() {
        mensagemErro = "Erro ao cadastrar o recebedor.";
        loading = false;
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dataNascimentoController.text =
          "${picked.year}-${picked.month}-${picked.day}";
    }
  }

  @override
Widget build(BuildContext context) {
  return DefaultLayoutAdmin(
    child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
            ),
            child: Column(
              children: [
                // 🔴 HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    color: Color(0xFFA42525),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "Cadastre um novo membro!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Amplie a rede de solidariedade e ajude a construir um futuro mais justo.",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // ⚪ FORM
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildInput("Nome completo", nomeController),
                        _buildInput("CPF", cpfController),
                        GestureDetector(
                          onTap: _selectDate,
                          child: AbsorbPointer(
                            child: _buildInput(
                              "Data de nascimento",
                              dataNascimentoController,
                            ),
                          ),
                        ),
                        _buildInput(
                          "Número de familiares",
                          numFamiliaresController,
                          isNumber: true,
                        ),
                        _buildInput("Email", emailController),
                        _buildInput("Telefone", telefoneController),
                        _buildInput("Senha", senhaController, isPassword: true),
                        _buildInput(
                          "Confirmar senha",
                          confirmarSenhaController,
                          isPassword: true,
                        ),

                        if (mensagemErro.isNotEmpty)
                          Text(
                            mensagemErro,
                            style: const TextStyle(color: Colors.red),
                          ),

                        if (mensagemSucesso.isNotEmpty)
                          Text(
                            mensagemSucesso,
                            style: const TextStyle(color: Colors.green),
                          ),

                        const SizedBox(height: 15),

                        loading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFA50000),
                                  ),
                                  child: const Text("Criar cadastro"),
                                ),
                              ),

                        const SizedBox(height: 15),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/admin");
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFF276772),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Voltar"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) =>
            value == null || value.isEmpty ? "Campo obrigatório" : null,
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
