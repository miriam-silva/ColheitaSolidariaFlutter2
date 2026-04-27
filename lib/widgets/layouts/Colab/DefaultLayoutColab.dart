import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Header/Drawer/Drawer.dart';

class DefaultLayout4 extends StatelessWidget {
  final Widget child;

  const DefaultLayout4({
    super.key,
    required this.child,
  });

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
              icon: const _AvatarUser(),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),

      drawer: const MeuDrawer(
        role: "colaborador",
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _AvatarUser extends StatefulWidget {
  const _AvatarUser();

  @override
  State<_AvatarUser> createState() => _AvatarUserState();
}

class _AvatarUserState extends State<_AvatarUser> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const CircleAvatar(
        backgroundImage: AssetImage("assets/receptor.png"),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircleAvatar(
            backgroundImage: AssetImage("assets/receptor.png"),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;

        final foto = data?["fotoPerfil"];

        return CircleAvatar(
          radius: 18,
          backgroundImage: (foto != null && foto.toString().startsWith("http"))
              ? NetworkImage(foto)
              : const AssetImage("assets/receptor.png")
                  as ImageProvider,
        );
      },
    );
  }
}