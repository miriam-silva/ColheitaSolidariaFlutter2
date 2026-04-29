import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../widgets/layouts/Adm/DefaultLayoutAdm.dart';
import '../InicialAdm/InicialAdm.dart';
import '../Painel/PainelMetricoAdm.dart';
import '../../../widgets/Utils/GerarPDFusuarios.dart';

class GerenciarUsuariosPage extends StatefulWidget {
  const GerenciarUsuariosPage({super.key});

  @override
  State<GerenciarUsuariosPage> createState() => _GerenciarUsuariosPageState();
}

class _GerenciarUsuariosPageState extends State<GerenciarUsuariosPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> usuarios = [];
  bool loading = true;

  String? editandoId;
  String mensagemSucesso = "";

  @override
  void initState() {
    super.initState();
    buscarUsuarios();
  }

  Future<void> buscarUsuarios() async {
    try {
      final snapshot = await _firestore.collection("users").get();

      setState(() {
        usuarios = snapshot.docs.map((doc) {
          final data = doc.data();

          return {
            "id": doc.id,
            "email": data["email"] ?? "",
            "nome": data["nome"] ?? "Sem nome",
            "role": data["role"] ?? "",
            "roleTemp": data["role"] ?? "",
          };
        }).toList();

        loading = false;
      });
    } catch (e) {
      debugPrint("Erro ao buscar usuários: $e");
      setState(() => loading = false);
    }
  }

  void handleEditar(Map<String, dynamic> usuario) {
    if (usuario["role"].toString().toLowerCase() == "admin") return;

    setState(() => editandoId = usuario["id"]);
  }

  void handleCancelar() {
    setState(() {
      editandoId = null;
      for (var u in usuarios) {
        u["roleTemp"] = u["role"];
      }
    });
  }

  void handleChangeRole(String id, String novoValor) {
    setState(() {
      usuarios = usuarios.map((u) {
        if (u["id"] == id) u["roleTemp"] = novoValor;
        return u;
      }).toList();
    });
  }

  Future<void> handleSalvar(String id) async {
    final usuario = usuarios.firstWhere((u) => u["id"] == id);

    await _firestore.collection("users").doc(id).update({
      "role": usuario["roleTemp"],
    });

    setState(() {
      usuario["role"] = usuario["roleTemp"];
      editandoId = null;
      mensagemSucesso = "Cargo atualizado com sucesso!";
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => mensagemSucesso = "");
    });
  }

  Future<void> handleExcluir(String id) async {
    await _firestore.collection("users").doc(id).delete();

    setState(() {
      usuarios.removeWhere((u) => u["id"] == id);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Usuário excluído!")));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayoutAdmin(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF6C973),
                border: Border.all(color: const Color(0xFFC1554C), width: 5),
              ),
              child: const Text(
                "Gerenciar Usuários",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            if (mensagemSucesso.isNotEmpty)
              Center(
                child: Text(
                  mensagemSucesso,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "Lista de usuários",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            /// TABELA RESPONSIVA
            if (loading)
              const Center(child: CircularProgressIndicator())
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = usuarios[index];

                  final isAdmin =
                      usuario["role"].toString().toLowerCase() == "admin";

                  final isEditando = editandoId == usuario["id"];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            usuario["nome"],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(usuario["email"]),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              const Text("Cargo: "),
                              const SizedBox(width: 8),

                              isEditando
                                  ? DropdownButton<String>(
                                      value: usuario["roleTemp"],
                                      items: const [
                                        DropdownMenuItem(
                                          value: "colaborador",
                                          child: Text("Colaborador"),
                                        ),
                                        DropdownMenuItem(
                                          value: "recebedor",
                                          child: Text("Recebedor"),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          handleChangeRole(
                                            usuario["id"],
                                            value,
                                          );
                                        }
                                      },
                                    )
                                  : Text(usuario["role"]),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              if (isAdmin)
                                const Text("Bloqueado")
                              else if (isEditando) ...[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFF276772,
                                    ), // verde salvar
                                    foregroundColor:
                                        Colors.white, // texto branco
                                  ),
                                  onPressed: () => handleSalvar(usuario["id"]),
                                  child: const Text("Salvar"),
                                ),

                                const SizedBox(width: 10),

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 99, 96, 96), // cinza editar/cancelar
                                    foregroundColor:
                                        Colors.white, // texto branco
                                  ),
                                  onPressed: handleCancelar,
                                  child: const Text("Cancelar"),
                                ),
                              ] else ...[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 99, 96, 96), // cinza editar
                                    foregroundColor:
                                        Colors.white, // texto branco
                                  ),
                                  onPressed: () => handleEditar(usuario),
                                  child: const Text("Editar"),
                                ),

                                const SizedBox(width: 10),

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor:
                                        Colors.white, // texto branco
                                  ),
                                  onPressed: () => handleExcluir(usuario["id"]),
                                  child: const Text("Excluir"),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 30),

            /// PAINEL
            PainelMetrico(usuarios: usuarios),

            const SizedBox(height: 30),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: () => gerarPDFUsuarios(usuarios),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA50000),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  "Exportar PDF Usuários",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            /// BOTÃO VOLTAR
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF276772),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InicialAdministrador(),
                      ),
                    );
                  },
                  child: const Text(
                    "Voltar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
