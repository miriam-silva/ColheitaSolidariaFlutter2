import 'package:flutter/material.dart';
import '../../Header/Drawer/AbaUsuariosPerfil_page.dart'; // 👈 importe seu drawer

class DefaultLayoutAdmin extends StatelessWidget {
  final Widget child;

  const DefaultLayoutAdmin({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔴 APPBAR (equivalente ao topo do seu Header)
      appBar: AppBar(
        backgroundColor: const Color(0xFFA50000),
        title: const Text("Colheita Solidária"),
        centerTitle: true,

        // 👇 Ícone de perfil (igual React)
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const CircleAvatar(
                backgroundImage: AssetImage("assets/receptor.png"),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),

      // 🔥 AQUI FICA O HEADER DINÂMICO (MENU LATERAL)
      drawer: const MeuDrawer(role: "admin"),

      // 📱 CONTEÚDO DAS TELAS
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}