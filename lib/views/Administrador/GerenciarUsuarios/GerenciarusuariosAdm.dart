import 'package:flutter/material.dart';
import '../../../widgets/layouts/Adm/DefaultLayoutAdm.dart';

class GerenciarUsuariosPage extends StatefulWidget {
  const GerenciarUsuariosPage({super.key});

  @override
  State<GerenciarUsuariosPage> createState() =>
      _GerenciarUsuariosPageState();
}

class _GerenciarUsuariosPageState extends State<GerenciarUsuariosPage> {
  List<Map<String, dynamic>> usuarios = [];
  String? editandoId;
  String mensagemSucesso = "";

  @override
  void initState() {
    super.initState();
    buscarUsuarios();
  }

  Future<void> buscarUsuarios() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        usuarios = [
          {
            "id": 1,
            "email": "teste@email.com",
            "nomeCompleto": "João Silva",
            "role": "Colaborador",
            "uniqueId": "1"
          },
          {
            "id": 2,
            "email": "admin@email.com",
            "nomeCompleto": "Admin",
            "role": "Admin",
            "uniqueId": "2"
          }
        ];
      });
    } catch (e) {
      debugPrint("Erro ao buscar usuários: $e");
    }
  }

  void handleEditar(Map usuario) {
    if (usuario["role"] == "Admin") return;

    if (editandoId != null && editandoId != usuario["uniqueId"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Finalize a edição atual primeiro")),
      );
      return;
    }

    setState(() {
      editandoId =
          editandoId == usuario["uniqueId"] ? null : usuario["uniqueId"];
    });
  }

  void handleChangeRole(String uniqueId, String novoValor) {
    setState(() {
      usuarios = usuarios.map((u) {
        if (u["uniqueId"] == uniqueId) {
          u["roleTemp"] = novoValor;
        }
        return u;
      }).toList();
    });
  }

  Future<void> handleSalvar(String uniqueId) async {
    final usuario =
        usuarios.firstWhere((u) => u["uniqueId"] == uniqueId);

    final novoRole = usuario["roleTemp"] ?? usuario["role"];

    // ⚠️ confirmação
    if (usuario["role"] == "Colaborador" && novoRole == "Recebedor") {
      final confirmacao = await _confirmDialog(
        "Se confirmar, os dados serão apagados. Continuar?",
      );
      if (!confirmacao) return;
    }

    try {
      // 🔥 Aqui vai sua API depois

      setState(() {
        usuario["role"] = novoRole;
        usuario.remove("roleTemp");
        editandoId = null;
        mensagemSucesso =
            "Usuário ${usuario["nomeCompleto"]} atualizado!";
      });

      Future.delayed(const Duration(seconds: 3), () {
        setState(() => mensagemSucesso = "");
      });
    } catch (e) {
      debugPrint("Erro ao salvar: $e");
    }
  }

  void handleCancelar(String uniqueId) {
    setState(() {
      usuarios = usuarios.map((u) {
        if (u["uniqueId"] == uniqueId) {
          u.remove("roleTemp");
        }
        return u;
      }).toList();
      editandoId = null;
    });
  }

  Future<void> handleExcluir(String uniqueId) async {
    final usuario =
        usuarios.firstWhere((u) => u["uniqueId"] == uniqueId);

    if (usuario["role"] == "Admin") return;

    final confirmacao = await _confirmDialog("Deseja excluir?");
    if (!confirmacao) return;

    setState(() {
      usuarios.removeWhere((u) => u["uniqueId"] == uniqueId);
    });
  }

  Future<bool> _confirmDialog(String texto) async {
    return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Confirmação"),
            content: Text(texto),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Confirmar"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayoutAdmin(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // 🔶 Navbar
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
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.green,
                child: Text(
                  mensagemSucesso,
                  style: const TextStyle(color: Colors.white),
                ),
              ),

            const SizedBox(height: 20),

            const Text(
              "Lista de usuários",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),

            DataTable(
              columns: const [
                DataColumn(label: Text("Email")),
                DataColumn(label: Text("Nome")),
                DataColumn(label: Text("Cargo")),
                DataColumn(label: Text("Ações")),
              ],
              rows: usuarios.map((usuario) {
                final isEditando =
                    editandoId == usuario["uniqueId"];

                return DataRow(cells: [
                  DataCell(Text(usuario["email"])),
                  DataCell(Text(usuario["nomeCompleto"])),

                  DataCell(
                    isEditando
                        ? DropdownButton<String>(
                            value: usuario["roleTemp"] ??
                                usuario["role"],
                            items: const [
                              DropdownMenuItem(
                                  value: "Colaborador",
                                  child: Text("Colaborador")),
                              DropdownMenuItem(
                                  value: "Recebedor",
                                  child: Text("Recebedor")),
                            ],
                            onChanged: (value) {
                              handleChangeRole(
                                  usuario["uniqueId"], value!);
                            },
                          )
                        : Text(usuario["role"]),
                  ),

                  DataCell(
                    usuario["role"] == "Admin"
                        ? const Text("Sem ações")
                        : isEditando
                            ? Row(
                                children: [
                                  TextButton(
                                    onPressed: () => handleSalvar(
                                        usuario["uniqueId"]),
                                    child: const Text("Salvar"),
                                  ),
                                  TextButton(
                                    onPressed: () => handleCancelar(
                                        usuario["uniqueId"]),
                                    child: const Text("Cancelar"),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        handleEditar(usuario),
                                    child: const Text("Editar"),
                                  ),
                                  TextButton(
                                    onPressed: () => handleExcluir(
                                        usuario["uniqueId"]),
                                    child: const Text("Excluir"),
                                  ),
                                ],
                              ),
                  ),
                ]);
              }).toList(),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                debugPrint("Exportar PDF");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA50000),
              ),
              child: const Text("Exportar PDF Users"),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/adm");
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
    );
  }
}