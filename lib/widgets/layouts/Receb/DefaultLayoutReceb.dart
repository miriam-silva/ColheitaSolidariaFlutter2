import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Header/Drawer/Drawer.dart';

class DefaultLayoutRecebedor extends StatefulWidget {
  final Widget child;

  const DefaultLayoutRecebedor({
    super.key,
    required this.child,
  });

  @override
  State<DefaultLayoutRecebedor> createState() =>
      _DefaultLayoutRecebedorState();
}

class _DefaultLayoutRecebedorState extends State<DefaultLayoutRecebedor> {
  String fotoPerfil = "assets/receptor.png";

  @override
  void initState() {
    super.initState();
    carregarFoto();
  }

  Future<void> carregarFoto() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    final data = doc.data();

    if (!mounted) return;

    setState(() {
      fotoPerfil = data?["fotoPerfil"] ?? "assets/receptor.png";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA50000),
        title: const Text("Colheita Solidária"),
        centerTitle: true,

        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: CircleAvatar(
                backgroundImage: fotoPerfil.startsWith("http")
                    ? NetworkImage(fotoPerfil)
                    : AssetImage(fotoPerfil) as ImageProvider,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),

      drawer: const MeuDrawer(
        role: "recebedor",
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}